/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely
- Focus on job postings with salaries mentioned (remove nulls)
- BONUS: Include company names of top 10 roles
- Outcome : Highlights the top-paying opportunities for Data Analysts, offering insights into companies, salary and location flexibility.
*/

SELECT 
    name AS company_name,
    job_title,
    job_title_short,
    job_location,
    salary_year_avg
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
