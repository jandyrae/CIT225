create user 'student'@'localhost' identified by 'salmon';

grant select on sakila.* to 'student'@'localhost';

-- check to see if done right (line 1)
use mysql;
select * from user;

-- check to see if grant was accepted (line 3)
show grants for 'student'@'localhost';
-- gives delete and insert capablilties
grant delete, insert on sakila.* to 'student'@'localhost';
-- removes capabilities
revoke delete, insert on sakila.* from 'student'@'localhost';
drop user 'student'@'localhost';

-- provision the student user with privileges to the sakila database (week 1)
GRANT ALL ON *.* TO 'root'@'localhost';
CREATE USER 'student'@'localhost' IDENTIFIED WITH mysql_native_password BY 'student';
GRANT ALL ON sakila.* TO 'student'@'localhost';
GRANT ALL ON *.* TO 'root'@'localhost';