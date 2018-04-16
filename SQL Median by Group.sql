--median by group--
SELECT locale, Median = MAX(Median)
FROM
(
   SELECT locale,Median = PERCENTILE_CONT(0.5) WITHIN GROUP 
     (ORDER BY response_time) OVER (PARTITION BY Locale)
   FROM (SELECT a.ticket_id, a.response_time,a.locale FROM Inbound$ a
				 UNION ALL
				 SELECT b.ticket_id, b.response_time, b.locale FROM Outbound$ b
		) AS union_table
) 
AS x
GROUP BY locale;


----median max(first half) and min(second_half)
SELECT locale,((
(SELECT MAX(response_time) FROM
(SELECT TOP 50 PERCENT response_time FROM 
 (SELECT a.ticket_id, a.response_time,a.locale FROM Inbound$ a
  UNION ALL
  SELECT b.ticket_id, b.response_time, b.locale FROM Outbound$ b
  ) AS subquery
 ORDER BY response_time ASC) AS first_half)
 +
 (SELECT MIN(response_time) FROM
(SELECT TOP 50 PERCENT response_time FROM 
 (SELECT a.ticket_id, a.response_time,a.locale FROM Inbound$ a
  UNION ALL
  SELECT b.ticket_id, b.response_time, b.locale FROM Outbound$ b
  ) AS subquery
 ORDER BY response_time DESC) AS second_half))/2.0) AS median FROM 
 (SELECT a.ticket_id, a.response_time,a.locale FROM Inbound$ a
  UNION ALL
  SELECT b.ticket_id, b.response_time, b.locale FROM Outbound$ b
  ) AS subquery
  GROUP BY locale

-- 95 percentile
SELECT locale, Pct = MAX(p) 
FROM
(
   SELECT locale, p = PERCENTILE_CONT(0.95) WITHIN GROUP 
     (ORDER BY response_time) OVER (PARTITION BY Locale)
   FROM (SELECT a.ticket_id, a.response_time,a.locale FROM Inbound$ a
				 UNION ALL
				 SELECT b.ticket_id, b.response_time, b.locale FROM Outbound$ b
		) AS union_table
) 
AS x
GROUP BY locale;
