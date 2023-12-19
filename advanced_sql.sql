
-- 1. Create an ER diagram or draw a schema for the given database.
select Database in mysql workbench-> select reverse engineer-> Select the Database whose ER diagram is to be displayed-> continue-> continue 
 (until the ER diag is displayed)

-- 2.We want to reward the user who has been around the longest, Find the 5 oldest users.
select username from users 
order by created_at asc
limit 5;


-- 3.To target inactive users in an email ad campaign, find the users who have never posted a photo.
select * from users where id not in (select user_id from photos);


-- 4.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
with most_likes as (
select username, count(l.user_id) as likes_count from users u inner join likes l on u.id=l.user_id
group by username)
select * from most_likes 
where likes_count in (select max(likes_count) from most_likes);


-- 5.The investors want to know how many times does the average user post.
 select count(photos.id)/(select count(users.id) from users) avg_user_post from photos;
 

-- 6.A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
with hashtags as
(select tag_id,tag_name, count(tag_id) from photo_tags p
inner join tags t on p.tag_id=t.id
group by 1
order by 3 desc
limit 5)
select * from hashtags;


-- 7.To find out if there are bots, find users who have liked every single photo on the site.
with cte as
(select count(user_id) likes_count, user_id from likes
group by user_id)

select u.username, likes_count from users u
inner join cte c on c.user_id=u.id
where likes_count in (select count(id) from photos);


-- 8.Find the users who have created instagramid in may and select top 5 newest joinees from it?
select username from users where month(created_at)=5 limit 5;


-- 9.Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?

 with user_c as
 (select id,username from users where username regexp '^[c].*[0-9]$') ,
 posted_liked as
(select uc.username,uc.id from user_c uc inner join photos p on uc.id=p.user_id
inner join likes l on l.user_id=p.user_id)
select distinct(username), id from posted_liked;



-- 10.Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.
with photo_count as
(select username, count(*) photos_posted from photos p 
inner join users u on p.user_id=u.id
group by user_id
order by 2 desc)




 
select username, photos_posted from photo_count 
where photos_posted between 3 and 5
limit 30;

