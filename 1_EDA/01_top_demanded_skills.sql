/*
Question: What are the most in-demand skills for Data Scientists?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for Data Scientists
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for Data Scientists seeking remote work
*/

SELECT
    sd.skills,
    COUNT(*) AS job_counts
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title = 'Data Scientist'
    AND jpf.job_work_from_home = True
GROUP BY 
    sd.skills
ORDER BY 
    job_counts DESC
LIMIT 10;


/*
Key takeaways:

Python and SQL form the core foundation, with Python clearly leading in demand
R remains relevant, especially for statistical and analytical roles
AWS dominates cloud demand, with Azure trailing behind
Data visualization skills (Tableau) are highly valued alongside technical skills
Machine learning frameworks (TensorFlow, PyTorch) are in strong demand
Big data tools like Spark continue to play an important role
Supporting libraries like Pandas are essential but often expected as baseline knowledge rather than standout skills

┌────────────┬────────────┐
│   skills   │ job_counts │
│  varchar   │   int64    │
├────────────┼────────────┤
│ python     │       4796 │
│ sql        │       3457 │
│ r          │       2151 │
│ aws        │       1324 │
│ tableau    │       1162 │
│ spark      │       1043 │
│ tensorflow │       1029 │
│ azure      │        946 │
│ pytorch    │        931 │
│ pandas     │        834 │
├────────────┴────────────┤
│ 10 rows       2 columns │
└─────────────────────────┘
*/