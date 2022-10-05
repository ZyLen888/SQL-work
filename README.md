# SQL-work
💻 SQL work done as part of school project

## ✅ DB Assignment 2 Dataset Description  

You and a group of fellow undergrads have created a start-up called ‘newQuora’. The company’s goal is to create an online question-and-answer forum for users around the world.
The system has two kinds of users: general and admins. Most user attributes are straightforward personal information and are listed in the ER diagram below.
Discussions are organized into forums, each of which is about a particular topic. New forums can be opened by admins. Users can subscribe to any number of forums to get regular updates.  

Users can create a ‘post’ in any forum, which becomes a topic for discussion. Any user can comment on a post, or on comments of a post (nested comments). Users can also “upvote” a post or comment.  

General users (but not admins) can have different “relationships” among themselves. One user can be “following” another to receive updates when they post or comment. Note that following is a non- symmetric relation: if A is following B, that does not imply B is following A. A is denoted as a “follower” of B.  

General users (but not admins) can also add each other to friend-lists. When one user sends a friend- request to another, the latter can reject or accept the friendship. If the latter accepts, the pair are now friends. Note that friendship is a symmetric relation: if A is a friend of B, then B is a friend of A, whether A sent the friend request to B or vice-versa. Once a pair of users are friends, either may later unfriend the other, in which case the friendship ends for both. A user’s “friends” means their current “confirmed” friends, not those where the friendship has ended or not begun.
