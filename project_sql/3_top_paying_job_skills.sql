/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/


WITH top_paying_da_jobs AS (
    select 
        job_id,
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
    limit 10
)


SELECT
    -- job.job_title_short,
    job.*,
    sk.skills
FROM
    top_paying_da_jobs AS job
    INNER JOIN skills_job_dim AS s_job 
        ON s_job.job_id = job.job_id
    INNER JOIN skills_dim AS sk
        ON sk.skill_id = s_job.skill_id;
-- GROUP BY
--     sk.skills;
-- ORDER BY
--     skill_count DESC;