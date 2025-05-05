use corona;
select * From coronavirusdataset;

ALTER TABLE coronavirusdataset
CHANGE `Country/Region` Region varchar(50);

-- To avoid any errors, check missing value / null value 
--  Write a code to check NULL values
select * 
FROM coronavirusdataset
where Province IS NULL OR 
      Region IS NULL OR
      latitude IS NULL OR
      Longitude IS NULL OR
      Date IS NULL OR
      Confirmed IS NULL OR
      Deaths IS NULL OR
      Recovered IS NULL ;

-- Q2. If NULL values are present, update them with zeros for all columns. 
-- No Null Values

-- Q3. check total number of rows
SELECT count(*) AS Count_of_rows
From coronavirusdataset;


-- Q4. Check what is start_date and end_date
set sql_safe_updates = 0 ;
-- Step 1: Add a new date column
ALTER TABLE coronavirusdataset ADD COLUMN Date_ DATE;

-- Step 2: Update the new column with converted date values
UPDATE coronavirusdataset SET Date_ = STR_TO_DATE(date,'%d-%m-%Y');

-- Step 3: Drop the old text column
ALTER TABLE coronavirusdataset DROP COLUMN date;

-- Step 4: Rename the new column to the original column name
ALTER TABLE coronavirusdataset CHANGE COLUMN Date_ Date DATE;

Select min(date) AS Start_date,
       max(date) AS End_date
from coronavirusdataset;



-- Q5. Number of month present in dataset
SELECT TIMESTAMPDIFF(MONTH, '2020-01-22', '2021-06-13') AS MonthDifference;


-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT  year(date) AS YEAR, monthname(date) AS MONTH, 
		avg(confirmed) AS AVG_CONFIMED_CASES, 
        avg(deaths) AS AVG_DEATHS, 
		avg(recovered) AS AVG_RECOVERED
FROM coronavirusdataset
GROUP BY monthname(date), year(date);

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    MONTH,
    confirmed, deaths, recovered
FROM (SELECT MONTHNAME(date) AS MONTH,
             confirmed,deaths, recovered,
			 ROW_NUMBER() OVER (PARTITION BY MONTHNAME(date) ORDER BY COUNT(confirmed) DESC) AS rn_c,
             ROW_NUMBER() OVER (PARTITION BY MONTHNAME(date) ORDER BY COUNT(deaths) DESC) AS rn_d,
             ROW_NUMBER() OVER (PARTITION BY MONTHNAME(date) ORDER BY COUNT(recovered) DESC) AS rn_r
      FROM 
            coronavirusdataset
	  GROUP BY 
             MONTHNAME(date), confirmed,deaths, recovered
) AS subquery
WHERE 
    rn_c =1 AND rn_d = 1 AND rn_r = 1;

 
 
 

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT YEAR(DATE) AS YEAR, 
       MIN(CONFIRMED) AS MIN_cases, 
       MIN(DEATHS) AS MIN_deaths, 
       MIN(RECOVERED) AS MIN_recovered
FROM coronavirusdataset
GROUP BY YEAR;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR(DATE) AS YEAR, 
	   MAX(CONFIRMED) AS MAX_cases, 
       MAX(DEATHS) AS MAX_deaths, 
       MAX(RECOVERED) AS MAX_recovered
FROM coronavirusdataset
GROUP BY YEAR;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT YEAR(DATE) AS YEAR,
       MONTH(DATE) AS MONTH, 
       SUM(CONFIRMED) AS Total_cases, 
       SUM(DEATHS) AS Total_deaths, 
       SUM(RECOVERED) AS Total_recovered
FROM coronavirusdataset
GROUP BY YEAR, MONTH;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  SUM(CONFIRMED) AS Total_cases, 
        CAST(avg(CONFIRMED) AS DECIMAL(10, 2)) AS Avg_cases, 
        CAST(variance(CONFIRMED) AS DECIMAL(10, 2)) AS Variance, 
        CAST(stddev(CONFIRMED) AS DECIMAL(10, 2)) AS standard_deviation
FROM coronavirusdataset;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  YEAR(DATE) AS YEAR,MONTH(DATE) AS MONTH,
        SUM(DEATHS) AS Total_cases, 
		CAST(avg(DEATHS) AS DECIMAL(10, 2)) AS Avg_cases, 
        CAST(variance(DEATHS) AS DECIMAL(10, 2)) AS Variance, 
         CAST(stddev(DEATHS) AS DECIMAL(10, 2)) AS standard_deviation
FROM coronavirusdataset
GROUP BY YEAR, MONTH;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  SUM(RECOVERED) AS Recovered_cases,
        CAST(avg(RECOVERED) AS DECIMAL(10, 2)) AS Avg_cases, 
        CAST(variance(RECOVERED) AS DECIMAL(12, 2))AS Variance, 
        CAST(stddev(RECOVERED) AS DECIMAL(10, 2)) AS standard_deviation
FROM coronavirusdataset;

-- Q14. Find Country having highest number of the Confirmed case
SELECT REGION, 
       SUM(CONFIRMED) AS Total_cases
FROM coronavirusdataset
GROUP BY REGION
order by Total_cases desc
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT REGION, 
       SUM(CONFIRMED) AS Total_cases
FROM coronavirusdataset
GROUP BY REGION
order by Total_cases 
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case
SELECT Region, 
       SUM(RECOVERED) AS Recovered_cases
FROM coronavirusdataset
GROUP BY REGION
order by Recovered_cases desc
LIMIT S5;
