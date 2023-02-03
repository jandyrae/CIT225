-- Week 13 Views (Chapter 14)
use sakila;

create view customer_vw (customer_id, first_name, last_name, email)
as select customer_id, first_name, last_name, concat(substr(email, 1, 2), '*****', substr(email, -4)) email
from customer;
 
 select * from customer_vw;
 describe customer_vw; --  know what columns are available in a view
 
-- Hiding complexity from end users
 
 create view film_stats as select f.film_id, f.title, f.description, f.rating,
 (select c.name from category c 
 inner join film_category fc
	on c.category_id = fc.category_id
    where fc.film_id = f.film_id) category_name,
    (select count(*) from film_actor fa where fa.film_id = f.film_id) num_actors,
    (select count(*) from inventory i where i.film_id = f.film_id) inventory_cnt,
    (select count(*) from inventory i inner join rental r on i.inventory_id = r.inventory_id where i.film_id = f.film_id) num_rentals
    from film f;
    
    select * from film_stats;
    
CREATE VIEW customer_details 
AS SELECT c.customer_id, c.store_id, c.first_name, c.last_name, c.address_id, c.active, c.create_date, a.address, ct.city, cn.country, a.postal_code 
FROM customer c
	INNER JOIN address a ON c.address_id = a.address_id 
	INNER JOIN city ct ON a.city_id = ct.city_id
	INNER JOIN country cn ON ct.country_id = cn.country_id;
    
select * from customer_details;


-- Exercise 14.1

create view film_ctgry_actor (title, category_name, first_name, last_name)
as select f.title, ct.name, a.first_name, a.last_name 
from film f
	inner join film_category fc on f.film_id = fc.film_id
    inner join category ct on fc.category_id = ct.category_id
    inner join film_actor fa on f.film_id = fa.film_id
    inner join actor a on fa.actor_id = a.actor_id;
    -- to check the view to see if it shows the same
select title, category_name, first_name, last_name from film_ctgry_actor
where last_name = 'Fawcett';

-- Exercise 14-2
-- The film rental company manager would like to have a report that includes the name of every country, 
-- along with the total payments for all customers who live in each country. Generate a view definition 
-- that queries the country table and uses a scalar subquery to calculate a value for a column named 
-- tot_payments.

-- this one names columns and uses inner joins to access the information in the initial select statement
create view customer_country_payments (country_name, tot_payments)
as select c.country, sum(p.amount) 
from customer cust 
inner join address a on cust.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country c on ci.country_id = c.country_id
inner join payment p on cust.customer_id = p.customer_id
group by c.country;

-- and this one uses a select statement for the second column
create view country_payments
as select c.country, (select sum(p.amount)
from city ct
inner join address a on ct.city_id = a.city_id
inner join customer cst on a.address_id = cst.address_id
inner join payment p on cst.customer_id= p.customer_id where ct.country_id = c.country_id) tot_payments
from country c;

-- Write a nonupdateable view that displays the following result set or any subset of columns in a single row where there's a column name for each rating. When you use the following query:
--  G, PG, PG_13, R, and NC_17

select rating, sum(rating) from film
group by rating;

create view rating_distribution 
as select 
sum(if(upper(rating) = 'G', 1, 0)) as 'G',
sum(if(rating = 'PG', 1, 0)) as 'PG',
sum(if(rating = 'PG-13', 1, 0)) as 'PG_13',
sum(if(rating = 'R', 1, 0)) as 'R',
sum(if(rating = 'NC-17', 1, 0)) as 'NC_17'
from film;

SELECT pG FROM   rating_distribution;

-- Write a nonupdateable actor_films_by_year view that displays the following ordered result set from the actor, film_actor, and film tables.
create view actor_films_by_year
as select 
concat(a.last_name,',  ', a.first_name) as full_name,
f.release_year, 
count(a.actor_id) as films_made
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
group by full_name order by a.last_name, a.first_name asc;

-- Write a nonupdateable rental_stats view that returns the rating column and a rent_ratio column calculated by dividing the num_rentals by 
-- inventory_cnt column value found in the film_stats view of Chapter 14 (Learning SQL). The rental_stats view should have the following 
-- structure when you describe it.

create view rental_stats
as select 
rating, (num_rentals/inventory_cnt) as rent_ratio
from film_stats
order by rating;

describe rental_stats;

SELECT   *
FROM     rental_stats
WHERE    rent_ratio > 4
ORDER BY rating;