--- Understanding the data structure.
SELECT * FROM downtime_factors;
SELECT * FROM line_downtime;
SELECT * FROM line_productivity_batches;
SELECT * FROM products;

--- Number of rows
SELECT COUNT(*) AS numrows_downtime_factors FROM downtime_factors;
SELECT COUNT(*) AS numrows_line_downtime FROM line_downtime;
SELECT COUNT(*) AS numrows_line_productivity_batches FROM line_productivity_batches;
SELECT COUNT(*) AS numrows_products FROM products;

--- Check for nulls
-- Factor 1 Null count
SELECT COUNT(*) AS factor1_null_count FROM line_downtime
WHERE Factor_1 IS NULL;

-- Factor 2 Null Count
SELECT COUNT(*) AS factor2_null_count FROM line_downtime
WHERE Factor_2 IS NULL;

-- Factor 3 Null count
SELECT COUNT(*) AS factor3_null_count FROM line_downtime
WHERE Factor_3 IS NULL;

-- Factor 4 Null count
SELECT COUNT(*) AS factor4_null_count FROM line_downtime
WHERE Factor_4 IS NULL;

---All factor count of Null
SELECT COUNT(*) AS all_factors_null_count FROM line_downtime
WHERE COALESCE(Factor_1, Factor_2, Factor_3, Factor_4, Factor_5, Factor_6, Factor_7, Factor_8, Factor_9, Factor_10, Factor_11, Factor_12, Factor_13) IS NULL;

--- Check if Date is equal to date in start_time
WITH start_dates AS (
	SELECT DATE, CAST(Start_Time AS DATE) AS Start_Date
	FROM line_productivity_batches)
SELECT * FROM start_dates
WHERE Date != Start_Date

--- Data cleaning and Transformation
--- Handle nulls in line downtime
CREATE VIEW downtime AS
	SELECT 
		Batch_ID, 
		REPLACE(Factor, 'Factor_', '') AS Factor_ID, 
		Minutes 
	FROM line_downtime
	UNPIVOT(Minutes FOR Factor IN (Factor_1, Factor_2, Factor_3, Factor_4, Factor_5, Factor_6, Factor_7, 
		Factor_8, Factor_9, Factor_10, Factor_11, Factor_12, Factor_13)) AS UnpivotDowntimes;
---check the downtime table
SELECT * FROM downtime
ORDER BY Batch_ID;

----Create New batch production table
CREATE VIEW batch_production AS 
SELECT 
	Date AS Start_Date,
	Product_ID,
	Batch_ID,
	Operator,
	CAST(End_Time AS Date) AS End_Date,
	CAST(Start_Time AS Time) AS Start_Time,
	CAST(End_Time AS Time) AS End_Time,
	Planned_Min_Batch_hours,
	DATEDIFF(hour, Start_Time, End_Time) AS Actual_Duration,
	DATEDIFF(hour, Start_Time, End_Time) - Planned_Min_Batch_Hours AS Extra_Time_Hr
FROM
	line_productivity_batches;

---check new batch production table
SELECT * FROM batch_production;

---validate the  downtime minutes against planned production time and reported start/end time
SELECT 
	batch_production.Batch_ID, 
	SUM(Minutes) AS accounted_delay_minutes, 
	Extra_Time_Hr
FROM 
	batch_production
JOIN 
	downtime ON batch_production.Batch_ID =  downtime.Batch_ID
GROUP BY
	batch_production.Batch_ID, Extra_Time_Hr;

---Analysis
--- Downtime Key Factors
SELECT 
	Factor_Name, 
	COUNT(Batch_ID) AS Frequency, 
	SUM(Minutes) AS Delay_Mins 
FROM
	downtime
JOIN
	downtime_factors ON downtime.Factor_ID = downtime_factors.Factor_ID
GROUP BY
	Factor_Name
ORDER BY Frequency DESC

---Operator vs non-operator errors
SELECT
	CASE Operator_Error
		WHEN 1 THEN 'Yes'
		ELSE 'No'
	END AS Operator_Error,
	COUNT(Batch_ID) AS Frequency,
	SUM(Minutes) AS Delay_Mins
FROM 
	downtime
JOIN downtime_factors ON downtime.Factor_ID = downtime_factors.Factor_ID
GROUP BY
	Operator_Error

-- Downtime Operator Error
SELECT
	Factor_Name,
	Description,
	COUNT(Batch_ID) AS Frequency,
	SUM(Minutes) AS Delay_Mins
FROM 
	downtime
JOIN downtime_factors ON downtime.Factor_ID = downtime_factors.Factor_ID
WHERE Operator_Error = 1
GROUP BY Factor_Name, Description
ORDER BY SUM(Minutes) DESC;

-- Downtime Non Operator Error
SELECT
	Factor_Name,
	Description,
	COUNT(Batch_ID) AS Frequency,
	SUM(Minutes) AS Delay_Mins
FROM 
	downtime
JOIN downtime_factors ON downtime.Factor_ID = downtime_factors.Factor_ID
WHERE Operator_Error = 0
GROUP BY Factor_Name, Description
ORDER BY SUM(Minutes) DESC;

-- Products and downtime frequency & delay (mins)
SELECT 
	batch_production.Product_ID,
	Product_Name,
	COUNT(batch_production.Batch_ID) AS Frequency,
	SUM(Minutes) AS Delay_Mins
FROM
	batch_production
JOIN downtime ON batch_production.Batch_ID = downtime.Batch_ID
JOIN products ON batch_production.Product_ID = products.Product_ID
GROUP BY batch_production.Product_ID, Product_Name;