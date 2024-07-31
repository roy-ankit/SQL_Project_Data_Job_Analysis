# Introduction
The aim of the project is to explore the data analyst roles and draw information on what the top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

1. The Data used : [sql_load](/sql_load/)
2. The SQL queries: [project_sql folder](/project_sql/)

# Background
The aim of the project is to enhance better understanding of the data analyst job market, with the aim of identifying top-paid and in-demand skills. By streamlining the process, it assists in better informed decision making by necessary upskilling in order to meet the criterion of optimal job opportunities more efficiently.

### The questions this project wants to answer through the SQL queries are:

1. What are the top-paying jobs?
2. What are the top-paying data analyst jobs?
3. What skills are required for these top-paying jobs?
4. What skills are most in demand for data analysts?
5. Which skills are associated with higher salaries?
6. What are the most optimal skills to learn?

# Tools used
The following tools were used to do the necessary analysis:

- **SQL:** The backbone of the analysis, allowing to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** For database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing the SQL scripts and analysis, ensuring collaboration and project tracking.

# Analysis
Through each of the questions we are trying to unearth information of the data analyst job market and how to best position oneself in terms of skills to crack the next big job.

### 1. Top Paying Jobs
This tries to identify the highest paying jobs in terms of the average yearly salary and also working remotely.

```sql
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
```

Table for all the job roles with the avergae salary as well as the number of jobs available

| Job Title Short          | Job Count | Company Count | Avg Job Salary |
|--------------------------|-----------|---------------|----------------|
| Senior Data Scientist    | 335       | 219           | 163798.16      |
| Machine Learning Engineer| 40        | 33            | 148670.45      |
| Senior Data Engineer     | 278       | 193           | 148245.25      |
| Cloud Engineer           | 9         | 7             | 147111.11      |
| Data Scientist           | 953       | 572           | 144398.25      |
| Data Engineer            | 753       | 467           | 132363.57      |
| Software Engineer        | 65        | 53            | 122367.02      |
| Senior Data Analyst      | 158       | 96            | 113335.16      |
| Business Analyst         | 78        | 62            | 97113.83       |
| Data Analyst             | 604       | 308           | 94769.86       |

Highlights:
1. Senior Data Scientist and Machine Learning Engineer are the highest paying job roles, however it should be kept in mind that these are senior roles that are available to experienced candidates.
2. Data analyst and Business analyst are the least paying job roles.
3. Despite being the least paying role, Data analysts are very much in demand as is evident with the significantly higher number of jobs being advertised for.

### 2. Top Paying Data Analyst Jobs
This tries to highlight the companies that are offering the highest paying data analyst job roles that are available with remote working availability.

```sql
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
```

Highlights:
1. **Wide Salary Range:** There is significant earning potentital in this role as is evident from the Top 10 paying roles spanning from $184,000 to $650,000.
2. **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
3. **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 3. Skills for Top Paying Jobs
This tries to highlight the skills that are required for top-paying jobs, providing insights into what employers value for high-compensation roles.


```sql
WITH top_paying_da_jobs AS (
    SELECT 
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
    LIMIT 10
)


SELECT
    --job.job_title_short,
    job.*,
    sk.skills
FROM
    top_paying_da_jobs AS job
    INNER JOIN skills_job_dim AS s_job 
        ON s_job.job_id = job.job_id
    INNER JOIN skills_dim AS sk
        ON sk.skill_id = s_job.skill_id;
```
Highlights:
1. **SQL** is leading with a total count of 8.
2. **Python** follows closely with a total count of 7.
3. **Tableau** is also highly sought after, with a total count of 6.
Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.


### 4. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in data analyst remote job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    COUNT(skills_dim.skill_id) AS demand_count
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
    skills
ORDER BY
    demand_count DESC
LIMIT
    5;
```

*Table of the demand for the top 5 skills in data analyst remote job postings*

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |


Highights:
1. **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
2. **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

### 5. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills,
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
    skills
ORDER BY
    avg_skill_salary DESC
LIMIT
    10;
```
*Table of the average salary for the top 10 paying skills for data analysts*

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |


Highlights:
1. **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
2. **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
3. **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.


### 6. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```
*Table of the most optimal skills for data analyst sorted by demand*

| Skills      | Skill Demand | Avg Skill Salary |
|-------------|--------------|------------------|
| SQL         | 398          | 97237.16         |
| Python      | 236          | 101397.22        |
| Tableau     | 230          | 99287.65         |
| R           | 148          | 100498.77        |
| Power BI    | 110          | 97431.30         |
| SAS         | 63           | 98902.37         |
| SAS         | 63           | 98902.37         |
| Looker      | 49           | 103795.30        |
| Snowflake   | 37           | 112947.97        |
| Oracle      | 37           | 104533.70        |
| SQL Server  | 35           | 97785.73         |
| Azure       | 34           | 111225.10        |
| AWS         | 32           | 108317.30        |
| Flow        | 28           | 97200.00         |
| Go          | 27           | 115319.89        |
| Hadoop      | 22           | 113192.57        |

Highlights:
1. **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
2. **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
3. **Business Intelligence and Visualization Tools:** Tableau, Power BI and Looker, with demand counts of 230, 110 and 49 respectively, and average salaries around $99,288, $97,431 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
4. **Database Technologies:** The demand for skills in traditional databases (Oracle, SQL Server) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# Learnings

Key learnings in terms of technical ability:

1. Mastered the art of advanced SQL, merging tables using joins and executing various functions using WITH, HAVING clauses.
2. Data Aggregation method using GROUP BY and aggregate functions like COUNT() and AVG().

# Inference
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

# Conclusion

This project provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

# Reference

1. The idea of this project is based on the work provided by Mr. Luke Barousse. The work that has been referenced is provided [here](https://lukebarousse.com/sql)