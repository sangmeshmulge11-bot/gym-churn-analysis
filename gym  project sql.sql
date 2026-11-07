CREATE DATABASE GymChurn;
GO
USE GymChurn;
GO
USE GymChurn;
GO
---
CREATE TABLE gym_raw (
    gender                              INT,
    Near_Location                       INT,
    Partner                             INT,
    Promo_friends                       INT,
    Phone                               INT,
    Contract_period                     INT,
    Group_visits                        INT,
    Age                                 INT,
    Avg_additional_charges_total        FLOAT,
    Month_to_end_contract               FLOAT,
    Lifetime                            INT,
    Avg_class_frequency_total           FLOAT,
    Avg_class_frequency_current_month   FLOAT,
    Churn                               INT
);

---
GO
USE GymChurn;
GO

BULK INSERT gym_raw
FROM 'C:\gym data\gym_churn_us.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO
---
USE GymChurn;
GO

SELECT COUNT(*) AS members,
       SUM(Churn) AS churned,
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_pct
FROM gym_raw;

---
SELECT Contract_period,
       COUNT(*) AS members,
       SUM(Churn) AS churned,
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_pct
FROM gym_raw
GROUP BY Contract_period
ORDER BY Contract_period;

---

SELECT CASE WHEN Lifetime <= 1 THEN '0-1 month'
            WHEN Lifetime <= 3 THEN '2-3 months'
            WHEN Lifetime <= 6 THEN '4-6 months'
            ELSE '7+ months' END AS tenure_bucket,
       COUNT(*) AS members,
       SUM(Churn) AS churned,
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_pct
FROM gym_raw
GROUP BY CASE WHEN Lifetime <= 1 THEN '0-1 month'
              WHEN Lifetime <= 3 THEN '2-3 months'
              WHEN Lifetime <= 6 THEN '4-6 months'
              ELSE '7+ months' END
ORDER BY churn_pct DESC;
---
SELECT CASE
         WHEN Avg_class_frequency_total = 0 THEN 'no history'
         WHEN Avg_class_frequency_current_month / Avg_class_frequency_total < 0.5 THEN 'dropped more than 50%'
         WHEN Avg_class_frequency_current_month / Avg_class_frequency_total < 0.8 THEN 'dropped 20-50%'
         ELSE 'stable or up'
       END AS attendance_trend,
       COUNT(*) AS members,
       SUM(Churn) AS churned,
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_pct
FROM gym_raw
GROUP BY CASE
           WHEN Avg_class_frequency_total = 0 THEN 'no history'
           WHEN Avg_class_frequency_current_month / Avg_class_frequency_total < 0.5 THEN 'dropped more than 50%'
           WHEN Avg_class_frequency_current_month / Avg_class_frequency_total < 0.8 THEN 'dropped 20-50%'
           ELSE 'stable or up'
         END
ORDER BY churn_pct DESC;

---
SELECT 'Group_visits' AS factor, Group_visits AS value, COUNT(*) AS members,
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_pct
FROM gym_raw GROUP BY Group_visits
UNION ALL
SELECT 'Promo_friends', Promo_friends, COUNT(*),
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2)
FROM gym_raw GROUP BY Promo_friends
UNION ALL
SELECT 'Near_Location', Near_Location, COUNT(*),
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2)
FROM gym_raw GROUP BY Near_Location
UNION ALL
SELECT 'Partner', Partner, COUNT(*),
       ROUND(100.0 * SUM(Churn) / COUNT(*), 2)
FROM gym_raw GROUP BY Partner;

---
SELECT TOP 100
       Age, Contract_period, Month_to_end_contract, Lifetime,
       Avg_class_frequency_total,
       Avg_class_frequency_current_month,
       ROUND(Avg_class_frequency_current_month / Avg_class_frequency_total, 2) AS visit_ratio
FROM gym_raw
WHERE Churn = 0
  AND Avg_class_frequency_total > 0
  AND Avg_class_frequency_current_month / Avg_class_frequency_total < 0.5
ORDER BY visit_ratio ASC;
---
















