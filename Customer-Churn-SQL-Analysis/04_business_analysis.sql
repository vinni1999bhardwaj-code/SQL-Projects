/* =========================================================
   COUNTRY CHURN RANKING
   Rank countries based on customer churn rates
========================================================= */

WITH Country_Churn 
AS (SELECT Geography,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Geography)
SELECT Geography, Churn_Rate,
RANK() OVER (
ORDER BY Churn_Rate DESC) AS Churn_Rank
FROM Country_Churn;

/* =========================================================
   RANKING METHOD COMPARISON
   Compare ROW_NUMBER, RANK and DENSE_RANK
========================================================= */

WITH Country_Churn AS (SELECT Geography,
ROUND( SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Geography)
SELECT Geography,Churn_Rate,
ROW_NUMBER() OVER (
ORDER BY Churn_Rate DESC) AS Row_Num,
RANK() OVER (
ORDER BY Churn_Rate DESC) AS Rank_Num,
DENSE_RANK() OVER (
ORDER BY Churn_Rate DESC) AS Dense_Rank_Num
FROM Country_Churn;

/* =========================================================
   CUSTOMER SEGMENT RISK ANALYSIS
   Rank age and gender segments by churn rate
========================================================= */

WITH Segment_Churn AS (SELECT
CASE
WHEN Age < 30 THEN 'Under 30'
WHEN Age BETWEEN 30 AND 50 THEN '30-50'
ELSE '50+'
END AS Age_Group,
Gender,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Age_Group, Gender)
SELECT Age_Group, Gender, Customers, Churn_Rate,
RANK() OVER (ORDER BY Churn_Rate DESC) AS Risk_Rank
FROM Segment_Churn;

/* =========================================================
   CUSTOMER RISK PROFILE ANALYSIS
   Create risk profiles using age and activity status
========================================================= */

WITH Risk_Profile AS (
SELECT
CASE
WHEN Age >= 50 AND IsActiveMember = 0 THEN '50+ Inactive'
WHEN Age >= 50 AND IsActiveMember = 1 THEN '50+ Active'
WHEN Age BETWEEN 30 AND 49 AND IsActiveMember = 0 THEN '30-49 Inactive'
WHEN Age BETWEEN 30 AND 49 AND IsActiveMember = 1 THEN '30-49 Active'
WHEN Age < 30 AND IsActiveMember = 0 THEN 'Under 30 Inactive'
ELSE 'Under 30 Active'
END AS Customer_Profile,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Customer_Profile)
SELECT Customer_Profile, Customers, Churn_Rate,
RANK() OVER (ORDER BY Churn_Rate DESC) AS Risk_Rank
FROM Risk_Profile;

/* =========================================================
   CHURN CONTRIBUTION ANALYSIS
   Identify segments contributing most churned customers
========================================================= */

WITH Churn_Contribution AS (
SELECT
CASE
WHEN Age >= 50 AND IsActiveMember = 0 THEN '50+ Inactive'
WHEN Age >= 50 AND IsActiveMember = 1 THEN '50+ Active'
WHEN Age BETWEEN 30 AND 49 AND IsActiveMember = 0 THEN '30-49 Inactive'
WHEN Age BETWEEN 30 AND 49 AND IsActiveMember = 1 THEN '30-49 Active'
WHEN Age < 30 AND IsActiveMember = 0 THEN 'Under 30 Inactive'
ELSE 'Under 30 Active'
END AS Customer_Profile,
SUM(Exited) AS Churned_Customers
FROM churn_data
GROUP BY Customer_Profile)
SELECT Customer_Profile, Churned_Customers,
RANK() OVER (ORDER BY Churned_Customers DESC) AS Churn_Contribution_Rank
FROM Churn_Contribution;

/* =========================================================
   RETENTION OPPORTUNITY ANALYSIS
   Prioritize segments with highest retention potential
========================================================= */

WITH Retention_Opportunity AS (
SELECT
CASE
WHEN Age >= 50 AND IsActiveMember = 0 THEN '50+ Inactive'
WHEN Age >= 50 AND IsActiveMember = 1 THEN '50+ Active'
WHEN Age BETWEEN 30 AND 49 AND IsActiveMember = 0 THEN '30-49 Inactive'
WHEN Age BETWEEN 30 AND 49 AND IsActiveMember = 1 THEN '30-49 Active'
WHEN Age < 30 AND IsActiveMember = 0 THEN 'Under 30 Inactive'
ELSE 'Under 30 Active'
END AS Customer_Profile,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate,
ROUND(
COUNT(*) *
(SUM(Exited) * 100.0 / COUNT(*)),0) AS Opportunity_Score
FROM churn_data
GROUP BY Customer_Profile)
SELECT Customer_Profile, Customers, Churn_Rate, Opportunity_Score,
RANK() OVER (ORDER BY Opportunity_Score DESC) AS Opportunity_Rank
FROM Retention_Opportunity;

/* =========================================================
   CUSTOMER RISK SCORING MODEL
   Build risk categories using churn indicators
========================================================= */

WITH Risk_Score AS (
SELECT CustomerId,
(CASE
WHEN Age >= 50 THEN 3 ELSE 0
END
+
CASE
WHEN IsActiveMember = 0 THEN 2 ELSE 0
END
+
CASE
WHEN Geography = 'Germany' THEN 2 ELSE 0
END
+
CASE
WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Risk_Points,
Exited
FROM churn_data)
SELECT
CASE
WHEN Risk_Points >= 6 THEN 'High Risk'
WHEN Risk_Points BETWEEN 3 AND 5 THEN 'Medium Risk' ELSE 'Low Risk'
END AS Risk_Category,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM Risk_Score
GROUP BY Risk_Category
ORDER BY Churn_Rate DESC;
