#1.Change the query shown so that it displays Nobel prizes for 1950.
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1960
#2.Show who won the 1962 prize for Literature.
SELECT winner
  FROM nobel
 WHERE yr = 1960
   AND subject = 'Physics'
#3.Find all details of the prize won by PETER GRÜNBERG
SELECT * from nobel
WHERE winner like'PETER GR%NBERG'

#4.SELECT * FROM nobel
WHERE winner='EUGENE O\'NEILL'

#5.SELECT winner, yr, subject FROM nobel
WHERE winner like 'Sir%'
ORDER BY yr desc, winner

#6.SELECT winner, subject
FROM nobel
WHERE yr=1984
ORDER BY subject IN ('Physics','Chemistry'),subject,winner