use sakila;

-- joins
 -- simplest and most common inner join (done by default if not specified)
 -- cross join is expensive and rarely used
 -- keyword straight_join will allow the person rather than the server to choose the table order (force the driving table)
 -- the following query uses a generated subquery to join
SELECT c.first_name, c.last_name, addr.address, addr.city 
FROM customer c 
INNER JOIN 
	(SELECT a.address_id, a.address, ct.city FROM address a INNER JOIN city ct ON a.city_id = ct.city_id WHERE a.district = 'California' ) addr 
		ON c.address_id = addr.address_id;
 
 SELECT first_name, last_name, address 
 FROM 
	customer as c 
inner JOIN -- best to specify joins so cross isn't accidently used
	address as a
    on c.address_id = a.address_id; -- could've used USING (address_id) because the column names matched
-- Exercises for Chapter 5
-- Exercise 5-1
SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer c
  INNER JOIN address a
  ON c.address_id = a.address_id
   INNER JOIN city ct
  ON a.city_id = ct.city_id
 WHERE a.district = 'California';

-- Exercise 5-2
-- Write a query that returns the title of every film in which an actor with the first name JOHN appeared.
select title -- , first_name 
from actor a 
inner join film_actor fa
	on a.actor_id = fa.actor_id
    inner join film f
		on fa.film_id = f.film_id
where first_name like 'John';  -- or where first_name = 'John';

-- Exercise 5-3
-- Construct a query that returns all addresses that are in the same city. You will need to join the 
-- address table to itself, and each row should include two different addresses.  

select a1.address firstAddress, a2.address secondAddress, city, a1.city_id
from address a1 inner join address a2 using (city_id)
	inner join city c on c.city_id = a1.city_id 
    where a1.address_id != a2.address_id;
    
 --   Write a query that shows all the films starring Joe Swank that have a length between 90 and 120 minutes. It should display the following data set:
select title, first_name, length
from actor a 
inner join film_actor fa
	on a.actor_id = fa.actor_id
    inner join film f
		on fa.film_id = f.film_id
where first_name = 'Joe' and last_name = 'Swank' 
and length between 90 and 120;

-- Write a query that shows how many rentals are associated with each of the two staff members. It should display the following data set:
select first_name, last_name, count(r.rental_id)
from staff s 
inner join rental r on s.staff_id = r.staff_id
group by s.staff_id 
order by first_name asc;