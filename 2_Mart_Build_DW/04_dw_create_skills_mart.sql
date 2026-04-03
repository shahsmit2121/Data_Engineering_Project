-- Step 4: Mart - Create skills demand mart



DROP SCHEMA IF EXISTS skills_mart CASCADE;



CREATE SCHEMA skills_mart;

SELECT '++++++++++ Loading Skills Dimension +++++++++++' AS info;
CREATE TABLE IF NOT EXISTS skills_mart.dim_skills (
        skill_id        INTEGER         PRIMARY KEY,
        skills          VARCHAR,
        type            VARCHAR
);

INSERT INTO skills_mart.dim_skills(
    skill_id,
    skills,
    type
)
SELECT 
    skill_id,
    skills,
    type
FROM skills_dim;


SELECT '++++++++++ Loading Date Dimension +++++++++++' AS info;
CREATE TABLE skills_mart.dim_date_month (
    month_start_date        DATE PRIMARY KEY,
    year                    INTEGER,
    month                   INTEGER,
    quarter                 INTEGER,
    quarter_label           VARCHAR,
    year_quarter            VARCHAR
);

INSERT INTO skills_mart.dim_date_month(
    month_start_date,
    year,
    month,
    quarter,
    quarter_label,
    year_quarter
)
SELECT DISTINCT
    DATE_TRUNC('month', job_posted_date) as month_start_date,
    EXTRACT(YEAR FROM job_posted_date) as year,
    EXTRACT(MONTH FROM job_posted_date) as month,
    EXTRACT(QUARTER FROM job_posted_date) as quarter,
    'Q-' || EXTRACT(QUARTER FROM job_posted_date)::VARCHAR as quarter_label,
    EXTRACT(YEAR FROM job_posted_date)::VARCHAR || '-Q' || 
    EXTRACT(QUARTER FROM job_posted_date)::VARCHAR as year_quarter
FROM job_postings_fact
ORDER BY month_start_date;


SELECT '++++++++++ Loading Skill Demand Fact +++++++++++' AS info;
CREATE TABLE IF NOT EXISTS skills_mart.fact_skill_demand_monthly (
    skill_id                        INTEGER,
    month_start_date                DATE,
    job_title_short                 VARCHAR,
    postings_count                  INTEGER,
    remote_jobs                     INTEGER,
    jobs_with_health_insurance      INTEGER,
    jobs_without_degree             INTEGER,
    PRIMARY KEY(skill_id, month_start_date, job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);


INSERT INTO skills_mart.fact_skill_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_jobs,
    jobs_with_health_insurance,
    jobs_without_degree
)
WITH job_postings_prep AS (
    SELECT
        sjd.skill_id,
        DATE_TRUNC('month', jpf.job_posted_date) as month_start_date,
        jpf.job_title_short,
        -- convert boolean flags (1 or 0)
        CASE
            WHEN jpf.job_work_from_home = TRUE THEN 1 ELSE 0 END AS is_remote,
        CASE 
            WHEN jpf.job_health_insurance = TRUE THEN 1 ELSE 0 END AS has_health_insurance,
        CASE 
            WHEN jpf.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_mentioned
    FROM job_postings_fact AS jpf
    INNER JOIN 
        skills_job_dim AS sjd 
        ON sjd.job_id = jpf.job_id
)
SELECT
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS postings_count,
    SUM(is_remote) AS remote_jobs,
    SUM(has_health_insurance) AS jobs_with_health_insurance,
    SUM(no_degree_mentioned) AS jobs_without_degree
FROM job_postings_prep
GROUP BY    
    ALL
ORDER BY 
    skill_id, month_start_date, job_title_short;



SELECT 'Skill Dimension' AS table_name, COUNT(*) AS record_count FROM skills_mart.dim_skills
UNION ALL
SELECT 'Date Dimension' AS table_name, COUNT(*) AS record_count FROM skills_mart.dim_date_month
UNION ALL
SELECT 'Skill Demand Fact' AS table_name, COUNT(*) AS record_count FROM skills_mart.fact_skill_demand_monthly
;


SELECT '++++++++++ Skill Dimension Sample ++++++++++' AS info;
SELECT * FROM skills_mart.dim_skills LIMIT 10;

SELECT '++++++++++ Date Dimension Sample ++++++++++' AS info;
SELECT * FROM skills_mart.dim_date_month LIMIT 10;

SELECT '++++++++++ Skill Demand Fact Sample ++++++++++' AS info;
SELECT * FROM skills_mart.fact_skill_demand_monthly LIMIT 10;