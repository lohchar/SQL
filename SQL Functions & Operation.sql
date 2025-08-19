CREATE SCHEMA learning;
set search_path to learning;

--Creating Tables
create table customers(
customer_id SERIAL primary key,
first_name VARCHAR(50)NOT NULL,
last_name VARCHAR(50)NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phone_number CHAR(13));

--Adding Rows
INSERT INTO customers (first_name, last_name, email, phone_number)
VALUES
('John', 'Doe', 'john.doe@example.com', '+254712345678'),
('Jane', 'Smith', 'jane.smith@example.com', '+254798765432'),
('Paul', 'Otieno', 'paul.otieno@example.com', '+254701234567'),
('Mary', 'Okello', 'mary.okello@example.com', '+254711223344');

select * from customers

CREATE TABLE books (
book_id SERIAL PRIMARY KEY,
tittle VARCHAR(150) NOT NULL,
author VARCHAR(100),
price NUMERIC(8, 2) NOT NULL,
published_date DATE);

INSERT INTO books (tittle, author, price, published_date)
VALUES
('understanding SQL', 'David Kimani', 1500.00, '2023-01-15'),
('Advanced PostgresSQL', 'Grace Achieng', 2500.00, '2023-02-20'),
('Learning Python', 'James Mwangi', 3000.00, '2022-11-10'),
('Data Analytics Basics', 'Susan Njeri', 2200.00, '2023-03-05');

CREATE TABLE orders ( 
order_id SERIAL PRIMARY KEY, 
customer_id INT REFERENCES customers(customer_id), 
book_id INT REFERENCES books(book_id), 
order_date DATE DEFAULT CURRENT_DATE);

INSERT INTO orders (customer_id, book_id, order_date) 
VALUES 
(1, 3, '2023-04-01'), 
(2, 1, '2023-04-02'), 
(3, 2, '2023-04-03'), 
(4, 4, '2023-04-04'), 
(1, 2, '2023-04-05');
select * from orders

--Adding columns
alter table customers
add column city VARCHAR(50);

--Adding Rows
update customers
set city = 'Nairobi'
where customer_id=1;

update customers
set city = case customer_id
when 2 then 'Mombasa'
when 3 then 'Nairobi'
when 4 then 'Nakuru'
end;

--Adding column to table
alter table orders
add column quantity INT;

update orders
set quantity = case order_id
when 1 then 2
when 2 then 1
when 3 then 3
when 4 then 2
when 5 then 1
end;
select * from orders;

--deleting column
alter table customers
drop column city;

--Adding a column
alter table customers
add column city VARCHAR(50);

update customers
set city = case customer_id
when 1 then 'Nairobi'
when 2 then 'Mombasa'
when 3 then 'Nairobi'
when 4 then 'Kisumu'
when 5 then 'Eldoret'
when 6 then 'Kisii'
end;
select * from customers;

--delete row
delete from books
where book_id=5;
select * from books;

set search_path to learning;
insert into customers (first_name, last_name, email, phone_number)
values
('Paul', 'Kimani', 'paul.kimani@example.com', '+254712345679'),
('Joel', 'Munene', 'joel.Munene@example.com', '+254719345608');
select * from customers

--Renaming a column
alter table customers rename column last_name to second_name;

--Changing column data type
alter table customers
alter column first_name type varchar(20);

--setting a default value
alter table orders
alter column quantity set default value 1;

--dropping default value
alter tables
alter column quantity drop default;

--adding not null contraint
alter table orders
alter column quantity set not null;

--dropping the not null contraints
alter table orders
alter column quantity drop not null;

--add a foreign key contraint
alter table orders
add contraints fk_customer
foreign key(customer_id)
references customers(customer_id);

--getting contraints 
select conname
from pg_constraint
where conrelid= 'orders':: regclass;
--drop contraints
alter table orders drop constraints fk_customer;

--KEYWORDS
--select- Retrieve data
select * from orders;
select order_date, quantity from orders;
--WHERE - Filters data
select customer_id, phone_number from customers where first_name = 'Mary'
select tittle from books where price>2000;
select * from orders where quantity > 1;
select * from books where published_date between '2023-01-01' and '2023-12-31';
--ORDER BY -Sort data
select tittle, price from books order by price asc;
select * from books order by tittle asc; --alphabetical order
select * from books order by published_date asc; --2nd book to be published
--LIMIT -restricts number of results
select tittle, price from books order by price desc Limit 1;--most expensive book
select tittle, price from books order by price asc Limit 1;--least expensive book
select * from orders order by order_date asc limit 3;--1st 3 orders
select tittle, price from books order by price desc limit 2;--2 most expensive books
select * from orders order by quantity desc limit 1;--customer with most orders
--GROUP BY -group and summarize data
select author, count(*) from books group by author; --no. of books for each author
select customer_id, count(*) from orders group by customer_id;--no. of orders for each customer
select order_date, count(*) from orders group by order_date;--no. of orders in each date
--HAVING -filter after grouping
select author, count(*) from books group by author having count(*)=1;
select customer_id, count(*) from orders group by customer_id having count(*)>1;--customer with more than one order

--AGGREGATE FUNCTIONS --count()
select count(*) as total_customers from customers;
--customers from nairobi
select count(*) as nairobi_customers from customers where city='Nairobi';
--no. of books written by David Kimani
select count(*) as david_books from books where author='David Kimani';
--no of books published after 2023
select count(*) as after_2023_books from books where published_date>'2023-12-31';

--sum()
--Total price of books
select * from orders;
select * from customers;
select * from books;
select sum(price) as total_books_price from books;
--total no. of orders
select sum(quantity) as total_orders from orders;
--books bought by john
select sum(quantity) as John from orders where customer_id=1;

--Average AVG()
--Average price of books
select AVG(price) as avg_price from books;
--average quantity
select AVG(quantity) as avg_quantity  from orders;
--average price of books published in 2023
select AVG(price) as avg_price from books where published_date between '2023-01-01' and '2023-12-31';

--MAX()
--most expensive book
select max(price) as most_expensive from books;
--latest book published
select max(published_date) as latest_date from books;
--when was last order made
select max(order_date) as latest_order from orders;

--MIN()
--price for cheapest book
select min(price) as cheapest_price from books;
--when was 1st book published
select min(published_date) as first_date from books;

--COMPARISON OPERATORS
--Equal to (=)
select * from customers where city='Nairobi';
--not equal to (<>) (!=)
--customers not from kisumu
select * from customers where city!='Kisumu';
--book not costing 3000
select * from books where price<>3000;

--Greater than(>)
--books cost more that 2500
select * from books where price>2500;
--books published after 1st jan 2023
select * from books where published_date>'2023-01-02';

--greater than or equal to(>=)
--books costing greater than/equal to 2500
select * from books where price>=2500;

--less than (<)
--books priced below 2500
select * from books where price<2500;

--less than or equal to (<=)
--books priced less than/ equal to
select * from books where price <=2500;

--Between(show range)
--books costing btwn 2500 & 3000
select * from books where price between 2500 and 3000;
--books published in 2023
select * from books where published_date between '2023-01-01' and '2023-12-31';

--Like -use for pattern matching
--customers whose first name start with J
select * from customers where first_name like 'J%';
--Books with title having Data
select * from books where tittle like '%Data%';
--emails ending with @gmail.com
select * from customers where email like '%@example.com';

--IN (multiple values)
select * from customers where city in ('Nairobi','Kisumu');
--orders with quantity 1 and 2
select * from orders where quantity in (1, 2);
--books authored by David Kimani and James Mwangi
select * from books where author in ('David Kimani', 'James Mwangi');

--LOGICAL OPERATORS
--AND - both conditions must be true for row to be included
select * from customers where city='Kisumu' and first_name ='Mary';
select * from books where author='Susan Njeri' and published_date>'2022-12-31';
select * from books where price>2000 and author='James Mwangi';
select * from books where price<3000 and published_date<'2023-03-01';
--OR -combine 2/more conditions & only one has to be true
select * from customers where city ='Nairobi' or city ='Mombasa';
	--books priced over 2500 or authored by 'Grace Achieng
select * from books where price >2500 or author = 'Grace Achieng';
	--orders with quantity=1 or order date ='2023-04-02'
select * from orders where quantity = 1 or order_date='2023-04-02';
--NOT reverses result of a condition
--books not authored by Grace Achieng
select * from books where not author = 'Grace Achieng';
--books not priced at 1500
select * from books where not price=1500;
--books not published in 2023
select * from books where not published_date>'2022-12-31'; 

--Arithmetic operators
--Addition
select 50 + 100 as total;--adding directly in query
--Increase book price by 200
select tittle, price, price + 200 as new_price from books;
--increasing quantity by 1
select quantity, quantity+1 as new_quantity from orders;

--Substraction
select * from orders;
--reduce price by 100
select tittle, price, price - 100 as new_reduced_price from books;
--Multiplacation
--double the book price  
select tittle, price, price *2 as doubled_price from books;
--Division
--divide book price by 2
select tittle, price, price /2 as divided_price from books;
--Modulus(%) Remainder
select order_id,book_id, book_id %3 as remainder from orders;
select tittle,price,price%2 as remainder from books;

--SET OPERATORS
--UNION -combine 2 sets and remove duplicates
--list all unique first_name and author
select first_name as name from customers
union
select author as name from books;
--all unique customer_ids and order_ids
select customer_id as ID from customers
union
select order_id as ID from orders;

--UNION ALL -combine 2 result sets and keeps duplicates
--list all first_name and authors
select first_name as name from customers
union all
select author as name from books;
--list all order dates and published dates showing duplicates
select order_date as dates from orders
union all
select published_date as dates from books;

--INTERSECT -returns common records from both queries
select customer_id as ID from customers
intersect
select customer_id as ID from orders;

--EXCEPT -return records from 1st query that are not in 2nd query
select first_name as name from customers
except 
select author as name from books;

--IS NULL -find empty values 
select * from customers where city is null;
--IS NOT NULL -find columns with values
select * from customers where city is not null;
--Distinct -show unique entries..remove duplicates
select distinct city from customers;




