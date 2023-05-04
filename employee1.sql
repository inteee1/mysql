SELECT * FROM employees.employees;
use employees;
-- 실습 1, 입사일자가 빠른 사람 10명을 출력하시오. 
select * from employees order by hire_date ASC, emp_no ASC limit 10;
select * from employees where hire_date >= '1990-01-01' order by hire_date ASC, emp_no ASC limit 100;
desc employees.employees;