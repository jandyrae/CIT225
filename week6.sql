SELECT @@session.sql_mode;
SELECT 'abcdefg', CHAR(97,98,99,100,101,102,103);
SELECT CHAR(128,129,130,131,132,133,134,135,136,137);
SELECT CHAR(138,139,140,141,142,143,144,145,146,147);
SELECT CONCAT('danke sch', CHAR(148), 'n'); -- shows how to build the phrase danke schön using the concat() and char() functions:
SELECT ASCII('ö'); -- takes the leftmost character in the string and returns a number

select concat('Hello ', 'world', '!', '  It''s ', dayname(now()), '!' );


CREATE TABLE string_tbl (char_fld CHAR(30), vchar_fld VARCHAR(30), text_fld TEXT ); -- create table with set lengths
INSERT INTO string_tbl (char_fld, vchar_fld, text_fld) 
VALUES ('This is char data', 'This is varchar data', 'This is text data'); -- add data to the table
 -- text_fld = 'This string doesn't work' the apostraphe is a problem, either set a single quote just before ''
 -- SET text_fld = 'This string didn''t work, but it does now'; like this example or backslash like other programs use
 
 SELECT LENGTH(char_fld) char_length, LENGTH(vchar_fld) varchar_length, LENGTH(text_fld) text_length FROM string_tbl; -- the length function will return the field lenght
 
INSERT INTO string_tbl (char_fld, vchar_fld, text_fld) 
VALUES ('This string is 28 characters', 'This string is 28 characters', 'This string is 28 characters');

SELECT POSITION('characters' IN vchar_fld) FROM string_tbl; -- position will give where in the string the first word listed is
 -- unlike other languages position starts at 1 not the zeroeth (0) - if somehting doesn't exist it will return 0
 
 SELECT LOCATE('is', vchar_fld, 5) FROM string_tbl; -- locate takes a 3rd parameter that tells us where to start
 
 DELETE FROM string_tbl;
 INSERT INTO string_tbl(vchar_fld)
    VALUES ('abcd'),
		('xyz'),
		('QRSTUV'),
		('qrstuv'),
		('12345');
        
       -- to use strcmp() or compare strings
       -- −1 if the first string comes before the second string in sort order		
       -- 0 if the strings are identical			
       -- 1 if the first string comes after the second string in sort order
       
       SELECT STRCMP('12345','12345') 12345_12345,
			STRCMP('abcd','xyz') abcd_xyz,
			STRCMP('abcd','QRSTUV') abcd_QRSTUV,
            STRCMP('qrstuv','QRSTUV') qrstuv_QRSTUV,
            STRCMP('12345','xyz') 12345_xyz,
            STRCMP('xyz','qrstuv') xyz_qrstuv;
            
            -- returns (remember case insensitive) 
--           	+-------------+----------+-------------+---------------+-----------+------------+
--  			| 12345_12345 | abcd_xyz | abcd_QRSTUV | qrstuv_QRSTUV | 12345_xyz | xyz_qrstuv |
-- 				+-------------+----------+-------------+---------------+-----------+------------+
-- 				|           0 |       −1 |          −1 |             0 |        −1 |          1 |
-- 				+-------------+----------+-------------+---------------+-----------+------------+
use sakila;
SELECT name, name LIKE '%y' ends_in_y
	FROM category; -- can use like and regex to compare strings in the select clause (1 for true, and 0 for false)
     
SELECT name, name REGEXP 'y$' ends_in_y
    FROM category; -- yeilds a 1 if correctly matches, 0 if not
    
SELECT concat(first_name, ' ', last_name,
    ' has been a customer since ', date(create_date)) cust_narrative
    FROM customer;    
    
    SELECT INSERT('goodbye world', 9, 0, 'cruel ') string; -- allows adding or replacing in the middle at the 9th place removing 0 characters
    SELECT INSERT('goodbye world', 1, 7, 'hello') string; -- starting at the 1 position and removing 7 characters
    
    SELECT REPLACE('goodbye world', 'goodbye', 'hello') FROM dual; -- all instances of goodbye would be replaced with hello
    
    SELECT SUBSTRING('goodbye cruel world', 9, 5); -- to extract a substring from a string, extracts five characters from a string starting at the ninth position
    
     -- working with numeric data
     SELECT (37 * 59) / (78 - (8 * 6));
     SELECT MOD(10,4); -- calculates the modulus or remainder when 10 is divided by 4
     SELECT MOD(22.75, 5); -- can use real numbers (decimal)
     SELECT POW(2,8); -- exponents or powers of numbers 2 to the 8th power
     SELECT POW(2,10) kilobyte, POW(2,20) megabyte, POW(2,30) gigabyte, POW(2,40) terabyte;
     
    -- Four functions are useful when limiting the precision of floating-point numbers: ceil(), floor(), round(), and truncate(). 
    SELECT CEIL(72.445), FLOOR(72.445); -- rounds up or rounds down
    SELECT CEIL(72.000000001), FLOOR(72.999999999); -- clearer example
    SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.50001); -- rounds from the midpoint or the halfway point
    SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3); -- the second parameter tells what position to round (can use negative numbers to round to the left of the decimal)
    SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2), TRUNCATE(72.0909, 3); -- truncate() simply discards the unwanted digits
    
    -- SELECT account_id, SIGN(balance), ABS(balance) FROM account; -- to see the sign of the number or the absolute value
    
    -- Temporal Data - some ways that date time can be described
    -- Wednesday, June 5, 2019			6/05/2019 2:14:56 P.M. EST			6/05/2019 19:14:56 GMT			1562019 (Julian format)			Star date [−4] 97026.79 14:14:56 (Star Trek format)
    SELECT @@global.time_zone, @@session.time_zone;
   -- you can change the time of the session your are working in if it needs to match the server locale (SET time_zone = 'Europe/Zurich';)
   -- temporal data can be generated by copying from existing, executing a built-in function that returns date, tatetime, or time, or building a string representation of the temorpal data to be evaluated
   -- format components
--    Component			Definition							Range												
--    YYYY					Year, including century				1000 to 9999													
--    MM					Month								01 (January) to 12 (December)													
--    DD					Day									01 to 31													
--    HH					Hour								00 to 23													
--    HHH					Hours (elapsed)						−838 to 838													
--    MI					Minute								00 to 59													
--    SS					Second								00 to 59

-- required components for interpreting from the server
-- Type					Default format												
-- date						YYYY-MM-DD													
-- datetime					YYYY-MM-DD HH:MI:SS													
-- timestamp				YYYY-MM-DD HH:MI:SS													
-- time						HHH:MI:SS

SELECT CAST('2019-09-17 15:30:00' AS DATETIME); -- cast() puts in propper format
SELECT CAST('2019-09-17' AS DATE) date_field, CAST('108:17:57' AS TIME) time_field;
-- str_to_date() can be used to define the format ->  STR_TO_DATE('September 17, 2019', '%M %d, %Y') month name (%M), a numeric day (%d), and a four-digit numeric year (%Y)

-- Format component	Description (MOST COMMONLY USED, BUT THERE ARE MORE)
-- %M	Month name 		(January to December)
-- %m	Month numeric 	(01 to 12)
-- %d	Day numeric 	(01 to 31)
-- %j	Day of year 	(001 to 366)
-- %W	Weekday name 	(Sunday to Saturday)
-- %Y	Year, four-digit 	numeric
-- %y	Year, two-digit 	numeric
-- %H	Hour 			(00 to 23)
-- %h	Hour 			(01 to 12)
-- %i	Minutes 		(00 to 59)
-- %s	Seconds 		(00 to 59)
-- %f	Microseconds 	(000000 to 999999)
-- %p	A.M. or P.M.

SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP(); -- returns default formats
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY); -- adds an interval

-- common interval types
-- Interval name			Description												
-- second					Number of seconds													
-- minute					Number of minutes													
-- hour						Number of hours													
-- day						Number of days													
-- month					Number of months													
-- year						Number of years													
-- minute_second			Number of minutes and seconds, separated by “:”													
-- hour_second				Number of hours, minutes, and seconds, separated by “:”													
-- year_month				Number of years and months, separated by “-”

SELECT LAST_DAY('2019-09-17'); -- returns the last day of the month ('2019-09-30')
SELECT DAYNAME('2019-09-18');
-- learn how to use the extract() uses same interval typesas the date_add()
SELECT EXTRACT(YEAR FROM '2019-09-18 22:19:05');
SELECT DATEDIFF('2019-09-03', '2019-06-21'); -- use for differences between dates layout -> datediff(til(future), from(current))
-- If I have the earlier date first, datediff() will return a negative number
use sakila;

-- Conversion functions
SELECT CAST('1456328' AS SIGNED INTEGER);
SELECT CAST('999ABC111' AS UNSIGNED INTEGER);
show warnings;
-- Exercises
-- Exercise 7-1
-- Write a query that returns the 17th through 25th characters of the string 'Please find the substring in this string'.
select substring('Please find the substring in this string', 17, 9) removedSubstring; -- returns 'substring'

select substring('I have been making a daily effort to align my mind with things that are good', 22, 12);

-- Exercise 7-2
-- Write a query that returns the absolute value and sign (−1, 0, or 1) of the number −25.76823. Also return the number rounded to the nearest hundredth.
-- select abs(−25.76823) absolute, sign(−25.76823) sign, round(−25.76823,2) rounded;
select abs(-25.76823) absolute, sign(-25.76823) signedNum, round(-25.76823, 2), sign(0);

-- Exercise 7-3-- 
-- Write a query to return just the month portion of the current date.
select extract(month from (current_date())) as month;

select dayname(now());

Select STR_TO_DATE('September 17, 2019', '%M %d, %Y');
SELECT DAYNAME('1941-12-07') AS what_day;

SELECT CAST('0x86' AS CHAR) AS extended;

SELECT CAST(0x86 AS CHAR) AS extended;

select truncate(26.4564564564565, 2);

SELECT CAST('07-12-2016' AS DATE) AS newdate;
select cast('2016-12-07' as date) newdate;

SELECT CAST('07-DEC-2016' AS DATE) AS newdate;

SELECT (37 * 39) / (78 -3) AS calculated;

-- select length();


select quote('How are y''all doing?');

