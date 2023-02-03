use sakila;
-- Transactions (Chapter 12)

-- Learn how to design MySQL transactions.
-- Learn how to write MySQL transactions.
-- Learn how to set and roll back to a SAVEPOINT.
-- Learn how table locking works in the MySQL database.

show table status like "actor"; -- will show engine (this case InnoDB) among other information from the table
-- SAVEPOINT my_savepoint; lable the savepoint
-- ROLLBACK TO SAVEPOINT my_savepoint; give rollback command to the savepoint set

-- Exercise 12-1
-- Generate a unit of work to transfer $50 from account 123 to account 789. You will need to insert 
-- two rows into the transaction table and update two rows in the account table. Use the following 
-- table definitions/data:
start transaction;
savepoint initial_savepoint;
create temporary table transaction(txn_id int auto_increment not null key, txn_date date not null, account_id int not null, txn_type_cd varchar(1) not null, amount int not null); 
insert into transaction values
(1001, '2019-05-15', 123, 'C', 500),
(1002, '2019-06-01', 789, 'C', 75);
select * from transaction;
create temporary table account(account_id int key, avail_balance int, last_activity_date datetime);
insert into account values
(123, 500, '2019-07-10 20:53:27'), (789, 75, '2109-06-22 15:18:35');
select * from account;

begin work;
insert into transaction(txn_id, txn_date, account_id, txn_type_cd, amount)
values 
(1003, date(now()), 123, 'D', 50),
(1004, date(now()), 789, 'C', 50);

update account
set avail_balance = avail_balance - 50,
last_activity_date = now()
where account_id = 123 and avail_balance > 50;
update account
set avail_balance = avail_balance + 50,
last_activity_date = now()
where account_id = 789;
-- rollback to savepoint initial_savepoint;
-- drop table transaction;
-- drop table account; 
-- commit;