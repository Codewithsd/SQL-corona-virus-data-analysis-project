
SELECT * FROM corona.corona_virus_dataset;

-- check table information  
describe corona_virus_dataset;

-- date column is not in propper format its type is also need to be changed 
-- convert dates in proper date format (yyyy-mm-dd)
UPDATE corona_virus_dataset
SET date= DATE_FORMAT(STR_TO_DATE(date, '%d-%m-%Y'), '%Y-%m-%d');

-- to change the type of date column
ALTER TABLE corona_virus_dataset
modify COLUMN Date DATE;

-- check table info again
describe corona_virus_dataset;

-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values

select *
from corona_virus_dataset where Province is NULL or Country is NULL or Latitude is NULL or
Longitude is NULL or Date is NULL or Confirmed is NULL Or Deaths is Null or Recovered is Null ;

-- ========================================================================   

-- Q2. If NULL values are present, update them with zeros for all columns. 

-- to disable safe updatemode
-- safe update mode des not allow user to update the table to avoid changes in data
-- so we need to off the safe update mode
SET SQL_SAFE_UPDATES = 0;

UPDATE corona_virus_dataset
SET 
    Province = COALESCE(Province, 0),
    Country = COALESCE(Country, '0'), -- Replace with an appropriate default value
    Latitude = COALESCE(Latitude, 0),Longitude = COALESCE(Longitude, 0),Date = COALESCE(Date, 0),
    Confirmed = COALESCE(Confirmed, 0),Deaths = COALESCE(Longitude, 0),Recovered = COALESCE(Recovered, 0)
WHERE Province IS NULL OR Country IS NULL OR Latitude IS NULL OR Longitude 
IS NULL OR Date IS NULL OR Confirmed IS NULL OR Deaths IS NULL OR Recovered IS NULL;

-- enable safe update mode again
SET SQL_SAFE_UPDATES = 1;

-- ========================================================================   
-- Q3. check total number of rows
 SELECT count(*)
 from corona_virus_dataset;
 
-- ========================================================================   
-- Q4. Check what is start_date and end_date
SELECT 
    MIN(STR_TO_DATE(date, '%Y-%m-%d')) AS start_date, 
    MAX(STR_TO_DATE(date, '%Y-%m-%d')) AS end_date
FROM corona_virus_dataset;

-- ========================================================================   
-- Q5. Number of month present in dataset
SELECT count(DISTINCT DATE_FORMAT(str_to_date(date, '%Y-%m-%d'),'%Y-%m'))AS distinct_months_count
FROM corona_virus_dataset;

-- ========================================================================   
-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT DATE_FORMAT(STR_TO_DATE(date, '%Y-%m-%d'),'%Y-%m') AS month_year,
  AVG(Confirmed) AS avg_confirmed_cases,
  AVG(Deaths) AS avg_deaths,
  AVG(Recovered) AS avg_recovered_cases
FROM corona_virus_dataset
GROUP BY DATE_FORMAT(STR_TO_DATE(date, '%Y-%m-%d'),'%Y-%m')
ORDER BY month_year;

-- ========================================================================   
-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT DATE_FORMAT(STR_TO_DATE(date, '%Y-%m-%d'),'%Y-%m')AS month_year,
   MODE(Confirmed)  AS most_frequent_confirmed,
   MODE(Deaths)  AS most_frequent_deaths,
   MODE(Recovered) AS most_frequent_recovered
 FROM corona_virus_dataset
 GROUP BY DATE_FORMAT(STR_TO_DATE(date, '%Y-%m-%d'),'%Y-%m')
 ORDER BY month_year;
 
-- ========================================================================  
-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT DATE_FORMAT(date, '%Y') AS per_year, 
MIN(Confirmed) AS min_confirmed,
MIN(Deaths) AS min_deaths,
MIN(recovered) AS min_recovered
FROM corona_virus_dataset
GROUP BY DATE_FORMAT(date, '%Y')
ORDER BY per_year;

-- ========================================================================   
-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT DATE_FORMAT (date, '%Y') AS per_year, 
max(Confirmed) AS max_confirmed,
max(Deaths) AS max_deaths,
max(recovered) AS max_recovered
FROM corona_virus_dataset
GROUP BY DATE_FORMAT(date, '%Y')
ORDER BY per_year;

-- ========================================================================   
-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT DATE_FORMAT(date, '%Y-%m') AS per_month, 
sum(Confirmed) AS total_confirmed,
sum(Deaths) AS total_deaths,
sum(recovered) AS total_recovered
FROM corona_virus_dataset
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY per_month;

-- ========================================================================   
-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    SUM(confirmed) AS total_confirmed_cases,
    AVG(confirmed) AS average_confirmed_cases,
    VAR_SAMP(confirmed) AS variance_confirmed_cases,
    STDDEV_SAMP(confirmed) AS stdev_confirmed_cases
FROM corona_virus_dataset;

-- ========================================================================   
-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT DATE_FORMAT(date, '%Y-%m') AS per_month, 
    SUM(Deaths) AS total_Deaths_cases,
    AVG(Deaths) AS average_Deaths_cases,
    VAR_SAMP(Deaths) AS variance_Deaths_cases,
    STDDEV_SAMP(Deaths) AS stdev_Deaths_cases
FROM corona_virus_dataset
group by DATE_FORMAT(date, '%Y-%m')  
ORDER BY per_month;
-- ========================================================================   
-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    SUM(Recovered) AS total_Recovered_cases,
    AVG(Recovered) AS average_Recoverd_cases,
    VAR_SAMP(Recovered) AS variance_Recoverd_cases,
    STDDEV_SAMP(Recovered) AS stdev_Recoverd_cases
FROM corona_virus_dataset;

-- ========================================================================   
-- Q14. Find Country having highest number of the Confirmed case
select Country,sum(confirmed)as max_confirmed_cases
from corona_virus_dataset
group by Country
order by max_Confirmed_cases DESC
limit 1;

-- ========================================================================   
-- Q15. Find Country having lowest number of the death case

select Country,sum(Deaths)as lowest_deaths
from corona_virus_dataset
group by Country
order by lowest_deaths asc
limit 1;

-- ========================================================================   
-- Q16. Find top 5 countries having highest recovered case
select Country,sum(Recovered)as max_recovered_cases
from corona_virus_dataset
group by Country
order by max_Recovered_cases DESC
limit 5;
