/*For each user_id, find the difference between the last action and the second last action. Action
here is defined as visiting a page.*/
SELECT a.user_id, a.time_diff 
FROM 
(
  SELECT user_id, 
	   unix_timestamp,
	   RANK() OVER (partition by user_id ORDER BY unix_timestamp DESC) as rank, 
       lag(unix_timestamp, 1) over(partition by user_id order by unix_timestamp) as lag,
	   unix_timestamp - lag(unix_timestamp, 1) over(partition by user_id order by unix_timestamp) as time_diff
  from dbo.query_one
) a
WHERE a.time_diff is not null and a.rank =1
ORDER BY a.user_id ;

/* GET # of users only in table 1, # of users only in table 2,
  and # of users in both table, return percentage.
  Longer solution, select from multiple tables*/
  SELECT mobile.mobile_only *100.00/(mobile.mobile_only+web.web_only+both.both) AS mobile,
       web.web_only*100.00/(mobile.mobile_only+web.web_only+both.both) AS web,
	   both.both*100.00/(mobile.mobile_only+web.web_only+both.both) AS both
FROM
(
  SELECT COUNT(DISTINCT user_id) AS mobile_only
   FROM dbo.query_two_mobile
   WHERE user_id NOT IN
   (
     SELECT user_id
	   FROM dbo.query_two_web
   )
   
) mobile,
(
  SELECT COUNT(DISTINCT user_id) AS web_only
   FROM dbo.query_two_web
   WHERE user_id NOT IN
     (
	  SELECT user_id 
	    FROM dbo.query_two_mobile
     ) 
)web,
(SELECT COUNT(DISTINCT m.user_id) AS both
   FROM dbo.query_two_mobile m
   INNER JOIN dbo.query_two_web w
   ON m.user_id = w.user_id
) both

## Simple solution by case when
SELECT LEFT(ROUND(SUM(CASE WHEN m.user_id IS NULL THEN 1 ELSE 0 END)*100.00/COUNT(*),2),5) AS web_user,
	   LEFT(ROUND(SUM(CASE WHEN w.user_id IS NULL THEN 1 ELSE 0 END)*100.00/COUNT(*),2),5) AS mobile_user,
	   LEFT(ROUND(SUM(CASE WHEN m.user_id IS NOT NULL AND w.user_id IS NOT NULL THEN 1 ELSE 0 END)*100.00/COUNT(*),2),5) AS both
FROM
  (
    SELECT distinct user_id
      FROM dbo.query_two_mobile
   ) m
  FULL OUTER JOIN 
   (
     SELECT DISTINCT user_id
       FROM dbo.query_two_web
   ) w
  ON m.user_id = w.user_id

  #Get the date of the 10th product a user purchase
  #convert the varchar column to datetime
  ALTER TABLE dbo.query_three
ALTER COLUMN [date] datetime;
#start the question
SELECT sub.user_id,
       sub.date AS day
FROM
( 
  SELECT user_id, 
         date,
	     ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY date) AS rank
    FROM dbo.query_three
) sub
WHERE sub.rank=10
ORDER BY sub.user_id

-- remove " from each row
UPDATE dbo.query_six
SET created_at = TRIM( '"' FROM created_at);

select created_at FROM dbo.query_six;
ALTER TABLE dbo.query_six
ALTER COLUMN created_at DATETIME;

UPDATE dbo.query_six
SET country= TRIM('"' from country);

-- return country that has maximum number of users and minimum number of users
SELECT temp.country,
     temp.user_count
     
FROM
(SELECT sub.*,
     rank() OVER ( ORDER BY sub.user_count) AS rank_asce,
     rank() OVER ( ORDER BY sub.user_count desc) as rank_desc
FROM
(SELECT country, count(DISTINCT user_id) AS user_count FROM dbo.query_six
GROUP BY country) sub
) temp
WHERE temp.rank_asce=1 or temp.rank_desc=1

--A query that returns for each country the first and the last user who signed up (if that
--country has just one user, it should just return that single user)
SELECT sub.country,
     sub.user_id,
     sub.created_at
FROM
(
  SELECT country,
     user_id,
     created_at,
       RANK() OVER(PARTITION BY country ORDER BY created_at) as rank_asce,
     RANK() OVER(PARTITION BY country ORDER BY created_at desc) as rank_desc
  FROM dbo.query_six
  ) sub
 WHERE rank_asce=1 or rank_desc=1 
