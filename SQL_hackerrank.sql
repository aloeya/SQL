SELECT CASE WHEN A+B>C and A+C>B and B+C>A THEN
                 CASE WHEN A=B AND B=C THEN 'Equilateral'
                 WHEN A=B OR B=C OR A=C THEN 'Isosceles'
                 WHEN A!=B AND B!=C THEN 'Scalene'
                 END 
       ELSE 'not a triangle' END
FROM triangles;

SELECT name + "("+ substring(occupation,1,1) + ")" 
FROM occupations
ORDER BY name asc;
SELECT 'There are a total of ' + cast(count(*) AS VARCHAR)+" "+ lower(occupation)
FROM occupations
GROUP BY occupation
ORDER BY count(*), occupation asc;

SELECT start_date, end_date FROM
(SELECT start_date FROM projects 
WHERE start_date NOT IN (select end_date from projects))a,
(SELECT end_date FROM projects 
WHERE end_date NOT IN (select start_date FROM projects))b
WHERE start_date < end_date
GROUP BY start_date
ORDER BY DATEDIFF(day,end_date,start_date)

SELECT [Doctor],[Professor],[Singer],[Actor] FROM Occupations
PIVOT
     (max(name) for Occupation in ([Doctor],[Professor],[Singer],[Actor])
     ) AS pivot_table

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)


