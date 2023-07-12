--Q.1(a) salary between 200000 and 300000 

select * from employee 
where salary between 200000 and 300000;

--alternative query 

select * from employee 
where salary>200000 and salary <300000

--Q.2(b) Same city employee 
select empname from employee
where city IN (select city from employee group by city having count(*) >1);

--OR
select E1.* ,E2.* from  employee AS E1 join employee E2
ON E1.city=E2.city 

--Q.3(C) Null value check in table employee
select * from employee
where  empid is NULL

--Q.2(a) 
select empname ,salary ,SUM(salary)over (order by empid) AS cumulativesum from employee;
--Q.2(b) Male and female ratio in table employee

SELECT 
    (SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Male_ratio,
    (SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Female_ratio
FROM 
    employee;
     )
     ------OR------------------
    select 
    (count(*) filter (where gender='M')*100.0/count(*)) AS malepct,
    (COUNT(*) filter (where gender='F')*100.0/count(*)) AS Femalepct
    from employee
    
    --Q.2(C) get the 50% values from table
    select * from employee
    where empid <=(select count(empid)/2 from employee)
    
   --Q.3(a) Query to featch salary but replace the last two digit  with X
   
   select salary ,CONCAT(SUBSTRING(salary::text,1,length(salary::text)-2),'XX') AS masked_number 
   from employee;
   --------OR------------------------------------
   Select salary ,concat(left(cast(salary as text),LENGTH(CAST(salary AS text))-2,'XX') AS masked
   from employee;
 --Q.4 write a query to featch the even and odd number of rows
                         
   --featch even rows 
 select * from (select *,ROW_NUMBER() over (order by empid) AS Rownumber  from employee) AS emp                   
 where emp.Rownumber %2 =0 
    --featch odd rows 
 select * from (select *,ROW_NUMBER() over (order by empid) AS Rownumber  from employee) AS emp                   
 where emp.Rownumber %2 =1            
                         
  --Q.5(a) Write a query to find all the employee names whose name start:
      -- Begin with 'A'
      --contain 'A' alphabate at second place
      --contain 'Y' alphabate at second last place
     --End with 'L' and contain 4 alphabates
     --Begains with 'V' and ends with 'A'
   select * from employee where empname LIKE 'A%'
   select * from employee where empname LIKE '_a%'  
   select * from employee where empname LIKE '%y_'
   select * from employee where empname LIKE '____l'
   select * from employee where empname LIKE 'V%a'
                         
   --Q.5(b) Write a query to find the list the employee names which is :
     --starting with vowels [a,e,i,o,u] ,without duplicatesemployee
      --ending with vowels [a,e,i,o,u] ,without duplicatesemployee
      --starting and ending with vowels [a,e,i,o,u] ,without duplicatesemployee
   select DISTINCT(empname) from employee
   where lower (empname)  similar to '[aeiou]%';
                         
   select DISTINCT(empname) from employee
   where lower (empname)  similar to '%[aeiou]';
                         
   select DISTINCT(empname) from employee
   where lower (empname)  similar to '[aeiou] %[aeiou]';
                         
  --Q.6 find the Nth highest salary from employee with and without top/limit  keywords :
      
   select E1.salary from employee E1
   where N-1 = (select count(DISTINCT (E2.salary)) from employee E2
                where E2.salary >E1.salary);
   -------OR------------------------------
    select E1.salary from employee E1
   where N = (select count(DISTINCT (E2.salary)) from employee E2
                where E2.salary >=E1.salary);
                         
    --Q.7 Write a query to find and remove duplicates the records from table
        select empid,empname,gender,salary,city ,count(*) AS duplicate_count from employee
        group by empid,empname,gender,salary,city
        Having count (*) >1 
    -----OR----------------
        select empid,count(*) AS duplicate_count from employee
        group by empid
        Having count (*) >1 
      
      ---Delete the duplicate values
        delete from employee
        where empid  IN (select empid,count(*) AS duplicate_count from employee
        group by empid
        Having count (*) >1 )
    --Q.7(b) Query to list of employees working in same projects 
                         
       WITH CTE AS (select e.EmpID,e.EmpName ,ed.project from employee as e  join employeedetail AS ed 
                    ON e.empid=ed.empid)
       select c1.EmpName,c2.EmpName ,c1.project from CTE c1,CTE c1 
                         where c1.project=c2.project and c1.EmpID !=c2.EmpID AND c1.EmpID <c2.EmpID
     --Q.8 show the employee with the highest salary for each project 
                         
         select ed.project ,MAX(e>Salary) AS projectMaxsal,SUM(e.salary) AS projectTotalSal from employee AS e 
                         INNER JOIN employeedetail  AS ed
                         ON e.empid=ed.empid
                         group by project order by  projectMaxsal desc ;
     
     ---Q.9 Query to find the total count of employee joined each year 
     
       select extract('year' from doj) AS joinyear ,Count(*) AS empcount
                         from employee AS e inner join employeedetail AS ed 
                         ON e.empid=ed.empid
                         group by joinyear 
                         order by joinyear asc 
   
    --Q.10(a)  Create 3 groups based on salary  col ,salary less than 1L is low ,between 1L-2L is medium   and above 2L is high 
                         
         select empname ,salary,
                         Case 
                         WHEN salary >200000 THEN 'High'
                         when salary >100000 AND salary <200000 then 'Medium'
                         else 'Low'
                         END AS Salarystatus
                         from employee
  --Q.10 (b) query to piviot the data in employee table and retrive the total salary each day 
          
    SELECT empid ,empname,
    SUM(CASE when city ='Mathura' then salary END ) AS "Mathura",
    SUM(CASE when city ='Pune' then salary END ) AS "Pune",
   SUM(CASE when city ='Delhi' then salary END ) AS "Delhi"
    from employee 
    group by empid ,empname;
        
                        
                         
                        
                         
                         