-- Week 3 Notes (Where) 

use sakila;
-- if where clause has more than 3 conditions, use parens

-- •Learn how to use equality comparison operators. '='
-- uses the = symbol to check if the conditions match the query request
select * from customer 
WHERE (first_name = 'STEVEN' OR last_name = 'YOUNG') AND create_date > '2006-01-01';

-- •Learn how to use non-equality comparison operators. 'not' and '<>' to show what not to include
select * from customer
WHERE (first_name <> 'STEVEN' OR last_name <> 'YOUNG') AND create_date > '2006-01-01';
-- or can be done like this-> WHERE NOT (first_name = 'STEVEN' OR last_name = 'YOUNG')AND create_date > '2006-01-01’;

-- •Learn how to use range comparison operators, this example range is earlier tha May 26, 2005
SELECT customer_id, rental_date FROM rental WHERE rental_date < '2005-05-26';
-- to use a range with an upper and lower limit, use between
SELECT customer_id, rental_date FROM rental WHERE rental_date BETWEEN ‘2005-06-14’ AND ‘2005-06-16’;
-- or to query using multiple values use 'in' keyword and add values to parens (you can also use NOT IN to check for values not in the list)
SELECT title, rating FROM film WHERE rating IN ('G', 'PG');

-- •Learn how to use subqueries in comparison operators, the example below has a select statement inside the in clause 
SELECT title, rating FROM film WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');

-- •Learn how to use wildcards in comparison operators.
-- _	Exactly one character
-- %	Any number of characters (including 0)
 SELECT last_name, first_name FROM customer WHERE last_name LIKE '_A_T%S'; 
-- yields an A in the second position, a T in the fourth position, followed by any number of characters, with an S at the end 

-- •Learn how to use NULL values in comparison operators. ('IS NULL' and 'IS NOT NULL')
-- (NULL is the absence of a value)(Not applicable)(value not yet known) (value undefined)
-- an expression can be NULL but cannot equal Null - therefore null does not equal null. can be used to search 
 SELECT rental_id, customer_id FROM rental WHERE return_date IS NULL;
 
 
 -- ***************************
 use sakila;

select district, count(district) 
from address 
group by district 
having count(district)>5;

select city, district from address a 
join city c on a.city_id = c.city_id
where city like '%ho%' or '%ha%'
having city between 'Br' and 'J';
-- *********** 

12.4.2 Comparison Functions and Operators
Table 12.4 Comparison Operators

-- Name	Description
-- >		Greater than operator
-- >=		Greater than or equal operator
-- <		Less than operator
-- <>, !=	Not equal operator
-- <=		Less than or equal operator
-- <=>		NULL-safe equal to operator
-- =		Equal operator
-- BETWEEN ... AND ...	Whether a value is within a range of values
-- COALESCE()	Return the first non-NULL argument
-- GREATEST()	Return the largest argument
-- IN()			Whether a value is within a set of values
-- INTERVAL()	Return the index of the argument that is less than the first argument
-- IS			Test a value against a boolean
-- IS NOT		Test a value against a boolean
-- IS NOT NULL	NOT NULL value test
-- IS NULL		NULL value test
-- ISNULL()		Test whether the argument is NULL
-- LEAST()		Return the smallest argument
-- LIKE			Simple pattern matching
-- NOT BETWEEN ... AND ...	Whether a value is not within a range of values
-- NOT IN()		Whether a value is not within a set of values
-- NOT LIKE		Negation of simple pattern matching
-- STRCMP()		Compare two strings