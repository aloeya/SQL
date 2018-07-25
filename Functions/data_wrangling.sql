## Data wrangling 
## Seperate location column into alt & lon respectively, and remove "(,)-" simbols at the same time
SELECT incidnt_num, location, 
	   SUBSTR(location, 2, POSITION(',' IN location)-2) AS latitude,
       TRIM(TRAILING ')' FROM SUBSTR(location, POSITION('-' IN location)+1, LENGTH(location)/2)) AS longtitude
FROM tutorial.sf_crime_incidents_2014_01;

##Concatenate the lat and lon fields to form a field that is equivalent to the location field.
SELECT incidnt_num, location, 
       CONCAT(CONCAT('(',lat), ', ', CONCAT(lon,')')) AS location_new
FROM tutorial.sf_crime_incidents_2014_01;

##Use || syntax, in this case, || is equivalent to "+" in Python.
SELECT incidnt_num, location, 
       '('|| lat || ', ' || lon ||')' AS location_new
FROM tutorial.sf_crime_incidents_2014_01;


## Create a new column in YYYY-MM-DD format
SELECT incidnt_num, 
       date,
       SUBSTR(date, 7,4) || '-' ||LEFT(date,2)  || '-' || SUBSTR(date, 4, 2) AS YMD_format
FROM tutorial.sf_crime_incidents_2014_01;

## returns the `category` field with the first letter capitalized and the rest of the letters in lower-case.
SELECT incidnt_num, 
       category,
       UPPER(LEFT(category, 1)) || LOWER(RIGHT(category, LENGTH(category)-1)) AS Category
FROM tutorial.sf_crime_incidents_2014_01;

## USE TIMESTAMP AND INTERVAL
SELECT incidnt_num,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2)||' '|| time ||':00') ::timestamp AS cleaned_date,
        (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2)||' '|| time ||':00') ::timestamp + INTERVAL '1 week' AS one_week_later
        FROM tutorial.sf_crime_incidents_2014_01

###Extract 
SELECT cleaned_date,
       EXTRACT('year' FROM cleaned_date) AS year,
       EXTRACT('month' FROM cleaned_date) AS month,
       EXTRACT('day' FROM cleaned_date) AS day,
       EXTRACT('dow' FROM cleaned_date) AS day_of_the_week,
       EXTRACT('hour' FROM cleaned_date) AS hour,
       EXTRACT('minute' FROM cleaned_date) AS minute,
       EXTRACT('decade' FROM cleaned_date) AS decade
  FROM tutorial.sf_crime_incidents_cleandate

SELECT cleaned_date,
       DATE_TRUNC('year', cleaned_date) AS year,
       DATE_TRUNC('month', cleaned_date) AS month,
       DATE_TRUNC('day', cleaned_date) AS day,
       DATE_TRUNC('hour' , cleaned_date) AS hour,
       DATE_TRUNC('minute', cleaned_date) AS minute,
       DATE_TRUNC('decade', cleaned_date) AS decade
  FROM tutorial.sf_crime_incidents_cleandate

###Date_trunc can extract and round the date, it returns a datastamp
### however, extract returns non-datestamp value. It gives accurate value

##Write a query that counts the number of incidents reported by week. 
##Cast the week as a date to get rid of the hours/minutes/seconds.
SELECT DATE_TRUNC('week' , cleaned_date)::date AS week,
       COUNT(*) AS weekly_accident
  FROM tutorial.sf_crime_incidents_cleandate
  GROUP BY week
  ORDER BY week

## get current time
SELECT CURRENT_DATE as date,
       CURRENT_TIME as time,
       CURRENT_TIMESTAMP as timestamp,
       LOCALTIME as local_time,
       LOCALTIMESTAMP as local_timestamp,
      now() 

