SELECT extract('week'from z.occurred_at) AS week, 
       avg(z.event_age) AS "Average age during week",
      COUNT(DISTINCT CASE WHEN z.user_age>70 THEN z.user_id ELSE NULL END) AS week_over_10,
      cOUNT(DISTINCT CASE WHEN z.user_age < 70 AND z.user_age >= 63 THEN z.user_id ELSE NULL END) AS "9 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 63 AND z.user_age >= 56 THEN z.user_id ELSE NULL END) AS "8 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 56 AND z.user_age >= 49 THEN z.user_id ELSE NULL END) AS "7 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 49 AND z.user_age >= 42 THEN z.user_id ELSE NULL END) AS "6 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 42 AND z.user_age >= 35 THEN z.user_id ELSE NULL END) AS "5 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 35 AND z.user_age >= 28 THEN z.user_id ELSE NULL END) AS "4 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 28 AND z.user_age >= 21 THEN z.user_id ELSE NULL END) AS "3 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 21 AND z.user_age >= 14 THEN z.user_id ELSE NULL END) AS "2 weeks",
       COUNT(DISTINCT CASE WHEN z.user_age < 14 AND z.user_age >= 7 THEN z.user_id ELSE NULL END) AS "1 week",
       COUNT(DISTINCT CASE WHEN z.user_age < 7 THEN z.user_id ELSE NULL END) AS "Less than a week"
FROM
(SELECT u.user_id AS user_id, e.occurred_at AS occurred_at, EXTRACT('day' FROM e.occurred_at-u.activated_at) AS event_age, 
      EXTRACT('day' FROM '2014-09-01'::TIMESTAMP - u.activated_at) AS user_age
FROM tutorial.yammer_users u 
JOIN tutorial.yammer_events e ON u.user_id=e.user_id
WHERE e.event_type='engagement'
AND e.event_name='login'
AND e.occurred_at>='2014-05-01'
AND e.occurred_at<'2014-09-01'
AND u.activated_at is not null) z
group by 1