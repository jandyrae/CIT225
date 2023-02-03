use sakila;
-- indexes
-- show index from customer\G -- the \G is supposed to tell the server to display vertically
show errors;
show tables;
describe customer;
show index from actor;

-- CREATE TABLE contacts(
--     contact_id INT AUTO_INCREMENT,
--     first_name VARCHAR(100) NOT NULL,
--     last_name VARCHAR(100) NOT NULL,
--     email VARCHAR(100),
--     phone VARCHAR(20),
--     PRIMARY KEY(contact_id),
--     UNIQUE(email),
--     INDEX phone(phone) INVISIBLE,
--     INDEX name(first_name, last_name) comment 'By first name and/or last name'
-- ); -- showing how to create table with indexes built in (including unique constraint) and a comment to be visible when searched

-- To remove an existing index from a table, you use the DROP INDEX statement as follows:
-- DROP INDEX index_name ON table_name

explain
select customer_id, first_name, last_name
from customer 
where first_name like '^s' and last_name like 'p%';
 
-- create indexes on large tables to create ways to sort faster, remember it is a tool that 
-- is also a table so it will take up memory too, so effective and efficient (necessary not many)
-- text indexes are available to scan documents, but we didn't cover them here.
-- *************************************************************
 -- constraints (restrictions that help keep tables clean - checks and balances)
--  Primary key constraints		Identify the column or columns that guarantee uniqueness within a table		
--  Foreign key constraints		Restrict one or more columns to contain only values found in another 
-- 								table’s primary key columns (may also restrict the allowable values in other 
--                              tables if update cascade or delete cascade rules are established)		
--  Unique constraints			Restrict one or more columns to contain unique values within a table (primary key 
-- 								constraints are a special type of unique constraint)		
--  Check constraints			Restrict the allowable values for a column

-- There are six different options to choose from when defining foreign key constraints:	
-- on delete restrict	
-- on update cascade	
-- on delete set null	
-- on update restrict	
-- on update cascade	
-- on update set null
-- These are optional, so you can choose zero, one, or two (one on delete and one on update) of these when defining your foreign key constraints.
-- *******
-- Exercise 13-1
-- Generate an alter table statement for the rental table so that an error will be raised if a
-- row having a value found in the rental.customer_id column is deleted from the customer table.
start transaction;
alter table rental
add constraint fk_rental_customer_id foreign key (customer_id) 
references customer (customer_id) on delete restrict on update cascade; 
-- delete restrict won't allow removal of a row from rental if it also has a customer_id from the customer table.
-- on update cascade allows another table to update if one does on the constraint field.
describe rental;
describe customer;
show keys from rental
where visible = 'no';
-- commit;

-- Exercise 13-2
-- Generate a multicolumn index on the payment table that could be used by both of the following queries:
show index from payment;
alter table payment
add index idx_payment_date_amount (payment_date, amount);

-- Assume you have a vehicle table with a surrogate key vehicle_id column and VIN (Vehicle Identification Number) 
-- column and some other columns. You want to designate a unique index on the VIN column because it has the 
-- highest cardinality (or degree of uniqueness). Write the syntax to add a unique index vehicle_uq on the VIN column?
alter table vehicle
add unique idx_vin (VIN);

-- Assume you have a vehicle table with a surrogate key vehicle_id column and VIN (Vehicle Identification Number) 
-- column and some other columns. You want to designate a unique index on the vehicle_id and VIN columns 
-- because together they filter on the joining column with the highest cardinality (or degree of uniqueness). 
-- Write the syntax to add a unique index on the vehicle_id and VIN columns triggered by joins on the surrogate key column?
alter table vehicle
add unique idx_vehicle_id_vin (vehicle_id, VIN);


-- ALTER TABLE military_lookup
-- ADD CONSTRAINT military_lookup_un1
-- UNIQUE INDEX ( table_name
-- 		, column_name
-- 		, lookup_type
-- 		, lookup_code);

show create table actor;
explain table actor;
-- create bitmap index 