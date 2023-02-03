use sakila;
-- Exercise 4-1
-- Which of the payment IDs would be returned by the following filter conditions?customer_id <> 5 AND (amount > 8 OR date(payment_date) = '2005-08-23')
select payment_id, payment_date from payment where customer_id <> 5 and (amount > 8 or date(payment_date) = '2005-08-23');
-- returns all payment id's that does not belong to customer_id #5 and where the amount is greater than 8 or the date is August 23rd 2005 (1000 rows)

-- Exercise 4-2
-- Which of the payment IDs would be returned by the following filter conditions?customer_id = 5 AND NOT (amount > 6 OR date(payment_date) = '2005-06-19')
select payment_id, payment_date from payment where customer_id = 5 and not (amount>6 or date(payment_date)='2005-06-19');
-- returns all payment id's that are from customer 5, excluding amounts greater than 6 or date equal to June 19th 2005 (32 rows)

-- Exercise 4-3
-- Construct a query that retrieves all rows from the payments table where the amount is either 1.98, 7.98, or 9.98.
select amount from payment where amount in ('1.98', '7.98', '9.98');
-- 1482	53	2	11657	7.98	2006-02-14 15:16:03	2006-02-15 22:12:42
-- 1670	60	2	12489	9.98	2006-02-14 15:16:03	2006-02-15 22:12:45
-- 2901	107	1	13079	1.98	2006-02-14 15:16:03	2006-02-15 22:13:03
-- 4234	155	2	11496	7.98	2006-02-14 15:16:03	2006-02-15 22:13:33
-- 4449	163	2	11754	7.98	2006-02-14 15:16:03	2006-02-15 22:13:38
-- 7243	267	2	12066	7.98	2006-02-14 15:16:03	2006-02-15 22:15:06
-- 9585	354	1	12759	7.98	2006-02-14 15:16:03	2006-02-15 22:16:47
						
-- Exercise 4-4
-- Construct a query that finds all customers whose last name contains an A in the second position and a W anywhere after the A.
select last_name, first_name from customer where last_name like '_A%W%';