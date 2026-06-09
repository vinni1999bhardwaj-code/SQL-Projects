/* =========================================================
   DATA CLEANING & QUALITY CHECKS
   Banking Risk Analytics Project
========================================================= */

CREATE DATABASE banking_risk_analytics;
USE banking_risk_analytics;

Select * From Churn_data
/*=========================================================
   RECORD COUNT VALIDATION
   Check total number of records in dataset
========================================================= */

Select COUNT(*)
FROM churn_data;

/* =========================================================
   CUSTOMER UNIQUENESS CHECK
   Verify unique customer records
========================================================= */

SELECT COUNT(DISTINCT CustomerId)
FROM churn_data;

/* =========================================================
   MISSING VALUE ANALYSIS
   Check null values across all key columns
========================================================= */

SELECT
SUM(CASE WHEN RowNumber IS NULL THEN 1 ELSE 0 END) AS RowNumber_Nulls,
SUM(CASE WHEN CustomerId IS NULL THEN 1 ELSE 0 END) AS CustomerId_Nulls,
SUM(CASE WHEN Surname IS NULL THEN 1 ELSE 0 END) AS Surname_Nulls,
SUM(CASE WHEN CreditScore IS NULL THEN 1 ELSE 0 END) AS CreditScore_Nulls,
SUM(CASE WHEN Geography IS NULL THEN 1 ELSE 0 END) AS Geography_Nulls,
SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_Nulls,
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Nulls,
SUM(CASE WHEN Tenure IS NULL THEN 1 ELSE 0 END) AS Tenure_Nulls,
SUM(CASE WHEN Balance IS NULL THEN 1 ELSE 0 END) AS Balance_Nulls,
SUM(CASE WHEN NumOfProducts IS NULL THEN 1 ELSE 0 END) AS NumOfProducts_Nulls,
SUM(CASE WHEN HasCrCard IS NULL THEN 1 ELSE 0 END) AS HasCrCard_Nulls,
SUM(CASE WHEN IsActiveMember IS NULL THEN 1 ELSE 0 END) AS IsActiveMember_Nulls,
SUM(CASE WHEN EstimatedSalary IS NULL THEN 1 ELSE 0 END) AS EstimatedSalary_Nulls,
SUM(CASE WHEN Exited IS NULL THEN 1 ELSE 0 END) AS Exited_Nulls
FROM churn_data;
