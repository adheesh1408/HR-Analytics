-- Create schema 
CREATE SCHEMA IF NOT EXISTS hr;

-- Create Base tables; extra commands for tidiness
DROP TABLE IF EXISTS hr.employee_master CASCADE;
CREATE TABLE hr.employee_master (
  employee_id          INT PRIMARY KEY,
  gender               CHAR(1) CHECK (gender IN ('M','F')),
  age                  INT CHECK (age BETWEEN 18 AND 70),
  department           VARCHAR(50),
  job_role             VARCHAR(80),
  salary               NUMERIC(10,2),         -- has some NULLs for imputation
  hire_date            DATE NOT NULL,
  exit_date            DATE,                  -- NULL = still employed
  reason_for_exit      VARCHAR(80)
);

DROP TABLE IF EXISTS hr.engagement_metrics CASCADE;
CREATE TABLE hr.engagement_metrics (
  employee_id          INT PRIMARY KEY REFERENCES hr.employee_master(employee_id),
  performance_score    INT CHECK (performance_score BETWEEN 1 AND 5),
  satisfaction_score   NUMERIC(3,1),
  engagement_score     NUMERIC(3,1),
  promotion_last_2yrs  INT CHECK (promotion_last_2yrs IN (0,1)),
  training_hours       INT,
  manager_rating       NUMERIC(3,1)
);

select count(*) from hr.engagement_metrics; -- checking if data is imported correctly
select count(*) FROM hr.employee_master;

select * from hr.employee_master limit 5; -- preview the imported data before starting cleaning 
select * from hr.engagement_metrics limit 5;

SELECT COUNT(*) AS joinable_records
FROM hr.employee_master e
JOIN hr.engagement_metrics m using (employee_id);   -- confirming that the IDs match


-- Data cleaning begins

-- begin with trimming and standardizing the department names as they're inconsistent
UPDATE hr.employee_master
SET department = TRIM(department);

-- correcting inconsistencies 
UPDATE hr.employee_master
SET department = 'Finance'
WHERE department ILIKE 'finanace';

-- same for "Sales"
UPDATE hr.employee_master
SET department = 'Sales'
WHERE department ILIKE 'sales';

-- On to handling nulls. Imputing median for  "null" salaries

WITH dept_median AS (      -- finding the median 
  SELECT department,
         PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS med_salary
  FROM hr.employee_master
  WHERE salary IS NOT NULL
  GROUP BY department
)
UPDATE hr.employee_master e                  -- check if it worked
SET salary = d.med_salary
FROM dept_median d
WHERE e.department = d.department
  AND e.salary IS NULL;

SELECT department, COUNT(*) AS missing_salaries   -- double check to see if it returns 0 rows
FROM hr.employee_master
WHERE salary IS NULL
GROUP BY department;


-- table already have a PK but double check for duplicates
SELECT employee_id, COUNT(*) 
FROM hr.employee_master
GROUP BY employee_id
HAVING COUNT(*) > 1;
-- above query returned 0 rows; data successfully cleaned


-- creating a view for analysis 

CREATE OR REPLACE VIEW hr.v_employee_analysis AS
SELECT
  e.employee_id,
  e.gender,
  e.age,
  e.department,
  e.job_role,
  e.salary,
  e.hire_date,
  e.exit_date,
  (e.exit_date IS NOT NULL)::INT AS attrited,   -- attrited flag , 1=left,0=still employed
  ROUND(
    GREATEST(0,
      (COALESCE(e.exit_date, DATE '2024-12-31') - e.hire_date)::NUMERIC / 365.0
    ), 2
  ) AS tenure_years,    -- finds the difference between hire date and exit date
  m.performance_score,
  m.satisfaction_score,
  m.engagement_score,
  m.promotion_last_2yrs,
  m.training_hours,
  m.manager_rating
FROM hr.employee_master e
JOIN hr.engagement_metrics m USING (employee_id);

-- view created, view the 'view'
SELECT * FROM hr.v_employee_analysis LIMIT 5; 


-- creating another view by segmented years
CREATE OR REPLACE VIEW hr.v_employee_analysis_segmented AS
SELECT
  *,
  CASE
    WHEN tenure_years < 1 THEN '<1 yr'
    WHEN tenure_years < 2 THEN '1-2 yrs'
    WHEN tenure_years < 5 THEN '2-5 yrs'
    ELSE '5+ yrs'
  END AS tenure_bucket,
  CASE
    WHEN age < 30 THEN '<30'
    WHEN age < 40 THEN '30-39'
    WHEN age < 50 THEN '40-49'
    ELSE '50+'
  END AS age_bucket
FROM hr.v_employee_analysis;

-- view the 'view'
SELECT employee_id, tenure_years, tenure_bucket, age, age_bucket
FROM hr.v_employee_analysis_segmented
LIMIT 5;

-- creating KPIs for the dashboard here 
SELECT
  ROUND(AVG(attrited)*100, 1)               AS attrition_rate_pct,
  ROUND(AVG(tenure_years), 2)               AS avg_tenure_years,
  ROUND(AVG(engagement_score), 2)           AS avg_engagement,
  ROUND(AVG(satisfaction_score), 2)         AS avg_satisfaction,
  ROUND(AVG(promotion_last_2yrs)*100, 1)    AS promotion_rate_pct,
  ROUND(AVG(salary), 0)                     AS avg_salary
FROM hr.v_employee_analysis;

-- the above ]KPIs are company wide; creating a department wide view
CREATE OR REPLACE VIEW hr.v_dept_summary AS
SELECT
  department,
  COUNT(*)                                  AS headcount,
  ROUND(AVG(attrited)*100, 1)               AS attrition_rate_pct,
  ROUND(AVG(tenure_years), 2)               AS avg_tenure_years,
  ROUND(AVG(engagement_score), 2)           AS avg_engagement,
  ROUND(AVG(satisfaction_score), 2)         AS avg_satisfaction,
  ROUND(AVG(salary), 0)                     AS avg_salary,
  ROUND(AVG(promotion_last_2yrs)*100, 1)    AS promotion_rate_pct
FROM hr.v_employee_analysis
GROUP BY department
ORDER BY attrition_rate_pct DESC;


--preview it and save it for tableau
SELECT * FROM hr.v_dept_summary;


--same for the first view 
SELECT * FROM hr.v_employee_analysis_segmented;

--now we have everything we need for the Tableau dashboard





