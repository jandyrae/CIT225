-- Do you have permission to execute the statement?			
-- Do you have permission to access the desired data?			
-- Is your statement syntax correct?
-- Clause name			Purpose												
-- select				Determines which columns to include in the query’s result set													
-- from					Identifies the tables from which to retrieve data and how the tables should be joined													
-- where				Filters out unwanted data													
-- group by				Used to group rows together by common column values													
-- having				Filters out unwanted groups													
-- order by				Sorts the rows of the final result set by one or more columns
use sakila;
-- Exercise 3-1 Retrieve the actor ID, first name, and last name for all actors. Sort by last name and then by first name.
select actor_id, first_name, last_name 
from actor
-- order by last_name, first_name; or 
order by 3, 2;

-- Exercise 3-2 Retrieve the actor ID, first name, and last name for all actors whose last name equals 'WILLIAMS' or 'DAVIS'.
select actor_id, first_name, last_name
from actor
where last_name = 'Williams' or last_name = 'Davis';

-- Exercise 3-3 Write a query against the rental table that returns the IDs of the customers who rented a film on July 5, 2005 
-- (use the rental.rental_date column, and you can use the date() function to ignore the time component). 
-- Include a single row for each distinct customer ID.
select distinct customer_id 
from rental 
where date(rental_date) = '2005-07-05'; 

-- Exercise 3-4 Fill in the blanks (denoted by <#>) for this multitable query to achieve the following results:
select c.email, r.return_date
from customer c inner join rental r 
on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-06-14'
order by 1 asc; -- quiz and book different

select 222 as room_number, 'Kotter' as teacher;

select database();