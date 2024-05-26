/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/


SELECT
    skills_dim.skills,
    --skills_dim.skill_id,
    COUNT(skills_dim.skill_id) AS skill_demand,
    ROUND(AVG(salary_year_avg),2) AS avg_skill_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id)>
        (
            SELECT 
                ROUND(AVG(skill_demand),0) 
            FROM(
                    SELECT
                        COUNT(skills_dim.skill_id) AS skill_demand
                    FROM
                        job_postings_fact
                        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
                        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
                    WHERE
                        job_title_short = 'Data Analyst'
                        AND
                        job_location = 'Anywhere'
                        AND
                        salary_year_avg IS NOT NULL
                    GROUP BY
                        skills_dim.skill_id
            )
        )
    AND
    ROUND(AVG(salary_year_avg),2)>
        (
            SELECT
                ROUND(AVG(salary_year_avg),2)
            FROM
                job_postings_fact
            WHERE
                job_title_short = 'Data Analyst'
                AND
                job_location = 'Anywhere'
                AND
                salary_year_avg IS NOT NULL
        )
ORDER BY
    skill_demand DESC,
    avg_skill_salary DESC;

