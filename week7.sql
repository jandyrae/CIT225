use sakila;
-- query that uses all of the common aggregate functions:
SELECT 
    MAX(amount) max_amt,
    MIN(amount) min_amt,
    AVG(amount) avg_amt,
    SUM(amount) tot_amt,
    COUNT(*) num_payments
FROM
    payment;
-- tell explicitly how data should be grouped (use group by)
SELECT 
    customer_id,
    MAX(amount) max_amt,
    MIN(amount) min_amt,
    AVG(amount) avg_amt,
    SUM(amount) tot_amt,
    COUNT(*) num_payments
FROM
    payment
GROUP BY customer_id;
-- count number of rows, then how many unique customers (don't recount, no duplicates)
SELECT 
    COUNT(customer_id) num_rows,
    COUNT(DISTINCT customer_id) num_customers
FROM
    payment;

CREATE TABLE number_tbl (
    val SMALLINT
);
INSERT INTO number_tbl values (1);
INSERT INTO number_tbl values (3);
INSERT INTO number_tbl values (5);
-- use that table
SELECT 
    COUNT(*) num_rows,
    COUNT(val) num_vals,
    SUM(val) total,
    MAX(val) max_val,
    AVG(val) avg_val
FROM
    number_tbl;
-- doesn;t work... there are null values
INSERT INTO number_tbl VALUES (NULL);
-- still some problems with sum(), max(), and avg()
SELECT 
    COUNT(*) num_rows,
    COUNT(val) num_vals,
    SUM(val) total,
    MAX(val) max_val,
    AVG(val) avg_val
FROM
    number_tbl;
-- ***************************************
-- group by 1 column
SELECT 
    actor_id, COUNT(*)
FROM
    film_actor
GROUP BY actor_id;
 -- multicolumn grouping
SELECT 
    fa.actor_id, f.rating, COUNT(*)
FROM
    film_actor fa
        INNER JOIN
    film f ON fa.film_id = f.film_id
GROUP BY fa.actor_id , f.rating
ORDER BY 1 , 2;
 -- group by expressions
SELECT 
    EXTRACT(YEAR FROM rental_date) year, COUNT(*) how_many
FROM
    rental
GROUP BY EXTRACT(YEAR FROM rental_date);
 -- generating rollups
SELECT 
    fa.actor_id, f.rating, COUNT(*)
FROM
    film_actor fa
        INNER JOIN
    film f ON fa.film_id = f.film_id
GROUP BY fa.actor_id , f.rating WITH ROLLUP
ORDER BY 1 , 2;
  --  query filters twice. Once is in the where clause, which filters out films with a rating other than G or PG.  The second is in the having clause filters out actors appearing in fewer than 10 films
SELECT 
    fa.actor_id, f.rating, COUNT(*)
FROM
    film_actor fa
        INNER JOIN
    film f ON fa.film_id = f.film_id
WHERE
    f.rating IN ('G' , 'PG')
GROUP BY fa.actor_id , f.rating
HAVING COUNT(*) > 9;
-- cannot include an aggregate function in a where clause (where is before grouping) so this one won't work.
 SELECT 
    fa.actor_id, f.rating, COUNT(*)
FROM
    film_actor fa
        INNER JOIN
    film f ON fa.film_id = f.film_id
WHERE
    f.rating IN ('G' , 'PG')
        AND COUNT(*) > 9
GROUP BY fa.actor_id , f.rating;

-- ********************************************
use sakila;
SELECT customer_id,
MAX(amount) max_amt,
min(amount) min_amt,
AVG(amount) avg_amt,
sUM(amount) tot_amt,
COUNT(*) num_payments
FROM payment
GROUP BY customer_id;
-- counts the number of rows and counts number of unique id's
select count(customer_id) num_rows, 
count(distinct customer_id) num_customers
from payment;

--  number of days between the return date and the rental date
SELECT MAX(datediff(return_date,rental_date)) FROM rental;

-- ************************************
-- Exercise 8-1
-- Construct a query that counts the number of rows in the payment table.

select count(payment_id) rowtotal from payment;

-- Exercise 8-2
-- Modify your query from Exercise 8-1 to count the number of payments made by each customer. 
-- Show the customer ID and the total amount paid for each customer.
select customer_id, count(rental_id) rentals, sum(amount) total from payment group by customer_id;

-- Exercise 8-3
-- Modify your query from Exercise 8-2 to include only those customers who have made at least 40 payments.
select customer_id, count(rental_id) rentals, sum(amount) total from payment group by customer_id having count(rental_id) > 39;

SELECT   SUBSTR(last_name,1,1) AS first_letter,
COUNT(last_name)
FROM customer
WHERE substr(last_name,1,1) = 'M'
GROUP BY SUBSTR(last_name,1,1);

 SELECT SUBSTR(last_name,1,2) AS first_letter, last_name, 
 COUNT(*)
FROM customer
WHERE substr(last_name,1,1) IN ('K','M')
GROUP BY SUBSTR(last_name,1,2)
ORDER BY 2;

SELECT EXTRACT(YEAR FROM rental_date) AS year
, COUNT(*) rentals
FROM rental
GROUP BY EXTRACT(YEAR FROM rental_date);