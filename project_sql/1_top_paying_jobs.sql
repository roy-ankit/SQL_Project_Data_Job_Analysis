/*
Question: What are the top-paying jobs?
- Identify the roles that offer highest average salary
- Identify the roles that offer remote working option
- Focus on job postings with salaries mentioned (remove nulls)
- Include number of companies with open roles
- Outcome : Highlights the top-paying opportunities, offering insights into employment options and location flexibility.
*/



SELECT
    job_title_short,
    COUNT(job_title_short) AS job_count,
    COUNT(DISTINCT company_id) AS company_count,
    ROUND(AVG(salary_year_avg),2) AS avg_job_salary
FROM 
    job_postings_fact
WHERE
    job_location = 'Anywhere'
    AND
    salary_year_avg IS NOT NULL
GROUP BY
    job_title_short
ORDER BY
    avg_job_salary DESC;