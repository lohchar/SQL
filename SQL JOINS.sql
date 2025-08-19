set search_path to learning;
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    manager_id INT,
    salary NUMERIC(8, 2)
);

INSERT INTO employees (name, department_id, manager_id, salary) VALUES
('Alice', 1, NULL, 50000),
('Bob', 2, 1, 45000),
('Charlie', 1, 1, 47000),
('Diana', 3, NULL, 60000),
('Eve', NULL, NULL, 40000);

select * from employees;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

INSERT INTO departments (department_id, department_name) VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Finance');

select * from departments;

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    employee_id INT
);

INSERT INTO projects (project_name, employee_id) VALUES
('Redesign Website', 1),
('Customer Survey', 2),
('Market Analysis', NULL),
('Mobile App Dev', 3),
('Budget Planning', NULL);

select * from projects;
select * from departments;
select * from employees;
select * from orders;
select * from customers;
select * from books;

--INNER JOIN -Return rows that have matching values in both tables
--employees assigned to a project
select name, project_name from employees
inner join projects on projects.employee_id=employees.employee_id;
--show employees and their departments
select name, department_name from employees
inner join departments on departments.department_id=employees.department_id;
--all customers and their order_id
select first_name,second_name, order_id from customers
inner join orders on customers.customer_id=orders.customer_id;
--full name of customers and the tittles of the books they ordered
select first_name, second_name, tittle from customers
inner join orders on customers.customer_id=orders.customer_id
inner join books on orders.book_id = books.book_id;
--orders placed after March 2024, customer names and book tittle
select first_name,second_name, tittle, order_date from customers
inner join orders on customers.customer_id=orders.customer_id
inner join books on orders.book_id=books.book_id
where order_date>'2023-03-31';
--books ordered more than once
select tittle,count(order_id) as order_count from books
inner join orders on books.book_id=orders.book_id
group by orders.book_id, books.tittle
having count(order_id)>1;

--LEFT JOIN -Return all rows from left table & matched rows from the right table
--All employees & their departments
select name, department_name from employees
left join departments on employees.department_id=departments.department_id;
--All customers & tittle of books ordered, including those that never ordered
select first_name, second_name, tittle from customers
left join orders on customers.customer_id=orders.customer_id
left join books on orders.book_id=books.book_id;
--All customers with email & order id if they made any orders
select first_name, second_name, email, order_id from customers
left join orders on customers.customer_id=orders.customer_id;

--RIGHT JOIN -Return all rows from right table & matched rows from the left table
--show employees & ALL departments, even empty ones
select name, department_name from employees
RIGHT JOIN departments on employees.department_id=departments.department_id;
--show projects and employees(even unassigned projects)
select name,project_name from employees
RIGHT JOIN projects on employees.employee_id = projects.employee_id;
--show projects with or without assigned employees
select name,project_name from projects
RIGHT JOIN employees on projects.employee_id = employees.employee_id;

--FULL OUTER JOIN -combines LEFT & RIGHT Joins -show all rows from both tables
--show employees and departments
select name, department_name from employees
FULL OUTER JOIN departments on employees.department_id=departments.department_id;

--CROSS JOIN -Returns every combination of rows fro both tables
--SELF JOIN -Joining a table to itself
--NATURAL JOIN -joins tables using all columns that have the same name

--WINDOW FUNCTIONS -Allows to perfom calculations across set of table rows
--1.ROW_NUMBER() -Assigns a unique no. to each row
--Assign unique row no. to each order based on order date reseting numbering from each
select order_id, first_name, second_name, order_date,
	row_number() over (partition by orders.customer_id order by orders.order_date)
as row_num from orders
join customers on orders.customer_id = customers.customer_id;
--Without resetting row number -remove PARTITION BY clause
select order_id, first_name, second_name, order_date,
	row_number() over (order by orders.order_date)
as row_num from orders
join customers on orders.customer_id=customers.customer_id;
--Assign row numbers to the orders for each customer, ordered by order_date
select order_id, first_name, second_name, order_date,
	row_number() over(partition by orders.customer_id order by orders.order_date ) as row_num from orders
join customers on orders.customer_id = customers.customer_id
order by orders.customer_id, orders.order_date;

--2.RANK() and DENSE RANK()
--RANK() -Assigns a rank to each row, with gaps in the ranking if there are ties
--Rank customers based on the total quantity of books they ordered
select first_name, second_name, SUM(quantity) AS total_quantity,
	RANK() OVER (ORDER BY SUM(quantity) DESC) AS rank
from orders
join customers on orders.customer_id=customers.customer_id
group by first_name, second_name;

--DENSE RANK()-does not leave gaps, 
select first_name, second_name, SUM(quantity) AS total_quantity,
	RANK() OVER (ORDER BY SUM(quantity) DESC) AS rank,
	dense_rank() OVER (ORDER BY SUM(quantity) DESC) AS dense_rank
from orders
join customers on orders.customer_id=customers.customer_id
group by first_name, second_name;
--LEAD() -Looks at next value 
--Compare quantity ordered by each customer in currrent row with quantity ordered in the next row
select order_id, customer_id, quantity,
	lead(quantity) over (order by order_id) as next_quantity
from orders;
--LAG() -looks at the previous value
--Compare quantity ordered by each customer in currrent row with quantity ordered in the previous row
select order_id, customer_id, quantity,
	lag(quantity) over (order by order_id) as previous_quantity
from orders;

--NTILE() Dividing data in to 2groups(quartiles)
--divide customers in to 2 groups based on their total order quantity
select first_name, second_name, SUM(quantity) as total_quantity,
	NTILE(2) over (order by sum(quantity) DESC) AS quantity_tile
from orders
join customers on orders.customer_id = customers.customer_id
group by first_name, second_name
order by quantity_tile;
--PARTITION BY -dividing result sets in to partitions and the functions work independently in each partition
--total quantity of orders for each customer & avearge price of books ordered by each customer
select customers.first_name, customers.second_name, SUM(orders.quantity) as total_quantity, 
	avg(books.price) as average_price, sum(orders.quantity) over (partition by orders.customer_id) as total_order_quantity
from orders
join customers on orders.customer_id=customers.customer_id
join books on orders.book_id = books.book_id
group by customers.first_name, customers.second_name, orders.quantity, orders.customer_id;


--SUBQUERIES -Queries within a query
set search_path to learning;
CREATE TABLE mental_health_patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    diagnosis VARCHAR(100)
);

-- Table: mental_health_doctors
CREATE TABLE mental_health_doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100)
);

-- Table: mental_health_visits
CREATE TABLE mental_health_visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    visit_type VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES mental_health_patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES mental_health_doctors(doctor_id)
);


INSERT INTO mental_health_patients (patient_id, first_name, last_name, age, diagnosis) VALUES
(1, 'Alice', 'Wanjiku', 28, 'Depression'),
(2, 'Brian', 'Odhiambo', 35, 'Anxiety'),
(3, 'Catherine', 'Kamau', 42, 'PTSD'),
(4, 'David', 'Mutua', 30, 'Bipolar Disorder'),
(5, 'Eunice', 'Omondi', 22, 'Depression'),
(6, 'Frank', 'Chege', 50, 'Anxiety'),
(7, 'Grace', 'Wambui', 27, 'Depression'),
(8, 'Henry', 'Kiptoo', 38, 'Schizophrenia'),
(9, 'Irene', 'Njeri', 45, 'PTSD'),
(10, 'James', 'Mwangi', 33, 'Depression');

INSERT INTO mental_health_doctors (doctor_id, first_name, last_name, specialization) VALUES
(1, 'Dr. Sheila', 'Mutiso', 'Psychologist'),
(2, 'Dr. Kevin', 'Mulei', 'Psychiatrist'),
(3, 'Dr. Linda', 'Barasa', 'Therapist'),
(4, 'Dr. Thomas', 'Ouma', 'Psychologist'),
(5, 'Dr. Nancy', 'Kariuki', 'Psychiatrist'),
(6, 'Dr. Peter', 'Otieno', 'Therapist'),
(7, 'Dr. Janet', 'Mutheu', 'Psychologist'),
(8, 'Dr. Dennis', 'Kimani', 'Psychologist'),
(9, 'Dr. Susan', 'Munyao', 'Therapist'),
(10, 'Dr. Robert', 'Ndegwa', 'Psychiatrist');

INSERT INTO mental_health_visits (visit_id, patient_id, doctor_id, visit_date, visit_type) VALUES
(1, 1, 1, '2024-01-10', 'Consultation'),
(2, 1, 4, '2024-03-15', 'Emergency'),
(3, 2, 2, '2024-01-20', 'Consultation'),
(4, 3, 3, '2024-02-05', 'Therapy'),
(5, 4, 4, '2024-01-25', 'Emergency'),
(6, 4, 2, '2024-03-01', 'Emergency'),
(7, 5, 1, '2024-02-28', 'Consultation'),
(8, 5, 1, '2024-04-10', 'Consultation'),
(9, 6, 5, '2024-03-17', 'Consultation'),
(10, 7, 6, '2024-05-01', 'Therapy'),
(11, 8, 7, '2024-04-05', 'Emergency'),
(12, 8, 1, '2024-06-12', 'Consultation'),
(13, 9, 4, '2024-03-12', 'Consultation'),
(14, 10, 2, '2024-04-15', 'Therapy'),
(15, 10, 5, '2024-05-25', 'Emergency');

select * from mental_health_patients;
select * from mental_health_doctors;
select * from mental_health_visits;
--SUBQUERIES -Queries within a query
--SELECT Clause 
--Total visits per patient
select first_name,last_name,
	(select count(*) from mental_health_visits where patient_id =mental_health_patients.patient_id) as total_visits
from mental_health_patients;
--Latest doctor visit for every patient
select first_name, last_name,
	(select max(visit_date) from mental_health_visits where patient_id = mental_health_patients.patient_id) as last_visit
from mental_health_patients;
--Average visits per patient, giving earliest date
select first_name,last_name,
	(select count(*) from mental_health_visits where patient_id =mental_health_patients.patient_id) as average_visits,
	(select min(visit_date) from mental_health_visits where patient_id =mental_health_patients.patient_id) as earliest_visit_date
from mental_health_patients;

--FROM Clause -Creating a derived/temporary table 
--Count visits per diagnosis
select diagnosis, total_visits
from (
	select diagnosis, count(*) as total_visits
	from mental_health_patients
	group by diagnosis) 
as diagnosis_visits;
--Average age per diagnosis
select diagnosis, average_age
from (
	select diagnosis, AVG(age) as average_age
	from mental_health_patients
	group by diagnosis
	) as diagnosis_age;
--WHERE CLAUSE -filter records based on results of another query
--Patients who visited a psychologist
select first_name, last_name 
from mental_health_patients
where patient_id in (
	select patient_id
	from mental_health_visits
	join mental_health_doctors on mental_health_visits.doctor_id = mental_health_doctors.doctor_id
	where mental_health_doctors.specialization = 'Psychologist'
);

--CORRELATED SUBQUERIES -Does row by row analysis
--Patients with more than 1 emergency visit
select first_name, last_name
from mental_health_patients
where(
	select count(*) from mental_health_visits 
	where patient_id=mental_health_patients.patient_id and mental_health_visits.visit_type ='Emergency'
)>1;
--Patients who have visited multiple doctors
select first_name, last_name
from mental_health_patients
where (
	select count(distinct doctor_id)
	from mental_health_visits
	where patient_id =mental_health_patients.patient_id
)>1;

--COMMON TABLE EXPRESSIONS(CTE)
--CTE is a temporary result set in sql
--Syntax for CTEs
--WITH cte_name as (
		select column1, column2
		from table_name
		where conditions
)
select *
from cte_name;

--Basic CTE to sum up order quantities
with total_order_quantity as (
	select orders.customer_id, sum(orders.quantity) as total_quantity
	from orders
	group by orders.customer_id
)
select customers.first_name, customers.second_name, total_order_quantity
from customers
join total_order_quantity on customers.customer_id=total_order_quantity.customer_id;

--CTE for ranking customers based on total quantity
with customer_ranking as (
	select orders.customer_id, sum(orders.quantity) as total_quantity,
		row_number() over (order by sum(orders.quantity) desc) as rank
	from orders
	group by orders.customer_id
)
select customers.first_name, customers.second_name, customer_ranking.total_quantity, customer_ranking.rank
from customers
join customer_ranking on customers.customer_id=customer_ranking.customer_id
order by customer_ranking;

--CTE to list patients who have more than one doctor
with multiple_doctors as(
	select patient_id)
	from mental_health_visits
	group by patiemt_id
	having count(distinct doctor_id)>1
)
select mental_health_patients.first_name, mental_health_patients.last_name
from mental_health_patients
join multiple_doctors on mental_health_patients.patient_id=multiple_doctors.patient_id;

--STORED PROCEDURES
--are precompiled SQL statements that are stored in the database 
--act as a reusable unit of work that can be invoked multiple times
	--BENEFITS -It improves perfomance as it reduces the amount of sqlcode sent over the network
	--Code reusability
	--Security -limit actions that can be done of sensitive data by restricting access
	--Encapsulation
--SYNTAX
CREATE OR REPLACE PROCEDURE get_employee_details(p_employee_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM 1
	from employees
	where employeee_id=p_employee_id
END;
$$;
select * from get_employee_details (1);

--Get employee details
CREATE OR REPLACE FUNCTION get_employee_details(p_employee_id INT)
RETURNS SETOF employees AS $$
BEGIN
RETURN QUERY
SELECT * FROM employees WHERE employee_id = p_employee_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_employee_details(1);

--Get project details
CREATE OR REPLACE FUNCTION get_project_details(p_project_id INT)
RETURNS SETOF projects AS $$
BEGIN
RETURN QUERY
SELECT * FROM projects WHERE project_id = p_project_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_project_details(3);

--To update employee salary
CREATE OR REPLACE FUNCTION update_employee_salary(p_employee_id INT, p_new_salary numeric(8,2))
RETURNS SETOF employees AS $$
BEGIN
RETURN QUERY
UPDATE employees set salary=p_new_salary WHERE employee_id = p_employee_id returning *;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM update_employee_salary(1, 60000);

PRACTICE QUESTIONS
 
1. Create a stored procedure to get the details of all employees in a specific department.
2. Create a stored procedure to insert a new project.
3. Create a stored procedure to update the name of a department.
4. Create a stored procedure to delete an employee.

