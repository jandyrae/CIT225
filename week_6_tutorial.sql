USE sakila;

/* First we want to create a savepoint so everything we do can be undone. **If you are using an IDE, make sure it is set to manual commit mode and not auto-commit mode**
 * 
 *  SAVEPOINT is a Transaction Control Language (TCL) statement that will act like a 'save game' that we can revert back to.
 */
SAVEPOINT campfire;



/* Now we want to INSERT some data. We need to start with the most fundamental of data in our chain. In this case, we need a city to assign an address to. 
 * Some of the cities in the area don't exist yet. So let's add some.
 * 
 * INSERT is a Data Manipulation Language (DML) statement. It will insert rows into a table.
 */
INSERT INTO city 
( city 
, country_id 
, last_update )
VALUES 
  ( 'Salt Lake City', (SELECT  country_id FROM country WHERE country = 'United States'), CURRENT_TIMESTAMP)
, ( 'Cheyenne', (SELECT  country_id FROM country WHERE country = 'United States'), CURRENT_TIMESTAMP);

-- Next let's add some addresses that our new customers will reside at.
INSERT INTO address 
( address
, address2 
, district 
, city_id 
, postal_code 
, phone 
, location 
, last_update )
VALUES 
  ( '1 S Lions Park Dr', NULL, 'Laramie', (SELECT city_id FROM city WHERE city = 'Cheyenne'), '82001', '307-900-9000', POINT(41.15400967405382, -104.82617699226859), CURRENT_TIMESTAMP)
, ( '3450 Triumph Blvd', NULL, 'Utah', (SELECT city_id FROM city WHERE city = 'Salt Lake City'), '82001', '801-900-9000', POINT(40.430698673871596, -111.87948850270423), CURRENT_TIMESTAMP);

-- Finally we will add some customers. Yes, there is a capitalization issue here, but we will fix it later!
INSERT INTO customer 
( store_id 
, first_name 
, last_name 
, email 
, address_id 
, active 
, create_date 
, last_update )
VALUES 
  ( 1, 'BILBO','BAGGINS','BILBO.BAGGINS@theshire.com',(SELECT address_id FROM address WHERE address='1 S Lions Park Dr'), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
, ( 1, 'Frodo','BAGGINS','frodo.BAGGINS@theshire.com',(SELECT address_id FROM address WHERE address='3450 Triumph Blvd'), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

/* Let's take a look at our customers we just added. 
 * 
 * We can see that we messed up on Frodo and we are really picky and want his name to match the case of all the other names.
 */
SELECT 
* 
FROM customer 
WHERE last_name = 'BAGGINS';


/* We want to fix a few of the fields and make them match the case of the others, which is all uppercase. 
 * 
 * UPDATE is a Data Manipulation Language (DML) statement and will change column values.
 * 
 * You will also notice there is quite a bit of function action going on here:
 *  	UPPER will convert a string to all uppercase characters.
 * 	LOWER will convert a string to all lowercase characters.
 * 	STRCMP will compare two strings for equality.
 * 	BINARY will convert a value to a binary string. We use it here because the default MySQL characterset is latin, which is case-insensitive. So in order to find the lowercase
 * 		values  we need to make sure we compare at the binary level so it is a case-sensitive comparison.
 * 
 * You can see that we set a new value for 3 columns at once.
 */
UPDATE customer 
SET first_name = UPPER(first_name)
, last_name = UPPER(last_name)
, email = REPLACE(LOWER(email), LOWER(CONCAT(first_name,'.',last_name)), CONCAT(UPPER(first_name),'.',UPPER(last_name)))
WHERE (STRCMP(UPPER(first_name), BINARY first_name) OR STRCMP(UPPER(last_name), BINARY last_name)) and last_name = 'Baggins' ;

-- Check our results. Ahhh much better.
SELECT 
* 
FROM customer
WHERE last_name = 'BAGGINS';

/* Well that was fun. Let's light it on fire.....
 * 
 * DELETE is a Data Manipulation Language (DML) statement. It will remove rows from a table.
 * 
 */
DELETE FROM customer 
WHERE last_name = 'BAGGINS';


-- Nothing left but the ashes.
SELECT 
    *
FROM
    customer
WHERE
    last_name = 'BAGGINS';

/* Now we really want to undo everything we did. 
 * 
 * ROLLBACK is a Transaction Control Language (TCL) statement. It will reset us back to our original SAVEPOINT that we created when we first started.
 */
ROLLBACK TO campfire;


/* Congrats! You got to play around a little with INSERT, UPDATE, and DELETE statements. You also got a little fun work with some character-based functions to manipulate the data a little.
 * 
 * I would recommend playing around with other scenarios. Maybe try to put your information into the Sakila database!
 */
