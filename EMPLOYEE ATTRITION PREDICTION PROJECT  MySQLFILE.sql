USE employee_trends;
ALTER TABLE aemployee_trends RENAME COLUMN ï»¿emp_no to emp_no;
ALTER TABLE aemployee_trends RENAME TO employee_trends;

#TOTAL EMPLOYEE COUNT
SELECT count(emp_no) from employee_trends;

#TOTAL EMPLOYEE COUNT
SELECT gender,count(emp_no) from employee_trends GROUP BY gender;

# What is the count of employees by department?
SELECT department,count(emp_no) AS employee_count from employee_trends group by department;

# What is the gender distribution across departments?
SELECT department,gender, count(emp_no) AS gender_count from employee_trends group by department,gender order by department;

 # Employee Count by Education Level
 SELECT education, count(emp_no) AS employee_count from employee_trends group by education;

#What is the overall employee attrition rate in the company?
SELECT COUNT(*) as total_employees ,
SUM(CASE WHEN attrition='yes' then 1 else 0 end) as attrition_count,
(SUM(CASE WHEN attrition='yes' then 1 else 0 end)*100.0)/(COUNT(*)) as attrition_rate
from employee_trends;

#Are there specific job roles more prone to attrition within high-risk departments?
SELECT department, job_role, COUNT(*) as total_employees ,
SUM(CASE WHEN attrition='yes' then 1 else 0 end) as attrition_count,
(SUM(CASE WHEN attrition='yes' then 1 else 0 end)*100.0)/(COUNT(*)) as attrition_rate
from employee_trends group by department,job_role order by attrition_rate DESC ;

#How does work tenure affect attrition rates in different departments?(Assuming age_band is a proxy for experience.)
SELECT age_band,department, COUNT(*) as total_employees ,
SUM(CASE WHEN attrition='yes' then 1 else 0 end) as attrition_count,
(SUM(CASE WHEN attrition='yes' then 1 else 0 end)*100.0)/(COUNT(*)) as attrition_rate
from employee_trends GROUP BY department, age_band ORDER BY department, age_band;

#What percentage of employees who left had reported high vs. low job satisfaction?
SELECT job_satisfaction, 
    (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM employee_trends WHERE attrition = 'Yes') AS percentage_of_attrition
FROM employee_trends
WHERE attrition = 'Yes'
GROUP BY job_satisfaction
ORDER BY job_satisfaction;

# Can we identify employees at high risk based on salary, job satisfaction?
#(Since salary and workload data are missing, we use job satisfaction and department trends.)

SELECT emp_no, department, job_role, age_band, job_satisfaction, attrition
FROM employee_trends
WHERE job_satisfaction <= 2 
AND department IN (SELECT department FROM employee_trends WHERE attrition = 'Yes')
ORDER BY job_satisfaction;


#What are the common patterns among employees who leave?
SELECT department, gender, age_band, education, job_role, 
       COUNT(*) AS total_attrition
FROM employee_trends
WHERE attrition = 'Yes'
GROUP BY department, gender, age_band, education, job_role
ORDER BY total_attrition DESC LIMIT 20;


#Does marital status impact employee attrition?Are single employees more likely to leave compared to married ones?
SELECT marital_status, 
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS attrition_rate
FROM employee_trends
GROUP BY marital_status
ORDER BY attrition_rate DESC;

#How do attrition rates differ between male and female employees?
SELECT gender, 
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS attrition_rate
FROM employee_trends
GROUP BY gender;

#Are employees who travel frequently more likely to leave
SELECT business_travel, 
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS attrition_rate
FROM employee_trends
GROUP BY business_travel
ORDER BY attrition_rate DESC;


SELECT gender, marital_status, age_band, education, education_field, job_role, 
       COUNT(*) AS attrition_count
FROM employee_trends
WHERE attrition = 'Yes'
GROUP BY gender, marital_status, age_band, education, education_field, job_role
ORDER BY attrition_count DESC
LIMIT 50;


