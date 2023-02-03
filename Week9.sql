use sakila;
-- •Outer Joins
SELECT f.film_id, f.title,
count(*) num_copies
FROM film f 
INNER JOIN inventory i
ON f.film_id = i.film_id
GROUP BY f.film_id, f.title; -- leaves out ones with no inventory
-- The join definition was changed from inner to left outer, which instructs the server to include 
-- all rows from the table on the left side of the join (film, in this case) and then includes 
-- columns from the table on the right side of the join (inventory) if the join in successful.
SELECT f.film_id, f.title,
count(i.inventory_id) num_copies
FROM film f 
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id
GROUP BY f.film_id, f.title; -- includes inventory that has a count of 0
-- The num_copies column definition was changed from count(*) to count(I.inventory_id), which will 
-- count the number of non-null values of the inventory.inventory_id column.
SELECT f.film_id, f.title,
i.inventory_id
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 and 15; -- this shows the individual rows (each copy in the inventory) 0's don't show

SELECT f.film_id, f.title,
i.inventory_id
FROM film f
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 and 15; -- gives a null value if there isn't a value in inventory ('14', 'ALICE FANTASIA', NULL)

-- •Left vs. Right Outer Joins
--  •Left vs. right tells the server which table is allowedto have gaps.
--  •Right outer joins are very rare, and are not alwayssupported.  It is recommended to ONLY use left joins.
-- Previous examples of outer join have all been left, meaning that the table on the left is responsible for 
-- determining the number of rows, while the right table provides values whenever a match is found.  
-- It is also possible to use a right outer join that will use the right table to count rows. 

SELECT f.film_id, f.title,
i.inventory_id
FROM inventory i
RIGHT OUTER JOIN film f -- switched the tables to change left to right and return the same result
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 AND 15;

-- •Three-way Outer Joins
SELECT f.film_id, f.title,
i.inventory_id, r.rental_date
FROM film f
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id 
LEFT OUTER JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE f.film_id BETWEEN 13 AND 15;
-- includes the rental table with rental dates associated with the previous movies (returns 32 rows)
-- •Cross Joins
SELECT c.name category_name,
l.name language_name
FROM category c 
CROSS JOIN language l;
-- This creates a Cartesian product ofcategory and language tables. NOT widely used

SELECT ones.num + tens.num + hundreds.num as dayNum
FROM 
(SELECT 0 num UNION ALL
SELECT 1 num UNION ALL
SELECT 2 num UNION ALL
SELECT 3 num UNION ALL
SELECT 4 num UNION ALL
SELECT 5 num UNION ALL 
SELECT 6 num UNION ALL
SELECT 7 num UNION ALL
SELECT 8 num UNION ALL
SELECT 9 num) ones
cross join
(SELECT 0 num UNION ALL
SELECT 10 num UNION ALL
SELECT 20 num UNION ALL
SELECT 30 num UNION ALL
SELECT 40 num UNION ALL
SELECT 50 num UNION ALL 
SELECT 60 num UNION ALL
SELECT 70 num UNION ALL
SELECT 80 num UNION ALL
SELECT 90 num) tens
cross join
(SELECT 0 num UNION ALL
SELECT 100 num UNION ALL
SELECT 200 num UNION ALL
SELECT 300 num) hundreds
order by dayNum;

SELECT date_add('2020-01-01', interval(ones.num + tens.num + hundreds.num) day) dt, ones.num + tens.num + hundreds.num as dayNum
FROM 
(SELECT 0 num UNION ALL
SELECT 1 num UNION ALL
SELECT 2 num UNION ALL
SELECT 3 num UNION ALL
SELECT 4 num UNION ALL
SELECT 5 num UNION ALL 
SELECT 6 num UNION ALL
SELECT 7 num UNION ALL
SELECT 8 num UNION ALL
SELECT 9 num) ones
cross join
(SELECT 0 num UNION ALL
SELECT 10 num UNION ALL
SELECT 20 num UNION ALL
SELECT 30 num UNION ALL
SELECT 40 num UNION ALL
SELECT 50 num UNION ALL 
SELECT 60 num UNION ALL
SELECT 70 num UNION ALL
SELECT 80 num UNION ALL
SELECT 90 num) tens
cross join
(SELECT 0 num UNION ALL
SELECT 100 num UNION ALL
SELECT 200 num UNION ALL
SELECT 300 num) hundreds
WHERE DATE_ADD('2020-01-01',
INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2021-01-01'
ORDER BY 1;


-- •Natural Joins

SELECT c.first_name, c.last_name, date(r.rental_date)
FROM customer c
NATURAL JOIN rental r; -- empty because it is also using the last_update condition
-- so it would have to look like this, not so natural 
SELECT cust.first_name, cust.last_name, date(r.rental_date)
FROM
(SELECT customer_id, first_name, last_name
FROM customer
) cust
NATURAL JOIN rental r;

-- Exercise 10-1
-- Using the following table definitions and data, write a query that returns each customer name along with their total payments:			
-- Include all customers, even if no payment records exist for that customer.
select concat(c.first_name, ' ', c.last_name) Name, sum(p.amount)
from customer c
left outer join
payment p 
on c.customer_id = p.customer_id
where c.customer_id between 1 and 3
group by c.customer_id;


-- Exercise 10-2
-- Reformulate your query from Exercise 10-1 to use the other outer join type (e.g., if you used a left outer join in 
-- Exercise 10-1, use a right outer join this time) such that the results are identical to Exercise 10-1.
select concat(c.first_name, ' ', c.last_name) Name, sum(p.amount)
from payment p
right outer join
customer c
on  p.customer_id = c.customer_id 
where c.customer_id between 1 and 3
group by c.customer_id;

-- Exercise 10-3 (Extra Credit)
-- Devise a query that will generate the set {1, 2, 3, ..., 99, 100}. (Hint: use a cross join with at least two from clause subqueries.)

SELECT ones.num + tens.num + hundreds.num as dayNum
FROM 
(SELECT 0 num UNION ALL
SELECT 1 num UNION ALL
SELECT 2 num UNION ALL
SELECT 3 num UNION ALL
SELECT 4 num UNION ALL
SELECT 5 num UNION ALL 
SELECT 6 num UNION ALL
SELECT 7 num UNION ALL
SELECT 8 num UNION ALL
SELECT 9 num) ones
cross join
(SELECT 0 num UNION ALL
SELECT 10 num UNION ALL
SELECT 20 num UNION ALL
SELECT 30 num UNION ALL
SELECT 40 num UNION ALL
SELECT 50 num UNION ALL 
SELECT 60 num UNION ALL
SELECT 70 num UNION ALL
SELECT 80 num UNION ALL
SELECT 90 num) tens
cross join
(SELECT 0 num UNION ALL
SELECT 100 num) hundreds
order by dayNum 
limit 101;

-- Exercise 4 (quiz) Using the following query as your starting point. Rewrite the query to use a RIGHT JOIN and return the same result set.
-- SELECT   f.film_id, f.title, i.inventory_id
-- FROM     film f LEFT JOIN inventory i
-- ON       f.film_id = i.film_id
-- WHERE    f.title REGEXP '^RA(I|N).*$'
-- ORDER BY f.film_id, f.title, i.inventory_id;

SELECT   f.film_id, f.title, i.inventory_id
FROM     inventory i RIGHT JOIN film f 
ON       i.film_id = f.film_id
WHERE    f.title REGEXP '^RA(I|N).*$'
ORDER BY f.film_id, f.title, i.inventory_id;

-- Exercise 5 (quiz) Using the following query as your starting point. Rewrite the query to use a RIGHT JOIN and return the same result set 
-- minus the result set of an INNER JOIN without using set operators or subqueries.
-- SELECT   f.film_id, f.title, i.inventory_id
-- FROM     film f LEFT JOIN inventory i
-- ON       f.film_id = i.film_id
-- WHERE    f.title REGEXP '^RA(I|N).*$'
-- ORDER BY f.film_id, f.title, i.inventory_id;
-- select * from film where film_id = 712;
-- select * from inventory where film_id = 713;
SELECT   f.film_id, f.title, i.inventory_id
FROM     inventory i RIGHT JOIN film f 
ON       i.film_id = f.film_id
WHERE    f.title REGEXP '^RA(I|N).*$' AND  i.inventory_id is null
ORDER BY f.film_id, f.title, i.inventory_id;

# inventory_id, film_id, store_id, last_update


-- quiz 9
-- How many columns are returned by the following query? 3
SELECT  *
FROM   (SELECT 'Yes'       AS reply
        ,      'Decided'   AS answer
        UNION ALL
        SELECT 'No'        AS reply
        ,      'Decided'   AS answer
        UNION ALL
        SELECT 'Maybe'     AS reply
        ,      'Undecided' AS answer) a
        LEFT JOIN
       (SELECT 'Yes' AS reply
        UNION ALL
        SELECT 'No'  AS reply) b
ON      a.reply = b.reply;


-- How many columns are returned by the following query? 1
SELECT  *
FROM   (SELECT 'Yes'   AS reply
        UNION ALL
        SELECT 'No'    AS reply
        UNION ALL
        SELECT 'Maybe' AS reply) r;
        
  -- The following query uses a LEFT JOIN of the inventory and film tables returns everything 
--   in the inventory table on the left of the join operation. The WHERE clause checks for film_id 
--   columns in the inventory table that are null values, which means only the rows outside of the 
--   intersection are returned.   --    FALSE (marked Wrong)
        SELECT f.film_id left_id
,      i.film_id right_id
,      f.title
FROM   film f RIGHT OUTER JOIN inventory i
ON     f.film_id = i.film_id
WHERE  i.film_id IS NULL
ORDER BY 1;
-- *****************************
        SELECT f.film_id left_id
,      i.film_id right_id
,      f.title
FROM   inventory i left OUTER JOIN film f
ON     i.film_id = f.film_id
WHERE  i.film_id IS NULL
ORDER BY 1;

-- How many columns are returned by the following query? 2
SELECT  *
FROM   (SELECT 'Yes'   AS reply
        UNION ALL
        SELECT 'No'    AS reply) decided CROSS JOIN
       (SELECT 'Maybe' AS reply) undecided;
       
       
--   How many rows are returned by the following query?     2 (Marked wrong)
       SELECT  *
FROM   (SELECT 'Yes'       AS reply
        ,      'Decided'   AS answer
        UNION ALL
        SELECT 'No'        AS reply
        ,      'Decided'   AS answer
        UNION ALL
        SELECT 'Maybe'     AS reply
        ,      'Undecided' AS answer) a
        LEFT JOIN
       (SELECT 'Yes' AS reply
        UNION ALL
        SELECT 'No'  AS reply) b
ON      a.reply = b.reply
WHERE   b.reply IS NOT NULL;

-- A NATURAL JOIN lets you name the tables to be joined without specifying the join condition.
-- True

-- A NATURAL JOIN relies on identical column names across multiple tables to infer the proper join conditions.
-- True

-- A COUNT(*) function in the SELECT-list of a LEFT JOIN returns 1 for any row not found in the intersection of the LEFT JOIN results.
-- False

-- A CROSS JOIN yields a Cartesian result set.
-- True

SELECT   f.film_id left_id
,        i.film_id right_id
,        f.title
FROM    (SELECT film_id
         ,      title
         FROM     film) f NATURAL JOIN inventory i
ORDER BY 1 ;

SELECT f.film_id left_id
,      i.film_id right_id
,      f.title
FROM   film f LEFT OUTER JOIN inventory i
ON     f.film_id = i.film_id
WHERE  i.film_id IS NULL
ORDER BY 1;

SELECT  *
FROM   (SELECT 'Yes'       AS reply
        ,      'Decided'   AS answer
        UNION ALL
        SELECT 'No'        AS reply
        ,      'Decided'   AS answer
        UNION ALL
        SELECT 'Maybe'     AS reply
        ,      'Undecided' AS answer) a
        LEFT JOIN
       (SELECT 'Yes'       AS reply
        UNION ALL
        SELECT 'No'        AS reply) b
ON      a.reply = b.reply;

SELECT  *
FROM   (SELECT 'Yes'   AS reply
        UNION ALL
        SELECT 'No'    AS reply
        UNION ALL
        SELECT 'Maybe' AS reply) r;