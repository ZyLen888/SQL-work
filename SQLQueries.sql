-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\_____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////____/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\_____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\____/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////____\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\___________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\____________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\______________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///_________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: Zhen Liu
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1

SELECT DISTINCT user1 AS userID
FROM friendof
WHERE WhenRequested IS NOT NULL AND WhenRejected IS NULL AND WhenConfirmed IS NULL;

-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2

SELECT forum.id AS forumId, forum.topic AS topic, COUNT(subscribe.User) AS numSubs
FROM forum LEFT JOIN subscribe ON forum.id = subscribe.forum
GROUP BY forum.id
HAVING numSubs >= 1;

-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3

SELECT forum AS forumId, Id AS postId, WhenPosted AS whenPosted
FROM post
WHERE WhenPosted = (SELECT MAX(WhenPosted)
					FROM post
                    WHERE post.forum IS NOT NULL);

-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4

SELECT following AS 'userId of followed', follower AS 'userId of follower'
FROM following
ORDER BY following ASC, follower ASC;

-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5

SELECT forum.CreatedBy AS adminId, forum.Id AS forumId, COUNT(upvote.user) AS numberOfUpvotesInForum 
FROM forum INNER JOIN post ON forum.id = post.forum INNER JOIN upvote ON post.id = upvote.post
GROUP BY forum.id
ORDER BY numberOfUpvotesInForum DESC
LIMIT 1;

-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6

-- This answer will include admins as specified on EdStem forum post #394 that including admin is acceptable 

SELECT id AS userId, username AS username
FROM user
WHERE id NOT IN (SELECT Following FROM following) AND -- Finding user with no follower
	  id NOT IN (SELECT generaluser.id -- Finding general user with no friends
				 FROM generaluser INNER JOIN friendof ON (generaluser.id = friendof.user1 OR generaluser.id = friendof.user2)
                 WHERE WhenConfirmed IS NOT NULL  AND WhenUnfriended IS NULL);

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7

SELECT user.id AS userId, COUNT(upvote.user) / COUNT(DISTINCT post.id) AS avgUpvotes
FROM user INNER JOIN post ON user.id = post.PostedBy LEFT JOIN upvote ON post.Id = upvote.Post
GROUP BY user.id
HAVING (COUNT(upvote.user) / COUNT(DISTINCT post.id)) > 1;

-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

SELECT id AS PostORCommentId
FROM post
 -- If there is one child post that has less upvote than its parent post, then this parent post doesn't satisfy the requirement
WHERE id NOT IN (SELECT parent.id
				 FROM post AS parent LEFT JOIN post AS child ON parent.id = child.Parentpost
                 WHERE ((SELECT COUNT(user) -- Number of upvotes of parent post
						 FROM upvote 
                         WHERE upvote.Post = parent.id)) >= (SELECT COUNT(user) -- Number of upvotes of child post
															FROM upvote 
                                                            WHERE upvote.Post = child.id));


-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9

SELECT id AS userID
FROM user
WHERE id NOT IN (SELECT user
				 FROM post INNER JOIN upvote ON post.Id = upvote.Post
                 -- These users don’t like any posts of someone who is not an admin and not currently their friend
                 WHERE ((PostedBy NOT IN (SELECT user1
										 FROM friendof 
                                         WHERE user2 = upvote.user AND WhenConfirmed IS NOT NULL AND WhenUnfriended IS NULL)
						AND PostedBy NOT IN (SELECT user2 
											 FROM friendof 
											 WHERE user1 = upvote.user AND WhenConfirmed IS NOT NULL AND WhenUnfriended IS NULL)
						AND PostedBy NOT IN (SELECT id
											 FROM admin))
						-- Users who have liked their own posts should not be returned.
						OR PostedBy = upvote.user)
                        -- Verify these people upvoted the posts
                        AND id IN (SELECT User
								   FROM upvote));

-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10

SELECT newadmin.id AS adminID, newforum.id AS forumId, COUNT(newsubscribe.user) AS numSubscriptions
-- Renaming the tables otherwise the subquery will have conflict with table name
FROM admin AS newadmin LEFT JOIN forum as newforum ON newadmin.ID = newforum.CreatedBy LEFT JOIN subscribe AS newsubscribe ON newforum.Id = newsubscribe.Forum
GROUP BY newadmin.Id, newforum.Id
HAVING COUNT(User) = (SELECT COUNT(subscribe.User) -- Return the maximum number of subscription of the forums created by each admin
					  FROM admin LEFT JOIN forum ON admin.ID = forum.CreatedBy LEFT JOIN subscribe ON forum.Id = subscribe.Forum
					  WHERE admin.Id = newadmin.Id
                      GROUP BY forum.id
                      ORDER BY COUNT(newsubscribe.user) DESC
                      LIMIT 1);



-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line
