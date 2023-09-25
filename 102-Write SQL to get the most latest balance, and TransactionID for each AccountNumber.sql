Scanning/*
create table transactions(
accno int,
transaction_time datetime,
transaction_id int,
balance int
);

insert into transactions values(550,'2020-05-12 05:29:44.120',1001,2000);
insert into transactions values(550,'2020-05-15 10:29:25.630',1002,8000);
Insert into transactions values(460,'2020-03-15 11:29:23.620',1003,9000);
insert into transactions values(460,'2020-04-30 11:29:57.320',1004,7000);
insert into transactions values(460,'2020-04-30 12:32:44.223',1005,5000);
insert into transactions values(640,'2020-02-18 06:29:34.420',1006,5000);
insert into transactions values(640,'2020-02-18 06:29:37.120',1007,9000);
*/
select * from transactions

--Ist Method 
select accno,balance,transaction_id from (select * , row_number() over (partition by accno order by transaction_time desc ) AS rnk  from transactions) K
where rnk=1

--2nd Method 

 WITH LatestTransaction AS (
  SELECT accno, MAX(transaction_time) AS max_transaction_time
  FROM transactions
  GROUP BY accno
)

SELECT
 distinct  t.accno, t.transaction_id, t.balance
FROM
  transactions t
INNER JOIN
  LatestTransaction lt
ON
  t.accno = lt.accno
  AND t.transaction_time = lt.max_transaction_time;

