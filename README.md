# Greentech-manufacturing
Evaluating Production Bottlenecks Through Downtime Analysis
# How To Use
The GreentechQuery.sql file contains all the query for this project and the dataset for the project is the .bak file which was injected into the SSMS by restoring the database. 
# GreenTech Manufacturing – Evaluating Production Bottlenecks Through Downtime Analysis. 
## Introduction
GreenTech is a mid-size manufacturer that specializes in eco-friendly products. The company is currently having some challenges which include optimizing production processes, particularly in maintaining efficient production schedules that minimize downtime and maximize throughput. 
Throughput in manufacturing is the amount of product a company produces within a specific timeframe, measured from raw materials all the way through to finished products, that is, if a factory fabricates 100 chairs over 10 days, its throughput is 10 chairs per day. Formula = total output / total time.
Factors that contribute to downtime:
•	Machine Failures
•	Material Shortages
•	Inefficient Production Planning
•	Manual Scheduling: current system is highly reliant on manual input
•	Limited data visibility
Impact of downtime:
•	Operational Inefficiency
•	Financial Costs
•	Customer Delays
•	Resource wastage
The main objective is to optimize production schedules to minimize downtime, reduce operational costs, and increase overall efficiency. 
Specific objectives:
•	Identify root causes for downtime
•	Optimize production scheduling
•	Improve Operator Allocation
•	Enhance Reporting Transparency
•	Enable Continuous Improvement
# Methodology
## Data Cleaning and Transformation
After injecting the data, the tables in the database were all assessed to get a better understanding of the data structure. The dataset contained 4 tables: ‘downtime_factors’, ‘line_downtime’, ‘line_productivity_batches’, and ‘products.’ The downtime_factors table has 13 distinct factors that could cause a downtime, these factors were either operator or non-operator error. The line_downtime table consists of information about the number of minutes of each factor that contributes to the downtime in a particular batch and where a particular factor does not contribute to a downtime in that batch, it is recorded as null. There are 282 batches in the dataset where all factors resulting in downtime are null values indicating that these batches had no downtime. The line_productivity_batches table links to the other tables with the foreign keys: Product_ID and Batch_ID, and it also gives insight into how long a batch of production takes. The Date column and date in the Start_Time column are the same when compared therefore one of them might be dropped. The product table contains information about the product the company produces, there are 4 of them: Ecowash Liquid Detergent, Biowipe Cleaning Sheets, Greenfoam Hand Soap, and Repack Recycled Packaging Films. To handle the null values in the line_downtime table, a new table ‘downtime’ was created using the View function and unpivoting the time in Minutes for each factor to allow for easy aggregation during analysis. Another table was also created from the line_productivity_batches table, this table named ‘batch_production’ had additional columns ‘Actual_Duration’ created using DateDiff function between the start time and end time, and ‘Extra_time_hr’ created by subtracting the planned_min_batch_hours from Actual_Duration. Upon validation, accounted delay in minutes given in the dataset and the calculated extra time in hours were equal. 
## Analysis
In SQL, the downtime key factors were analysed by aggregating the Minutes and batch Id using Sum and Count function respectively. Top five (5) downtime factors ranked by the frequency of batches they affected are Cleaning/Sanitation cycle, Raw material shortage, Scheduling/Coordination delay, Machine breakdown, and Safety lockout/ Emergency Stop. Top five (5) downtime factors ranked by the accumulated delay in minutes that they caused across batches are Cleaning/Sanitation cycle, Scheduling/coordination Delay, Raw material shortage, Quality inspection Hold, and Other. 
Further analysis shows that operator error had lesser impact than non-operator error in terms of both the frequency of the batches affected and the accumulated delay in minutes. Scheduling/coordination Delay contributed the most to the accumulated delay in minutes caused by operator error type followed by Safety Lockout/Emergency Stop. For the non-operator error type, Cleaning/Sanitation cycle contributed the most to the accumulated delay in minutes, followed by Raw material shortage, and Quality inspection hold. 
On the product side, GreenFoam Hand Soap experienced 323 downtime occurrences and delay impact of 11454 minutes, to put in perspective that will be approximately eight days. Biowipe cleaning sheets experienced 204 downtime occurrences and delay for approximately five days, followed by Repack Recycled packaging film with downtime occurrences of 185 and delay impact of approximately four days, lastly Ecowash liquid detergent experienced 173 downtime occurrences and had delay impact of approximately five days. All 13 downtime factors had impact on each product. 
Top five (5) downtime factors impacting Greenfoam hand soap regarding accumulated delay in minutes are Cleaning/sanitation cycle, Raw material shortage, Machine Breakdown, Safety lockout/ Emergency Stop, and Operator mistake, three of these factors are non-operator errors while two are operator errors. Top five (5) downtime factors impacting Biowipe cleaning sheets production with regards to delay in minutes are Quality inspection hold, Cleaning/sanitation cycle, Other, Preventive maintenance, and Sensor/PLC/Software fault, all these factors are non-operator factors. Top five (5) downtime factors causing delay in minutes for Repack recycled packaging film are Scheduling /Coordination delay, Changeover Delay, Raw material shortage, Other, and Cleaning/sanitation cycle, first two factors are operator errors and the other three are non-operator errors. Five non-operator errors; Quality inspection hold, Utilities failure, Packaging Material defect, Cleaning/Sanitation cycle, and Raw material shortage are the top factors contributing to delay in minutes in the production of Ecowash liquid detergent. 
From the analysis so far, it is pertinent that Greentech proffer solution(s) quickly to downtime factors like scheduling/coordination delay, cleaning/sanitation cycle, and raw material shortage as they contribute highly to the loss of time across production.  Further analysis on the lead operators was carried out, Paul worked on the highest number of batches 128 in total, he also experienced the highest number of delayed batches 66 of them, with 164 downtimes resulting in the highest delay impact of approximately 4 days. However, Linda had the highest percentage of delayed batches 70.73% while Paul’s percentage of delayed batches was 51.56% and this can be attributed to the fact that she worked on 41 batches with 29 of these batches being delayed. Furthermore, out of the top five downtime factors that affected Linda, four of them were non-operator error with only one being an operator error which was Safety lockout/Emergency stop. From Paul’s top five downtime factors, three of them were operator error and these are Safety lockout/Emergency stop, Scheduling/Coordination Delay, and Changeover Delay, while the remaining two are Preventive maintenance, and Quality inspection hold which are non-operator error. James and Emily had 144 and 112 downtimes working on 95 and 83 total batches respectively. Top five downtime factors that affected James includes two non-operator errors; Cleaning/Sanitation cycle and Machine breakdown, and three operator errors; Operator mistake, Changeover Delay, and Scheduling/Coordination Delay. Top five downtime factors that affected Emily includes four non-operator errors; Cleaning/sanitation cycle, Quality inspection hold, Other, and Raw material shortage, with just one operator error which was Safety lockout/emergency stop. 
The cleaned and transformed data were fed into power bi where insights was visualised for easy communication to stakeholders. An operator scheduling table was created to visualise how operators are scheduled, this will enable managers to schedule operators to batches appropriately there by reducing the number of downtimes caused by Scheduling/Coordination delay. On the operator scheduling table it became clear that there are some operators taking on multiple batches concurrently, and this can greatly impact production. It was also observed that some operators had batches running into the start time of another batch there causing a downtime for such batches. 
## Recommendations
Based on the insights derived from analysis, here are actionable recommendations for Greentech manufacturing to reduce downtime and improving operational efficiency:

-Implement Automated Production Scheduling: They should transition to automated production scheduling system integrated with production timelines, operator availability, machine capacity, and maintenance windows. This would reduce operator overlap, improve batch scheduling, minimise idle production time.  

-Introduce Predictive and Preventive Maintenance: They should implement predictive maintenance supported by machine runtime tracking, historical downtime trends, and sensor monitoring where possible. They should also establish machine health KPIs. Doing these will help reduce machine-related downtime, improve equipment reliability, and reduce unexpected production stoppages. 

-Strengthen Raw Material and Inventory Planning: The company should implement demand-driven inventory management and supplier coordination processes to improve material availability. Introduce safety stock thresholds and inventory reorder alerts for critical materials, while procurement planning should be integrated into production schedules. These actions will reduce material-related stoppages, lower emergency procurement costs, improve production continuity. 

-Optimise Cleaning and Sanitation Processes: Greentech should review sanitation frequency, cleaning workflows, and equipment setup to reduce cleaning duration without compromising compliance or quality standards. They can introduce parallel cleaning operations where possible and schedule cleaning around batch transitions strategically. These would lower cumulative downtime, improve line availably and increase production throughput.

-Improve Operator Performance Management and Training: The company should create operator-specific downtime scorecards and provide training on changeover efficiency. Workload balance across operators should be closely monitored. These actions will help reduce operator-related downtime, improve production coordination and provide better accountability. 

-Establish Downtime Severity Escalation Framework: Downtime severity thresholds should be defined alongside creating trigger automated alerts for critical downtime events. This will create faster operational response, reduce downtime escalation delays and improve production visibility. 

-Introduce Continuous Improvement and Root Cause Review Cycles: For sustainable operational improvement and reduction in recurring downtime patterns, the company should conduct monthly downtime review meetings, prioritize top recurring downtime factors and track corrective action effectiveness. 

## Tech/ skills stack:
SQL
Power bi
Github
Power point
Analytical thinking
Data cleaning and transformation
Problem solving
Communicating with stakeholders. 


