/*
Question: What are the most optimal skills for data scientists—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Scientist positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data science careers.
*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 2) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*))) / 1_000_000, 2) AS optimal_score
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Scientist'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY 
    sd.skills
HAVING 
    COUNT(jpf.*) >= 100
ORDER BY 
    optimal_score DESC
LIMIT 25;


/*
Top Skills by Optimal Score
Python leads with the highest optimal score (0.99), combining massive demand (1545 postings) with a strong median salary (~$134.5K).
SQL follows closely (0.95), reinforcing its role as a core data engineering skill with high demand (1140 postings) and solid pay (~$135K).
R (0.89) remains relevant with good demand (772 postings) and competitive salary levels.
Tableau and AWS (both 0.81) highlight the importance of data visualization and cloud platforms in modern data roles.
PyTorch and TensorFlow (~0.80) show that machine learning frameworks are increasingly valuable, offering higher salaries (~$145K–$149K) despite moderate demand.
Spark (0.79) continues to be a key big data technology with a strong balance of demand and compensation.

Cloud, Big Data & ML Ecosystem
AWS, Azure, and GCP all appear, confirming that multi-cloud knowledge is highly valuable:
AWS leads in optimal score (0.81), followed by Azure (0.74) and GCP (0.61).
Spark, Hadoop, and Databricks form the backbone of big data processing:
Spark stands out with both strong demand and salary.
Hadoop and Databricks have moderate demand but still contribute to a well-rounded profile.
Snowflake (0.72) offers high salaries (~$146K) despite lower demand, making it a premium niche skill.

Analytics & BI Tools
Tableau (0.81) and Looker (0.66) show strong relevance in data visualization.
Power BI (0.60) and Excel (0.61) remain widely used, though with slightly lower optimal scores.

Summary:

The most optimal data engineering skill set clearly centers around:
Core stack: Python + SQL
Cloud: AWS / Azure / GCP
Big Data: Spark + Hadoop
Specialization options: Snowflake, Scala, ML frameworks

┌──────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│    skills    │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│   varchar    │    double     │    int64     │     double      │    double     │
├──────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ python       │      134500.0 │         1545 │             7.3 │          0.99 │
│ sql          │      135000.0 │         1140 │             7.0 │          0.95 │
│ r            │      134500.0 │          772 │             6.6 │          0.89 │
│ tableau      │      135000.0 │          398 │             6.0 │          0.81 │
│ aws          │      134500.0 │          423 │             6.0 │          0.81 │
│ pytorch      │      149287.5 │          213 │             5.4 │           0.8 │
│ tensorflow   │      145000.0 │          241 │             5.5 │           0.8 │
│ spark        │      140000.0 │          280 │             5.6 │          0.79 │
│ azure        │     128658.68 │          310 │             5.7 │          0.74 │
│ pandas       │     139042.25 │          188 │             5.2 │          0.73 │
│ snowflake    │      146000.0 │          137 │             4.9 │          0.72 │
│ sas          │      123000.0 │          314 │             5.7 │          0.71 │
│ hadoop       │      138750.0 │          162 │             5.1 │          0.71 │
│ scikit-learn │      141005.5 │          150 │             5.0 │          0.71 │
│ scala        │      151250.0 │          102 │             4.6 │           0.7 │
│ numpy        │      141000.0 │          122 │             4.8 │          0.68 │
│ looker       │      135000.0 │          136 │             4.9 │          0.66 │
│ java         │      129750.0 │          148 │             5.0 │          0.65 │
│ databricks   │      120000.0 │          172 │             5.1 │          0.62 │
│ gcp          │      120000.0 │          166 │             5.1 │          0.61 │
│ excel        │      121000.0 │          153 │             5.0 │          0.61 │
│ power bi     │      122750.0 │          138 │             4.9 │           0.6 │
│ git          │      127390.0 │          101 │             4.6 │          0.59 │
│ jupyter      │      74743.75 │          116 │             4.8 │          0.36 │
├──────────────┴───────────────┴──────────────┴─────────────────┴───────────────┤
│ 24 rows                                                             5 columns │
└───────────────────────────────────────────────────────────────────────────────┘
*/