use sakila;
-- Learn what conditional logic is in SQL.
--  include customer.active which uses 1 to indicate active and 0 to indicate inactive:
SELECT
  first_name,
  last_name,
  CASE
    WHEN active = 1 THEN 'ACTIVE'
    ELSE 'INACTIVE'
  END activity_type
FROM
  customer;
-- Learn how the CASE expression works in a searched case scenario.
  -- CASE
  --    WHEN category.name IN ('Children', 'Family', 'Sports', 'Animation')
  --    THEN 'All Ages'
  --    WHEN category.name = 'Horror'
  --    THEN 'Adult'   WHEN category.name IN ('Music', 'Games')
  --    THEN 'Teens'
  --    ELSE 'Other'
  --    END
select
  c.first_name,
  c.last_name,
  CASE
    when active = 0 then 0
    else (
      select
        count(*)
      from
        rental r
      where
        r.customer_id = c.customer_id
    )
  end num_rentals
from
  customer c;
-- case expressions are built into the SQL grammar and can be included in select, insert, update, and delete statements.
  -- used to help with if-then-else logic in a database in the following syntax
  -- CASE
  -- WHEN C1 THEN E1
  -- WHEN C2 THEN E2...
  -- WHEN CN THEN EN
  -- [ELSE ED]
  -- END
  -- Learn how the CASE expression works in a simple case scenario.
  -- CASE category.name
  -- WHEN 'Children' THEN 'All Ages'
  -- WHEN 'Family' THEN 'All Ages'
  --  WHEN 'Sports' THEN 'All Ages'
  --  WHEN 'Animation' THEN 'All Ages'
  --  WHEN 'Horror' THEN 'Adult'
  --  WHEN 'Music' THEN 'Teens'
  --  WHEN 'Games' THEN 'Teens'
  --  ELSE 'Other'
  --  END;
  Learn how the CASE expression can perform existence checking.
  
SELECT
  a.first_name,
  a.last_name,
  CASE
    WHEN EXISTS (
      SELECT
        1
      FROM
        film_actor fa
        INNER JOIN film f ON fa.film_id = f.film_id
      WHERE
        fa.actor_id = a.actor_id
        AND f.rating = 'G'
    ) THEN 'Y'
    ELSE 'N'
  END g_actor,
  CASE
    WHEN EXISTS (
      SELECT
        1
      FROM
        film_actor fa
        INNER JOIN film f ON fa.film_id = f.film_id
      WHERE
        fa.actor_id = a.actor_id
        AND f.rating = 'PG'
    ) THEN 'Y'
    ELSE 'N'
  END pg_actor,
  CASE
    WHEN EXISTS (
      SELECT
        1
      FROM
        film_actor fa
        INNER JOIN film f ON fa.film_id = f.film_id
      WHERE
        fa.actor_id = a.actor_id
        AND f.rating = 'NC-17'
    ) THEN 'Y'
    ELSE 'N'
  END nc17_actor
FROM
  actor a
WHERE
  a.last_name LIKE 'S%'
  OR a.first_name LIKE 'S%';

SELECT
  f.title,
  CASE
  (SELECT
        count(*)
      FROM
        inventory i
      WHERE
        i.film_id = f.film_id)
    WHEN 0 THEN 'Out Of Stock'
    WHEN 1 THEN 'Scarce'
    WHEN 3 THEN 'Available'
    WHEN 4 THEN 'Available'
    ELSE 'Common'
  END film_availability
FROM
  film f;
-- Learn how the CASE expression can perform conditional updates.
UPDATE
  customer
SET
  active = CASE
    WHEN 90 <= (
      SELECT
        datediff(now(), max(rental_date))
      FROM
        rental r
      WHERE
        r.customer_id = customer.customer_id
    ) THEN 0
    ELSE 1 END WHERE active = 1;
-- This statement uses a correlated subquery to determine the days
    -- since the last time a customer was in and compares it to the value of 90.
    -- If the number returned by the subquery is 90 or higher, the customer
    -- is marked as inactive.
    -- Learn how the CASE expression can manage NULL values.
    SELECT
      c.first_name,
      c.last_name,
      CASE
        WHEN a.address IS NULL THEN ' Unknown '
        ELSE a.address
      END address,
      CASE
        WHEN ct.city IS NULL THEN ' Unknown '
        ELSE ct.city
      END city,
      CASE
        WHEN cn.country IS NULL THEN ' Unknown '
        ELSE cn.country
      END country
    FROM
      customer c
      LEFT OUTER JOIN address a ON c.address_id = a.address_id
      LEFT OUTER JOIN city ct ON a.city_id = ct.city_id
      LEFT OUTER JOIN country cn ON ct.country_id = cn.country_id;
      
-- With calculations, case expressions are useful to translate a null value into a
      -- number (usually 0 or 1) so that the calculation will yield a non-null value.
    SELECT
      (7 * 5) / ((3 + 14) * null);
      
-- exercises 
-- Rewrite the following query, which uses a simple CASE expression, so that the 
-- same results are achieved using a searched CASE expression. Try to use as few WHEN clauses as possible.
SELECT name
,      CASE name
WHEN 'English'  THEN 'latin1'
WHEN 'Italian'  THEN 'latin1'
WHEN 'French'   THEN 'latin1'
WHEN 'German'   THEN 'latin1'
WHEN 'Japanese' THEN 'utf8'
WHEN 'Mandarin' THEN 'utf8'
ELSE 'UNKNOWN'
END AS character_set
FROM   language;

SELECT 
    name,
    CASE
        WHEN name IN ('English' , 'Italian', 'French', 'German') THEN 'latin1'
        WHEN name IN ('Japanese' , 'Mandarin') THEN 'utf8'
        ELSE 'Unknown'
    END AS character_set
FROM
    language;


-- exercise 2
-- Rewrite the following query so that the result set contains a single row with five columns (one for each rating). 
-- Name the five columns (G, PG, PG_13, R, and NC_17).

SELECT   rating
,        COUNT(*)
FROM     film
GROUP BY rating;

select 
sum(case when rating = 'G' then 1 end) as G,
sum(case when rating = 'PG' then 1 end) as PG,
sum(case when rating = 'PG-13' then 1 end) as PG_13,
sum(case when rating = 'R' then 1 end) as R,
sum(case when rating = 'NC-17' then 1 end) as NC_17
from film;

-- Question 3  5 pts
-- Write a query that returns the alphabetized first letter of the customer's last name and the count of active 
-- and inactive customers. Limit the results to only those first letters that occur in the last_name colum of the 
-- customer table.
-- Label the columns as follows:
-- starts_with is the first column and the first letter of the customer's last_name.
-- active_count is the second column and the count of active customers (as defined in the textbook examples of Chapter 11).
-- inactive_count is the third column and the count of inactive customers (as defined in the textbook examples of Chapter 11).
select count(last_name) as A from customer where last_name like 'A%';
select last_name starts_with, active active_count, active inactive_count,
sum(case active when last_name like 'A%' and active = 1 then 1 else 0 end) -- as 'A'
from customer ;

 select 
 (select count(last_name) as A from customer where last_name like 'A%') A,
 (select count(last_name) as B from customer where last_name like 'B%') B,
 
 sum(case
 when active = 1 then 'active' else 0
 end) active_count,
 sum(case 
 when active = 0 then 'inactive' else 0
 end) inactive_count
 from customer group by A;
 
-- select last_name starts_with, count(select active when active = 1 from customer) active_count, count(select active when active = 0 from customer) inactive_count,
-- -- case (active when active = 1 then sum(active) else 0 end) 
-- from customer;

-- select -- sum(select last_name 'a' from customer when last_name like 'A%') starts_with
-- case 
-- sum(case where active in active = 1 then 1 else 0 end) as active_count
-- sum(case where active in active = 0 then 1 else 0 end) as inactive_count
-- from customer 
-- group by count(select last_name a from customer when last_name like 'A%') starts_with; 

select 
last_name, 
case 
when active = 1 then 'yes'
when active = 0 then 'no'
else 'unknown'
end as 'Active'
from customer
group by 'Active'; 


create table alphabet as
select 'A'  as letter union 
select 'B' union
select 'C' union
select 'D' union
select 'E' union
select 'F' union
select 'G' union
select 'H' union
select 'I' union
select 'J' union
select 'K' union
select 'L' union
select 'M' union
select 'N' union
select 'O' union
select 'P' union
select 'Q' union
select 'R' union
select 'S' union
select 'T' union
select 'U' union
select 'V' union
select 'W' union
select 'X' union
select 'Y' union
select 'Z';

select * from alphabet;

-- select last_name, count(substring(last_name, 1, 1)) starts_with
-- from customer
-- group by substring(last_name, 1, 1);


-- inner join to lose those with no last name in the list
select a.letter starts_with, 
count(c.customer_id) customer_count,
count(
case when c.active = 1 then c.customer_id
end
) as active_count,
count(
case when c.active != 1 then c.customer_id
end
) as inactive_count
from alphabet a inner join customer c
on a.letter = substring(last_name, 1, 1)
group by a.letter 
order by a.letter asc;


-- Question 4     5 pts
-- Write a query that returns the alphabetized first letter of the customer's last name and the count of active and inactive customers. 
-- Do not limit the results to only those first letters that occur in the last_name colum of the customer table but return results 
-- that include any missing letters from the data set. (HINT: You will need to fabricate a table composed of the 26 letters of the 
-- alphabet and use an outer join to resolve this problem.)
-- Label the columns as follows:
-- starts_with is the first column and the first letter of the customer's last_name.
-- active_count is the second column and the count of active customers (as defined in the textbook examples of Chapter 11).
-- inactive_count is the third column and the count of inactive customers (as defined in the textbook examples of Chapter 11).

-- outer join to include letters with no last name associated
select a.letter starts_with, 
-- count(c.customer_id) customer_count,
count(
case when c.active = 1 then c.customer_id
end
) as active_count,
count(
case when c.active = 0 then c.customer_id
end
) as inactive_count
from alphabet a left join customer c
on a.letter = substring(last_name, 1, 1)
group by a.letter;

-- Write a query that returns the alphabetized first letter of the customer's last name and the count of active and inactive 
-- customers for only those letters where the count of active customers is greater than 30.
-- Label the columns as follows:
-- starts_with is the first column and the first letter of the customer's last_name.
-- active_count is the second column and the count of active customers (as defined in the textbook examples of Chapter 11).
-- inactive_count is the third column and the count of inactive customers (as defined in the textbook examples of Chapter 11).

select a.letter starts_with,
count(
case when c.active = 1 then c.customer_id
end
) as active_count,
count(
case when c.active != 1 then c.customer_id
end
) as inactive_count
from alphabet a left join customer c
on a.letter = substring(last_name, 1, 1)
group by a.letter
having active_count > 30;

-- example from video with percent too
select a.letter starts_with,
count(
case when c.active = 1 then c.customer_id
end
) as active_count,
-- determine percent of active
ifnull((count(case when c.active = 1 then c.customer_id end)/count(c.customer_id))*100, 0.00) as percent_active,
count(
case when c.active != 1 then c.customer_id
end
) as inactive_count,
-- determine percent of inactive
ifnull((count(case when c.active = 0 then c.customer_id end)/count(c.customer_id))*100, 0.00) as percent_inactive
from alphabet a left join customer c
on a.letter = substring(last_name, 1, 1)
group by a.letter;

SELECT a.first_name
 ,      a.last_name
 ,      CASE
         WHEN EXISTS (SELECT 1
               FROM   film_actor fa INNER JOIN film f
   ON     fa.film_id = f.film_id
  WHERE  fa.actor_id = a.actor_id
   AND    f.rating = 'G') THEN 'Y'
  ELSE 'N'
       END AS g_actor
FROM   actor a
WHERE  a.last_name LIKE 'ki%';


-- ********************** book examples for null
SELECT c.first_name, c.last_name,  
   CASE    
      WHEN a.address IS NULL THEN 'Unknown'    
         ELSE a.address  
   END address,  
   CASE    
      WHEN ct.city IS NULL THEN 'Unknown'    
         ELSE ct.city  
   END city,  
   CASE    
      WHEN cn.country IS NULL THEN 'Unknown'    
         ELSE cn.country  
   END country
FROM customer c  
   LEFT OUTER JOIN address a  
      ON c.address_id = a.address_id  
   LEFT OUTER JOIN city ct  
      ON a.city_id = ct.city_id  
   LEFT OUTER JOIN country cn  
      ON ct.country_id = cn.country_id;
