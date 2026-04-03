/*
Question: What are the highest-paying skills for Data Scientists?
- Calculate the median salary for each skill required in data scientist positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 2) AS median_salary,
    COUNT(jpf.*) AS job_counts
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Scientist'
    AND jpf.job_work_from_home = True
GROUP BY 
    sd.skills
HAVING 
    COUNT(jpf.*) >= 100
ORDER BY 
    median_salary DESC
LIMIT 25;


/*
Quick insights from the results:

Atlassian stands out significantly with the highest median salary (~217k).
Collaboration/enterprise tools like Slack and Zoom also rank surprisingly high.
Backend and systems skills (Go, C, DynamoDB, Redis) dominate the upper tier.
AI-related Hugging Face is already in the top 10, showing strong demand.

┌──────────────┬───────────────┬────────────┐
│    skills    │ median_salary │ job_counts │
│   varchar    │    double     │   int64    │
├──────────────┼───────────────┼────────────┤
│ atlassian    │      217500.0 │        133 │
│ slack        │      175000.0 │        148 │
│ dynamodb     │      174500.0 │        106 │
│ neo4j        │      165000.0 │        146 │
│ go           │      163500.0 │       1261 │
│ c            │      163500.0 │        654 │
│ gdpr         │      162500.0 │        271 │
│ redis        │      162500.0 │        127 │
│ zoom         │      161250.0 │        150 │
│ hugging face │      160500.0 │        213 │
│ terraform    │      160500.0 │        230 │
│ opencv       │      160000.0 │        214 │
│ sheets       │      152500.0 │        150 │
│ scala        │      151250.0 │       1280 │
│ bigquery     │      150000.0 │        841 │
│ flow         │      150000.0 │        847 │
│ airflow      │      150000.0 │       1009 │
│ php          │      150000.0 │        109 │
│ pytorch      │      149287.5 │       3546 │
│ kubernetes   │      149000.0 │        849 │
│ snowflake    │      146000.0 │       1520 │
│ redshift     │      146000.0 │        893 │
│ splunk       │      145750.0 │        100 │
│ jira         │      145250.0 │        577 │
│ matplotlib   │      145000.0 │       1249 │
├──────────────┴───────────────┴────────────┤
│ 25 rows                         3 columns │
└───────────────────────────────────────────┘
*/