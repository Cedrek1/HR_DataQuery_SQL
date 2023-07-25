select *
from hrdata$


select Sum(employee_count)
from hrdata$
where education = 'High School'



select Sum(employee_count)
from hrdata$
where department = 'Sales'

select Sum(employee_count)
from hrdata$
where department = 'R&D'


select Sum(employee_count) as employee_count_education_field
from hrdata$
where education_field = 'medical'


--Check methode Using Active_Employee
select active_employee,
Case
When active_employee = '0' Then Count(active_employee) 
END as Attrition_Count

from hrdata$
group by active_employee


--Checking the number of employees at 'Doctoral Degree'

select count(employee_count)
from hrdata$
where education = 'Doctoral Degree'

--Checking the number of attrition count of employees of education 'Doctoral Degree'

Select count(attrition)
from hrdata$
where attrition = 'Yes' And education = 'Doctoral Degree'

--Checking the number of attrition count of employees at Department of'R&D' and education field of 'Medical'

Select count(attrition)
from hrdata$
where attrition = 'Yes' And department = 'R&D'And education_field = 'Medical'

--Checking the number of attrition count of employees at Department of'R&D' and education of ' High School' and education field of 'Medical'

select count (attrition)
from hrdata$
where education = 'High School' and attrition = 'Yes' And department = 'R&D' And education_field = 'Medical'

--Checking the number of attrition count of employees at Department of'R&D' and education of ' High School' and education field of 'Medical'

--Checking the attrition rate
--First Methode Using CTE

With t1 as
(
select SUM(employee_count) as Sum_Of_Employee
from hrdata$
),

t2 as
(
    SELECT count(attrition) AS Count_Of_Attrition
    FROM hrdata$
	Where attrition = 'Yes'
)

select round((t2.Count_Of_Attrition/t1.Sum_Of_Employee )*100,2)
from t1,t2;

--Using Subquery

select

round(((select COUNT(attrition)
from hrdata$
Where attrition = 'Yes') / SUM( employee_count)) * 100,2)
from hrdata$

--Checking the attrition rate where Department is at 'Sales'

select
round(((select COUNT(attrition)
from hrdata$
Where attrition = 'Yes'And department = 'Sales') / SUM( employee_count)) * 100,2)
from hrdata$
Where department = 'Sales'


--Checking The number of active employee
--First Methode

Select  Count(active_employee)
from hrdata$
Where active_employee = '1'

--Second Methode

Select SUM(employee_count) -
(select Count(attrition)
from hrdata$
where attrition = 'Yes'
)

from hrdata$

--Checking The number of active employee By Filtring Gender 'Male'

Select SUM(employee_count) -
(select Count(attrition) 
from hrdata$
where attrition = 'Yes' And gender = 'Male'
)

from hrdata$
Where gender = 'Male'

--Checking Average Age

select round(AVG(age),0) as Avg_Age
from hrdata$

--Checking Attrition by gender 

select gender ,COUNT(attrition) as Attrition_Count_By_Gender
from hrdata$
Where attrition = 'Yes'
group by gender
order by Attrition_Count_By_Gender desc

--Checking Attrition by gender and their education 'High School' 

select gender ,COUNT(attrition) as Attrition_Count_By_Gender
from hrdata$
Where attrition = 'Yes' and education = 'High School'
group by gender
order by Attrition_Count_By_Gender desc



--Department wise Attrition:
--Firt Methode

select department ,SUM(employee_count),
round((SUM(employee_count)/(select SUM(employee_count) from hrdata$ where attrition = 'Yes') *100),2)

from hrdata$
where attrition = 'Yes'
group by department
order by SUM(employee_count) desc

--Second Methode
SELECT department, COUNT(attrition),
CAST(ROUND((CAST(COUNT(attrition) AS numeric) / (SELECT COUNT(attrition) FROM hrdata$ WHERE attrition = 'Yes')) * 100, 2) AS DECIMAL(10, 2)) AS pct
FROM hrdata$
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY COUNT(attrition) DESC;

--Checking No of Employee by age group

select age, SUM(employee_count) as No_Of_Employee
from hrdata$
group by age
order by age


--Checking No of Employee(attrition) by education_field 

select education_field, SUM(employee_count)
from hrdata$
Where attrition = 'Yes'
group by education_field
order by SUM(employee_count) desc

----Checking No of Employee(Attrition) by age_band,gender

select age_band,gender, SUM(employee_count) as No_Of_Employee
from hrdata$
Where attrition = 'Yes'
group by age_band,gender
order by age_band,gender

----Checking No of Employee(Attrition Rate) by age_band,gender

select age_band,gender, SUM(employee_count) as No_Of_Employee,
round((SUM(employee_count) / (select SUM(employee_count) from hrdata$ where attrition = 'Yes'))*100,2) as percentage_rate
from hrdata$
Where attrition = 'Yes'
group by age_band,gender
order by age_band,gender




select	distinct job_role, Sum(employee_count), job_satisfaction 
from hrdata$
pivot
('SELECT job_role, job_satisfaction, sum(employee_count)
   FROM hrdata
   GROUP BY job_role, job_satisfaction
   ORDER BY job_role, job_satisfaction'
) as pt


select distinct job_role,job_satisfaction 
from hrdata$
group by job_role,job_satisfaction