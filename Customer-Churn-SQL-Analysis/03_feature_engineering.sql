/* =========================================================
   AGE GROUP FEATURE CREATION
   Create customer age segments for churn analysis
========================================================= */

SELECT
CustomerId, Age,
CASE
WHEN Age < 30 THEN 'Under 30'
WHEN Age BETWEEN 30 AND 50 THEN '30-50'
ELSE '50+'
END AS Age_Group
FROM churn_data;

/* =========================================================
   CREDIT SCORE BAND CREATION
   Classify customers by credit risk level
========================================================= */

SELECT
CustomerId, CreditScore,
CASE
WHEN CreditScore < 500 THEN 'Poor'
WHEN CreditScore BETWEEN 500 AND 699 THEN 'Average'
ELSE 'Good'
END AS CreditScore_Band
FROM churn_data;

/* =========================================================
   BALANCE SEGMENT CREATION
   Categorize customers by account balance level
========================================================= */

SELECT
CustomerId, Balance,
CASE
WHEN Balance = 0 THEN 'Zero Balance'
WHEN Balance < 100000 THEN 'Low Balance'
ELSE 'High Balance'
END AS Balance_Segment
FROM churn_data;

/* =========================================================
   ACTIVITY STATUS FEATURE CREATION
   Categorize customers by engagement level
========================================================= */

SELECT
CustomerId, IsActiveMember,
CASE
WHEN IsActiveMember = 1 THEN 'Active'
ELSE 'Inactive'
END AS Activity_Status
FROM churn_data;

/* =========================================================
   CHURN RATE BY AGE GROUP
   Evaluate churn behaviour across age segments
========================================================= */

SELECT
CASE
WHEN Age < 30 THEN 'Under 30'
WHEN Age BETWEEN 30 AND 50 THEN '30-50'
ELSE '50+'
END AS Age_Group,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM churn_data
GROUP BY Age_Group;

/* =========================================================
   CHURN RATE BY CREDIT SCORE BAND
   Compare retention across credit quality segments
========================================================= */

SELECT
CASE
WHEN CreditScore < 500 THEN 'Poor'
WHEN CreditScore BETWEEN 500 AND 699 THEN 'Average'
ELSE 'Good'
END AS CreditScore_Band,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM churn_data
GROUP BY CreditScore_Band;

/* =========================================================
   CHURN RATE BY BALANCE SEGMENT
   Analyze impact of account balance on churn
========================================================= */

SELECT
    CASE
        WHEN Balance = 0 THEN 'Zero Balance'
        WHEN Balance < 100000 THEN 'Low Balance'
        ELSE 'High Balance'
    END AS Balance_Segment,
    COUNT(*) AS Customers,
    ROUND(
        SUM(Exited) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM churn_data
GROUP BY Balance_Segment;

/* =========================================================
   CHURN RATE BY ACTIVITY STATUS
   Assess impact of customer engagement on churn
========================================================= */

SELECT
CASE
WHEN IsActiveMember = 1 THEN 'Active'
ELSE 'Inactive'
END AS Activity_Status,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Activity_Status;