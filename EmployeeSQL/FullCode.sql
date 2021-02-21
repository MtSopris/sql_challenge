-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     ),
    CONSTRAINT "uc_departments_dept_name" UNIQUE (
        "dept_name"
    )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title" varchar   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);
drop table "titles"
CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    --"emp_no" int   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title"--,"emp_no"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
--REFERENCES "employees" ("emp_no");



--List the following details of each employee: employee number, last name, first name, sex, and salary.
create view emp_details_salary as
select e.emp_no,e.last_name,e.first_name,e.sex,s.salary
from employees as e
inner join salaries as s on
e.emp_no=s.emp_no

--List first name, last name, and hire date for employees who were hired in 1986.
create view hires_1986 as
select first_name, last_name, hire_date from employees
where hire_date >='1986-01-01' and hire_date <='1986-12-31';


--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.
create view mgr_of_dep as
select m.dept_no,d.dept_name,m.emp_no,e.last_name,e.first_name 
from dept_manager as m
inner join departments as d on
m.dept_no=d.dept_no
inner join employees as e on
m.emp_no=e.emp_no

--List the department of each employee with the following information: 
--employee number, last name, first name, and department name
create view emp_of_dept as
select e.emp_no,e.last_name,e.first_name,d.dept_name 
from employees as e
inner join dept_emp as de on
e.emp_no=de.emp_no
inner join departments as d on
de.dept_no=d.dept_no

--List first name, last name, and sex for employees
--whose first name is "Hercules" and last names begin with "B."
create view hercules as
select first_name,last_name,sex from employees
where first_name='Hercules'
and last_name like 'B%'

--List all employees in the Sales department,including their
--employee number, last name, first name, and department name
create view sales_emp as
select * from emp_of_dept
where dept_name = 'Sales'
-- where dept_name = lower('sales')--why does this not work?

--List all employees in the Sales and Development departments, including their
--employee number, last name, first name, and department name.
create view sales_dev_emp as
select * from emp_of_dept
where dept_name = 'Sales' or dept_name = 'Development'

--In descending order, list the frequency count of employee
--last names, i.e., how many employees share each last name.
create view count_last_name as
select last_name,count(distinct last_name) as "each_name"
from employees
group by last_name
order by "each_name" desc