use sakila;
-- MySQL subquery is a query nested within another query such as SELECT, INSERT, UPDATE or DELETE. In addition, a subquery can be nested inside another subquery.
-- A subquery can be used anywhere that expression is used and must be closed in parentheses.
-- the subquery runs first and the outer query runs on the result set from the inner or subquery.
SELECT 
    customer_id, payment_date, amount
FROM
    payment
WHERE
    amount = (SELECT 
            MAX(amount)
        FROM
            payment);
    
SELECT 
    customer_id, payment_date, amount
FROM
    payment
WHERE
    amount > (SELECT 
            AVG(amount)
        FROM
            payment);
    
  -- you can use a subquery with NOT IN operator to find the customers who have not placed any orders  
SELECT 
    customer_id, last_name
FROM
    customer
WHERE
    customer_id NOT IN (SELECT DISTINCT
            customer_id
        FROM
            rental);
            
-- a correlated subquery (see below) depends on the outer query, but a standalone subquery could run independantly of the outer query

SELECT 
    productname, buyprice
FROM
    products p1
WHERE
    buyprice > (SELECT 
            AVG(buyprice)
        FROM
            products
        WHERE
            productline = p1.productline);
           
-- When a subquery is used with the EXISTS or NOT EXISTS operator, a subquery returns a Boolean value of TRUE or FALSE
--  finds sales orders whose total values are greater than 60K
SELECT 
    orderNumber, SUM(priceEach * quantityOrdered) total
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
GROUP BY orderNumber
HAVING SUM(priceEach * quantityOrdered) > 60000;
-- this one uses exists to find customers who placed 1 + order with total greater than 60k
-- exists are used when quantity doesn't matter, but that the met condidions exist
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    EXISTS( SELECT 
            1
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id
                AND DATE(r.rental_date) < '2005-05-25');
SELECT 
    customerNumber, customerName
FROM
    customers
WHERE
    EXISTS( SELECT 
            orderNumber, SUM(priceEach * quantityOrdered)
        FROM
            orderdetails
                INNER JOIN
            orders USING (orderNumber)
        WHERE
            customerNumber = customers.customerNumber
        GROUP BY orderNumber
        HAVING SUM(priceEach * quantityOrdered) > 60000);
     
 
-- standalone query to use north american lists
SELECT 
    country_id
FROM
    country
WHERE
    country IN ('Canada' , 'Mexico');
        -- now running a query on that selection result using IN, could also use NOT IN
SELECT 
    city_id, city
FROM
    city
WHERE
    country_id IN (SELECT 
            country_id
        FROM
            country
        WHERE
            country IN ('Canada' , 'Mexico'));

-- the ALL operator comparing values of a set
SELECT 
    first_name, last_name
FROM
    customer
WHERE
    customer_id <> ALL (SELECT 
            customer_id
        FROM
            payment
        WHERE
            amount = 0);
 -- the ANY operator
SELECT 
    customer_id, SUM(amount)
FROM
    payment
GROUP BY customer_id
HAVING SUM(amount) > ANY (SELECT 
        SUM(p.amount)
    FROM
        payment p
            INNER JOIN
        customer c ON p.customer_id = c.customer_id
            INNER JOIN
        address a ON c.address_id = a.address_id
            INNER JOIN
        city ct ON a.city_id = ct.city_id
            INNER JOIN
        country co ON ct.country_id = co.country_id
    WHERE
        co.country IN ('Bolivia' , 'Paraguay', 'Chile')
    GROUP BY co.country);
            
-- multiple single-column subqueries
SELECT 
    fa.actor_id, fa.film_id
FROM
    film_actor fa
WHERE
    fa.actor_id IN (SELECT 
            actor_id
        FROM
            actor
        WHERE
            last_name = 'MONROE')
        AND fa.film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            rating = 'PG');

-- using correlated subqueries( relying on the outside query) to run the inside one
SELECT 
    c.first_name, c.last_name
FROM
    customer
WHERE
    20 = (SELECT 
            COUNT(*)
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id);
 
 -- exists are used when quantity doesn't matter, but that the met condidions exist
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    EXISTS( SELECT 
            1
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id
                AND DATE(r.rental_date) < '2005-05-25');

-- using not before exists to get the opposite values of the selection
SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    NOT EXISTS( SELECT 
            1
        FROM
            film_actor fa
                INNER JOIN
            film f ON f.film_id = fa.film_id
        WHERE
            fa.actor_id = a.actor_id
                AND f.rating = 'R');
 -- correlated subqueries can be used for data manipulation too, example below of an update
UPDATE customer c 
SET 
    c.last_update = (SELECT 
            MAX(r.rental_date)
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id)
WHERE
    EXISTS( SELECT 
            1
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id);

-- no rentals in the last year (deletion that meets the selection)
DELETE FROM customer 
WHERE
    365 < ALL (SELECT 
        DATEDIFF(NOW(), r.rental_date) days_since_last_rental
    FROM
        rental r
    
    WHERE
        r.customer_id = customer.customer_id);

-- the table used in the FROM clause can be a subquery
SELECT 
    c.first_name,
    c.last_name,
    pymnt.num_rentals,
    pymnt.tot_payments
FROM
    customer c
        INNER JOIN
    (SELECT 
        customer_id, COUNT(*) num_rentals, SUM(amounts) tot_payments
    FROM
        payment
    GROUP BY customer_id) pymnt ON c.customer_id = pymnt.customer_id;
-- ***Remember*** Subqueries used in the from clause must be noncorrelated because they are executed first. 

SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit 
UNION ALL SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit 
UNION ALL SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;
 
 -- then generate a customer count in each new category
SELECT 
    pymnt_grps.name, COUNT(*) num_customers
FROM
    (SELECT 
        customer_id, COUNT(*) num_rentals, SUM(amount) tot_payments
    FROM
        payment
    GROUP BY customer_id) pymnt
        INNER JOIN
    (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit 
    UNION ALL SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit 
    UNION ALL SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit) pymnt_grps ON pymnt.tot_payments BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
GROUP BY pymnt_grps.name;
  
SELECT 
    c.first_name,
    c.last_name,
    ct.city,
    SUM(p.amount) tot_payments,
    COUNT(*) tot_rentals
FROM
    payment p
        INNER JOIN
    customer c ON p.customer_id = c.customer_id
        INNER JOIN
    address a ON c.address_id = a.address_id
        INNER JOIN
    city ct ON a.city_id = ct.city_id
GROUP BY c.first_name , c.last_name , ct.city;
-- show errors;  

 -- CTE Code -> Common table expressions, named subquery that uses the WITH to start and commas to separate, see below
 WITH actors_s AS 
 (SELECT actor_id, first_name, last_name
 FROM actor WHERE last_name LIKE 'S%'
 ),
 actors_s_pg AS 
 (SELECT s.actor_id, s.first_name, s.last_name,f.film_id, f.title 
 FROM actors_s s 
 INNER JOIN film_actor fa ON s.actor_id = fa.actor_id 
 INNER JOIN film f ON f.film_id = fa.film_id WHERE f.rating = 'PG'
 ),
 actors_s_pg_revenue AS 
 (SELECT spg.first_name, spg.last_name, p.amount FROM actors_s_pg spg 
 INNER JOIN inventory i ON i.film_id = spg.film_id 
 INNER JOIN rental r ON i.inventory_id = r.inventory_id 
 INNER JOIN payment p ON r.rental_id = p.rental_id) 
 -- end of With clause
 SELECT spg_rev.first_name, spg_rev.last_name, sum(spg_rev.amount) tot_revenue
 FROM actors_s_pg_revenue spg_rev 
 GROUP BY spg_rev.first_name, spg_rev.last_name 
 ORDER BY 3 desc;
 
 
-- this one is different from the above one in a couple of ways first, Instead of joining the customer, address, 
-- and city tables to the payment data, this form uses correlated scalar subqueries in the select clause to look up the customer's data
-- The customer table is accessed three times because this type of return can only return a single column and row, 
-- so it needs to be done three times to get all of the information

SELECT 
    (SELECT 
            c.first_name
        FROM
            customer c
        WHERE
            c.customer_id = p.customer_id) first_name,
    (SELECT 
            c.last_name
        FROM
            customer c
        WHERE
            c.customer_id = p.customer_id) last_name,
    (SELECT 
            ct.city
        FROM
            customer c
                INNER JOIN
            address a ON c.address_id = a.address_id
                INNER JOIN
            city ct ON a.city_id = ct.city_id
        WHERE
            c.customer_id = p.customer_id) city,
    SUM(p.amount) tot_payments,
    COUNT(*) tot_rentals
FROM
    payment p
GROUP BY p.customer_id;

-- Scalar subqueries can also appear in the order by clause
 SELECT a.actor_id, a.first_name, a.last_name 
 FROM actor a 
 ORDER BY 
 (SELECT count(*) FROM film_actor fa WHERE fa.actor_id = a.actor_id) DESC;
 
 -- can also use non-correlated scalar subqueries to create values in insert statements
 INSERT INTO film_actor (actor_id, film_id, last_update)
 VALUES 
 ((SELECT actor_id FROM actor  WHERE first_name = 'JENNIFER' AND last_name = 'DAVIS'),
 (SELECT film_id FROM film  WHERE title = 'ACE GOLDFINGER'),now());
 
--  Subqueries can: 
--  •Return a single column and row, a column with multiple rows, and multiple columns and rows
--  •Are independent of the containing statement (are noncorrelated)
--  •Reference one or more columns from the containing statement (can be correlated)
--  •Are used in comparisons as well as special-purpose operators, such as in, not in, exists, and not exists
--  •Can be used to select, update, delete, and insert•Generate results that can be joined to tables or other subqueries
--  •Can generate values to populate a table or columns•Are used in the select, from, where, having, and order by clauses

-- ******************** Exercises
-- Exercise 9-1
-- Construct a query against the film table that uses a filter condition with a noncorrelated 
-- subquery against the category table to find all action films (category.name = 'Action').

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT DISTINCT
            fc.film_id
        FROM
            film_category fc
                INNER JOIN
            category c ON fc.category_id = c.category_id
        WHERE
            c.name LIKE 'Action');

-- inner
SELECT 
            fc.film_id
        FROM
            film_category fc
                INNER JOIN
            category c ON fc.category_id = c.category_id
        WHERE
            c.name LIKE 'action';
            
            
select name from category where name in ('action');

SELECT first_name
, last_name
FROM customer
WHERE customer_id = ALL
  (SELECT customer_id
FROM   payment
WHERE  amount = 0);

 (SELECT customer_id
FROM   payment
WHERE  amount = 0);

-- Exercise 9-2
-- Rework the query from Exercise 9-1 using a correlated subquery against the category and 
-- film_category tables to achieve the same results.

-- subquery returns category action
SELECT 
    name
FROM
    category c
WHERE
    name LIKE 'action';
-- subquery linking tables
SELECT 
    f.film_id, title
FROM
    film f
        INNER JOIN
    film_category fc ON f.film_id = fc.film_id
        INNER JOIN
    category c ON c.category_id = fc.category_id
WHERE
    fc.name = (SELECT 
            name
        FROM
            category
        WHERE
            name LIKE 'action');

SELECT 
    f.title
FROM
    film f
WHERE
    f.film_id not IN (SELECT 
            fc.film_id
        FROM
            film_category fc
                INNER JOIN
            category c ON fc.category_id = c.category_id
        WHERE
            c.category_id > 1 and f.film_id = fc.film_id);

-- outer query
select title from (
	select f.film_id, title from film f 
	inner join film_category fc
		on f.film_id = fc.film_id 
	inner join category c 
		on c.category_id = fc.category_id ) catFilm -- end of table
where category_id = 1 ;


-- SELECT 
--             fc.film_id
--         FROM
--             film_category fc
--                 INNER JOIN
--             category c ON fc.category_id = c.category_id
--         WHERE
--             c.category_id > 1
-- Exercise 9-3
-- Join the following query to a subquery against the film_actor table to show the level of each actor:
select act.actor_id, actor_level.level
from 
	(select actor_id, count(*) role_count from film_actor group by actor_id) act 
inner join 
	(SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
UNION ALL 
	SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL 
	SELECT 'Newcomer' level, 1 min_roles, 19 max_roles)  actor_level
on act.role_count between actor_level.min_roles and actor_level.max_roles;

(select count(film_id), actor_id from film_actor group by actor_id);


SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit 
UNION ALL SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit 
UNION ALL SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;
 
 -- then generate a customer count in each new category
SELECT 
    pymnt_grps.name, COUNT(*) num_customers
FROM
    (SELECT 
        customer_id, COUNT(*) num_rentals, SUM(amount) tot_payments
    FROM
        payment
    GROUP BY customer_id) pymnt
        INNER JOIN
    (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit 
    UNION ALL SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit 
    UNION ALL SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit) pymnt_grps 
    ON pymnt.tot_payments BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
GROUP BY pymnt_grps.name;

-- Exercise 4
-- Rewrite the following query with two subqueries into multicolumn subquery. The subquery should use a filtered cross join between the film and actor tables.
SELECT actor_id, film_id
FROM film_actor 
WHERE (actor_id, film_id) in (select a.actor_id, f.film_id 
from actor a
cross join film f 
where a.last_name = 'MONROE'
AND f.rating like 'PG');
       

SELECT *
FROM actor
JOIN film_actor USING (actor_id)
JOIN film USING (film_id);

SELECT
fa.actor_id
, fa.film_id
FROM film_actor fa
WHERE (fa.actor_id, fa.film_id) IN (
    SELECT
        a.actor_id
      , f.film_id
      FROM actor a
      CROSS JOIN film f
      WHERE a.last_name = 'Monroe'
      AND f.rating = 'PG'
);

 

-- exercise 5 
-- Rewrite the following query with two subqueries into one with two correlated subqueries. Both of the subqueries should return null values.

SELECT   fa.actor_id
,        fa.film_id
FROM     film_actor fa
WHERE    fa.actor_id IN
           (SELECT actor_id FROM actor WHERE last_name = 'MONROE')
AND      fa.film_id IN
           (SELECT film_id FROM film WHERE rating = 'PG');
           
select fa.actor_id, fa.film_id
from film_actor fa
where exists
(SELECT last_name, rating from actor a
inner join film f 
where fa.actor_id = a.actor_id and f.film_id = fa.film_id 
having last_name like 'Monroe' and rating like 'PG');
SELECT
fa.actor_id
, fa.film_id
FROM film_actor fa
WHERE fa.actor_id IN (
    SELECT
      a.actor_id
    FROM actor a
    WHERE a.actor_id = fa.actor_id
    AND a.last_name = 'Monroe'
)
AND fa.film_id IN (
    SELECT
      f.film_id
    FROM film f
    WHERE f.film_id = fa.film_id
    AND f.rating = 'PG'
);








-- quiz
-- You can use subqueries in all four SQL data statements.
 --  True 
 
-- The following subquery qualifies as a working multiple-row subquery based on what it returns and the comparison operator used by the containing query. TRUE
SELECT first_name
,      last_name
FROM   customer
WHERE  customer_id <> ALL
(SELECT customer_id
FROM   payment
WHERE  amount = 0);

-- The following subquery acts as a scalar query (a query that returns one column and row) and returns an integer. FALSE marked wrong
SELECT customer_id
,      first_name
,      last_name
FROM   customer
WHERE  customer_id = (SELECT MAX(customer_id)
 FROM   customer);
 
 -- The following multicolumn subquery and operator lets you find rows in the film_actor table that no longer support valid relationships between the actor and film tables. FALSE
 SELECT fa.actor_id
,      fa.film_id
FROM   film_actor fa
WHERE  EXISTS
(SELECT NULL
FROM   actor a CROSS JOIN film f
WHERE  a.actor_id = fa.actor_id
AND    f.film_id = fa.film_id);

-- The following subquery qualifies as a working multiple-row subquery based on what it returns and the comparison operator used by the containing query. FALSE
SELECT city_id
,      city
FROM   city
WHERE  country_id IN
(SELECT country_id
FROM   country
WHERE  country = ('Canada','Mexico')); -- should be IN not =

-- The following multicolumn subquery and operator lets you find rows in the film_actor table that no longer support valid relationships between the actor and film tables. FALSE
SELECT actor_id
,      film_id
FROM   film_actor
WHERE  (actor_id, film_id) IN
(SELECT a.actor_id
,      f.film_id
FROM   actor a INNER JOIN film_actor fa
ON     a.actor_id = fa.actor_id INNER JOIN film f
ON     fa.film_id = f.film_id
WHERE  a.last_name = 'MONROE'
AND    f.rating = 'PG');

-- Which of the following comparison operators work with a noncorrelated scalar subquery according to the textbook?
--   >= 
--   <= 
--   = 
--   != NOT SUPPORTED
--   <> 

-- You may choose to include or exclude a table alias when you use a subquery as a data source in the FROM clause. FALSE

-- The following shows how to fabricate a data set. TRUE
 SELECT *
FROM   (SELECT 'Y' AS flag
UNION ALL
SELECT 'N' AS flag) decision;

-- Subqueries can be used as expression generators in SQL. TRUE