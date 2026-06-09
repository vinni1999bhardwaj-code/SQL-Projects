/* =========================================================
   OVERALL CHURN DISTRIBUTION
   Analyze retained vs exited customers
========================================================= */

SELECT
Exited,
COUNT(*) AS Total_Customers
FROM churn_data
GROUP BY Exited;	

/* =========================================================
   CUSTOMER DISTRIBUTION BY GEOGRAPHY
   Identify customer concentration by country
========================================================= */

SELECT
Geography,
COUNT(*) AS Customers
FROM churn_data
GROUP BY Geography
ORDER BY Customers DESC;

/* =========================================================
   CHURN DISTRIBUTION BY GEOGRAPHY
   Compare exited and retained customers across countries
========================================================= */

SELECT
Geography, Exited,
COUNT(*) AS Customers
FROM churn_data
GROUP BY Geography, Exited
ORDER BY Geography;

/* =========================================================
   CHURN RATE BY GEOGRAPHY
   Identify high-risk geographic regions
========================================================= */

SELECT
Geography,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Geography
ORDER BY Churn_Rate DESC;

/* =========================================================
   CHURN RATE BY GENDER
   Compare customer attrition across genders
========================================================= */

SELECT
Gender,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Gender;

/* =========================================================
   CHURN RATE BY AGE GROUP
   Evaluate customer attrition across age segments
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
   CHURN RATE BY ACTIVITY STATUS
   Compare active vs inactive customers
========================================================= */

SELECT
IsActiveMember,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM churn_data
GROUP BY IsActiveMember;

/* =========================================================
   CHURN RATE BY NUMBER OF PRODUCTS
   Analyze relationship between product ownership and churn
========================================================= */

SELECT
NumOfProducts,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM churn_data
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

/* =========================================================
   PRODUCT OWNERSHIP VS ACTIVITY STATUS
   Analyze churn by products and customer engagement
========================================================= */

SELECT NumOfProducts,
IsActiveMember,
COUNT(*) AS Customers,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY NumOfProducts, IsActiveMember
ORDER BY NumOfProducts, IsActiveMember;

/* =========================================================
   GEOGRAPHY AND GENDER CHURN ANALYSIS
   Compare churn patterns across countries and genders
========================================================= */

SELECT
Geography,
Gender,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Geography, Gender
ORDER BY Geography, Churn_Rate DESC;

/* =========================================================
   AGE GROUP AND GENDER CHURN ANALYSIS
   Identify high-risk demographic segments
========================================================= */

SELECT
CASE
WHEN Age < 30 THEN 'Under 30'
WHEN Age BETWEEN 30 AND 50 THEN '30-50'
ELSE '50+'
END AS Age_Group, Gender,
ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS Churn_Rate
FROM churn_data
GROUP BY Age_Group, Gender
ORDER BY Churn_Rate DESC;