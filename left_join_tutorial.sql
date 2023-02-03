CREATE DATABASE family_tree;


USE family_tree;


/* ========= CLEANUP =========== 
 *  uncomment to make re-runnable
 */
-- DROP VIEW person_info;
-- DROP VIEW person_historical_alias;
-- DROP VIEW person_relationship;
-- ALTER TABLE person DROP CONSTRAINT person_fk1;
-- DROP TABLE person_identity;
-- DROP TABLE relationship;
-- DROP TABLE relationship_type;
-- DROP TABLE person;


/*
 *  If you want to erase it all after you are done, issue the follwing command:
 * 
 * DROP DATABASE family_tree;
 */

CREATE TABLE person 
( person_id INT PRIMARY KEY AUTO_INCREMENT 
, birthdate DATE NOT NULL 
, biological_gender VARCHAR(1) CONSTRAINT CHECK(biological_gender IN ('M','F'))
, current_identity_id INT);


CREATE TABLE person_identity
( identity_id INT PRIMARY KEY AUTO_INCREMENT 
, person_id INT NOT NULL
, first_name VARCHAR(100) NOT NULL 
, last_name VARCHAR(100) NOT NULL 
, middle_name VARCHAR(100)
, nickname VARCHAR(100)
, start_date DATE NOT NULL DEFAULT (CURRENT_DATE)
, end_date DATE
, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
, modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
, CONSTRAINT identity_fk1 FOREIGN KEY (person_id) REFERENCES person(person_id) );


-- Now that the identity table exists, we can build the FOREIGN KEY. We have to do this because it is a circular dependency (they depend on each other).
ALTER TABLE person
ADD CONSTRAINT person_fk1 FOREIGN KEY (current_identity_id) REFERENCES person_identity(identity_id) ON DELETE CASCADE;


CREATE TABLE relationship_type 
( relationship_type_id INT PRIMARY KEY AUTO_INCREMENT 
, name VARCHAR(30) NOT NULL 
, CONSTRAINT relationship_type_uq1 UNIQUE (name) );


-- Insert our pre-set relationship definitions
INSERT INTO relationship_type 
( name )
VALUES
('Spouse'),('Biological Child'),('Biological Father'),('Biological Mother');

CREATE TABLE relationship 
( relationship_id INT PRIMARY KEY AUTO_INCREMENT 
, person_1_id INT NOT NULL
, person_2_id INT NOT NULL
, relationship_type_id INT NOT NULL
, start_date DATE NOT NULL DEFAULT (CURRENT_DATE)
, end_date DATE 
, CONSTRAINT relationship_fk1 FOREIGN KEY (person_1_id) REFERENCES person(person_id)
, CONSTRAINT relationship_fk2 FOREIGN KEY (person_2_id) REFERENCES person(person_id) 
, CONSTRAINT relationship_fk3 FOREIGN KEY (relationship_type_id) REFERENCES relationship_type(relationship_type_id) );



-- Fill our data 


-- Harry Potter
INSERT INTO person 
(birthdate, biological_gender)
VALUES 
('1980-07-31','M');

INSERT INTO person_identity
(person_id, first_name, last_name, middle_name, start_date)
VALUES 
( (SELECT MAX(person_id) FROM person) , 'Harry','Potter','James','1980-07-31');




-- James Potter
INSERT INTO person 
(birthdate, biological_gender)
VALUES 
('1960-03-27','M');

INSERT INTO person_identity
(person_id, first_name, last_name, middle_name, nickname, start_date)
VALUES 
( (SELECT MAX(person_id) FROM person) , 'James','Potter',NULL, 'Prongs','1960-03-27');



-- Lily Potter
INSERT INTO person 
(birthdate, biological_gender)
VALUES 
('1960-12-30','F');

-- Prior to marriage
INSERT INTO person_identity
(person_id, first_name, last_name, middle_name, nickname, start_date, end_date)
VALUES 
( (SELECT MAX(person_id) FROM person) , 'Lily','Evans','J', NULL, '1960-12-30','1978-07-17');

-- Name change for marriage
INSERT INTO person_identity
(person_id, first_name, last_name, middle_name, nickname, start_date, end_date)
VALUES 
( (SELECT MAX(person_id) FROM person) , 'Lily','Potter','J', NULL, '1978-07-18',NULL);



-- Ginny Weasley
INSERT INTO person 
(birthdate, biological_gender)
VALUES 
('1981-08-11','F');

INSERT INTO person_identity
(person_id, first_name, last_name, middle_name, nickname, start_date, end_date)
VALUES 
( (SELECT MAX(person_id) FROM person) , 'Ginny','Weasley',NULL, NULL, '1981-08-11', '2000-02-13');

INSERT INTO person_identity
(person_id, first_name, last_name, middle_name, nickname, start_date, end_date)
VALUES 
( (SELECT MAX(person_id) FROM person) , 'Ginny','Potter',NULL, NULL, '2000-02-14', NULL);



-- Set the current_identity_id for easy access
UPDATE person p 
INNER JOIN person_identity ident 
ON p.person_id = ident.person_id 
SET p.current_identity_id = ident.identity_id 
WHERE (ident.start_date <= CURRENT_DATE AND IFNULL(ident.end_date, CURDATE()+1) >= CURDATE());


-- Create an easy view
CREATE VIEW person_info AS
SELECT 
  p.person_id
, i.identity_id
, i.first_name 
, i.last_name 
, i.middle_name 
, p.birthdate 
, p.biological_gender 
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id;


SELECT * FROM person_info;


-- Create a view for all the historical aliases
CREATE VIEW person_historical_alias AS 
SELECT 
  p.person_id
, p.birthdate 
, p.biological_gender 
, i.identity_id
, i.first_name 
, i.last_name 
, i.middle_name 
, i.start_date
, i.end_date
FROM person p 
INNER JOIN person_identity i 
ON p.person_id = i.person_id
ORDER BY p.person_id, i.start_date;

SELECT * FROM person_historical_alias;



-- Build relationships

-- Harry Potter -> James
INSERT INTO relationship 
( person_1_id, person_2_id, relationship_type_id, start_date, end_date)
VALUES
( (SELECT person_id FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, (SELECT person_id FROM person_info WHERE first_name = 'James' AND last_name = 'Potter')
, (SELECT relationship_type_id FROM relationship_type WHERE name = 'Biological Father')
, (SELECT birthdate FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, '1981-10-31'
);

-- James -> Harry
INSERT INTO relationship 
( person_1_id, person_2_id, relationship_type_id, start_date, end_date)
VALUES
( (SELECT person_id FROM person_info WHERE first_name = 'James' AND last_name = 'Potter')
, (SELECT person_id FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, (SELECT relationship_type_id FROM relationship_type WHERE name = 'Biological Child')
, (SELECT birthdate FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, '1981-10-31'
);

-- Harry Potter -> Lily
INSERT INTO relationship 
( person_1_id, person_2_id, relationship_type_id, start_date, end_date)
VALUES
( (SELECT person_id FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, (SELECT person_id FROM person_info WHERE first_name = 'Lily' AND last_name = 'Potter')
, (SELECT relationship_type_id FROM relationship_type WHERE name = 'Biological Mother')
, (SELECT birthdate FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, '1981-10-31'
);

-- Lily -> Harry
INSERT INTO relationship 
( person_1_id, person_2_id, relationship_type_id, start_date, end_date)
VALUES
( (SELECT person_id FROM person_info WHERE first_name = 'Lily' AND last_name = 'Potter')
, (SELECT person_id FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, (SELECT relationship_type_id FROM relationship_type WHERE name = 'Biological Child')
, (SELECT birthdate FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, '1981-10-31'
);


-- Harry Potter -> Ginny
INSERT INTO relationship 
( person_1_id, person_2_id, relationship_type_id, start_date, end_date)
VALUES
( (SELECT person_id FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, (SELECT person_id FROM person_info WHERE first_name = 'Ginny' AND last_name = 'Potter')
, (SELECT relationship_type_id FROM relationship_type WHERE name = 'Spouse')
, '2000-02-14'
, NULL
);

-- Ginny -> Harry
INSERT INTO relationship 
( person_1_id, person_2_id, relationship_type_id, start_date, end_date)
VALUES
( (SELECT person_id FROM person_info WHERE first_name = 'Ginny' AND last_name = 'Potter')
, (SELECT person_id FROM person_info WHERE first_name = 'Harry' AND last_name = 'Potter')
, (SELECT relationship_type_id FROM relationship_type WHERE name = 'Spouse')
, '2000-02-14'
, NULL
);



-- Build a relationship view
CREATE VIEW person_relationship AS 
SELECT 
  p.person_id 
, p.birthdate
, p.biological_gender
, i.first_name 
, i.last_name 
, i.middle_name
, rp.person_id AS relative_person_id
, rp.biological_gender AS relative_gender
, rt.name AS relationship_type 
, ri.first_name AS relative_first
, ri.last_name AS relative_last
, ri.middle_name AS relative_middle
, r.start_date AS relationship_start
, r.end_date AS relationship_end
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id 
LEFT JOIN relationship r 
ON p.person_id = r.person_1_id
LEFT JOIN person rp 
ON r.person_2_id = rp.person_id
LEFT JOIN person_identity ri 
ON rp.current_identity_id = ri.identity_id
LEFT JOIN relationship_type rt 
ON r.relationship_type_id = rt.relationship_type_id
ORDER BY p.person_id, r.start_date, ri.last_name, ri.first_name;


SELECT * FROM person_relationship;


/*==================================================================================================
 * EXERCISE:
 * Understanding when to use a LEFT or RIGHT JOIN (also known as LEFT OUTER or RIGHT OUTER)
 * 
 * We will walk through an exercise showing why it is important to use the correct join depending on our data
 * ==================================================================================================
 */

-- To iterate the point, let's add another person

-- Hagrid
INSERT INTO person 
(birthdate, biological_gender)
VALUES 
('1928-12-06','M');


INSERT INTO person_identity
(person_id, first_name, last_name, middle_name, nickname, start_date, end_date)
VALUES 
( (SELECT MAX(person_id) FROM person) , 'Rubeus','Hagrid',NULL, 'Hagrid', '1928-12-06', NULL);


-- Set the current_identity_id for easy access
UPDATE person p 
INNER JOIN person_identity ident 
ON p.person_id = ident.person_id 
SET p.current_identity_id = ident.identity_id 
WHERE (ident.start_date <= CURRENT_DATE AND IFNULL(ident.end_date, CURDATE()+1) >= CURDATE());








SELECT * FROM person_info;

-- K, there is the hairy old guy.

SELECT * FROM person_relationship;

-- hmmmm never realized how lonely hagrid is. He isn't really related to anyone we have in our database.... Hope that doesn't... cause any issues *dramatic music plays*
-- Let's get all of our people and how many relationships they have so we can quantify how lonely old Hagger is.

SELECT 
  p.person_id 
, i.first_name 
, i.last_name 
, COUNT(r.relationship_id) AS relations
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id 
INNER JOIN relationship r 
ON p.person_id = r.person_1_id
GROUP BY
  p.person_id
, i.first_name
, i.last_name;

-- Oh look how cute it is that everyone is connected to Harry... WAIT! We were supposed to be picking on lonely old Hagrid. Why doesn't he show up?!  *Mysterius music plays*

-- Lets dissect this query. Here is the first section of data. The root person:
SELECT 
  p.person_id 
, i.first_name 
, i.last_name 
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id;

-- Yup, Hagrid shows up. So we are losing him in our JOIN to relationship....
-- Wait! He doesn't have a relationship. Because we are using an INNER JOIN, we will only return records who have a match in both tables, thus excluding people like Hagrid. *Trumpet Flairs*

-- Lets use a JOIN that will include all of our people, whether or not they have any relations, like a LEFT JOIN.
SELECT 
  p.person_id 
, i.first_name 
, i.last_name 
, COUNT(r.relationship_id) AS relations
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id 
LEFT JOIN relationship r 
ON p.person_id = r.person_1_id
GROUP BY
  p.person_id
, i.first_name
, i.last_name;

-- There he is! He may not have any relatives of consequence to the wizarding world, but he matters to us. *Titanic theme music chorus plays*






-- More complicated query
-- ====================================================





-- We want to get a list of *ALL* of our people, and their father (even if they don't have one return NULL) in a single line. Let's start by using INNER JOIN all the way. 
SELECT 
  p.person_id 
, i.first_name 
, i.last_name
, fp.person_id AS father_person_id
, fi.first_name AS father_first
, fi.last_name AS father_last
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id 
INNER JOIN relationship fr 
ON p.person_id = fr.person_1_id
AND fr.relationship_type_id = (SELECT relationship_type_id FROM relationship_type WHERE name = 'Biological Father')
INNER JOIN person fp
ON fr.person_2_id = fp.person_id
AND fp.biological_gender = 'M'
INNER JOIN person_identity fi 
ON fp.current_identity_id = fi.identity_id
ORDER BY p.person_id;

/*
 * Uh oh..... We only get Harry Potter. This is because we are using and INNER JOIN and he is the only person who has a father recorded.
 * 
 * We want to keep our main person and the join to their identity as INNER, because we only want matches so we make sure our names are accurate.
 * 
 * So to get *ALL* of our people in this list, whether or not we have their parent records, we need to adjust our joins. Let's try changing the relationship join to LEFT
 */
SELECT 
  p.person_id 
, i.first_name 
, i.last_name
, fp.person_id AS father_person_id
, fi.first_name AS father_first
, fi.last_name AS father_last
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id 
LEFT JOIN relationship fr 
ON p.person_id = fr.person_1_id
AND fr.relationship_type_id = (SELECT relationship_type_id FROM relationship_type WHERE name = 'Biological Father')
INNER JOIN person fp
ON fr.person_2_id = fp.person_id
AND fp.biological_gender = 'M'
INNER JOIN person_identity fi 
ON fp.current_identity_id = fi.identity_id
ORDER BY p.person_id;


/*
 * Drat! Still not what we want. This is because all of the subsquent joins are still INNER. So we would exclude all non-matches (people without fathers) in all of 
 * the subsequent joins.
 * 
 * Let's change everything after our relationship join to LEFT as well.
 * 
*/
SELECT 
  p.person_id 
, i.first_name 
, i.last_name
, fp.person_id AS father_person_id
, fi.first_name AS father_first
, fi.last_name AS father_last
FROM person p 
INNER JOIN person_identity i 
ON p.current_identity_id = i.identity_id 
LEFT JOIN relationship fr 
ON p.person_id = fr.person_1_id
AND fr.relationship_type_id = (SELECT relationship_type_id FROM relationship_type WHERE name = 'Biological Father')
LEFT JOIN person fp
ON fr.person_2_id = fp.person_id
AND fp.biological_gender = 'M'
LEFT JOIN person_identity fi 
ON fp.current_identity_id = fi.identity_id
ORDER BY p.person_id;
















