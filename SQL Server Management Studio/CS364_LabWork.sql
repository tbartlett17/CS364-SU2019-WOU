create database CS364Summer2018
create table supplier(SNO varChar(10), SNAME varChar(20), STATUS int, CITY varChar(20))
insert into supplier values ('S1', 'Smith', 20, 'London')
insert into supplier values ('S2', 'Jones', 10, 'Paris')
insert into supplier values ('S3', 'Blake', 30, 'Paris')
insert into supplier values ('S4', 'Clark', 20, 'London')
insert into supplier values ('S5', 'Adams', 30, 'Athens')

create table parts(PNO varChar(10), PNAME varChar(20), COLOR varChar(20), WEIGHT int, STOREDCITY varChar(20))
insert into parts values ('P1', 'Nut', 'Red', 12, 'London')
insert into parts values ('P2', 'Bolt', 'Green', 17, 'Paris')
insert into parts values ('P3', 'Screw', 'Blue', 17, 'Rome')
insert into parts values ('P4', 'Screw', 'Red', 14, 'London')
insert into parts values ('P5', 'Cam', 'Blue', 12, 'Paris')
insert into parts values ('P6', 'Cog', 'Red', 19, 'London')

create table shipment (SNO varChar(10), PNO varChar(10), QTY int)
insert into shipment values ('S1', 'P1', 300)
insert into shipment values ('S1', 'P2', 200)
insert into shipment values ('S1', 'P3', 400)
insert into shipment values ('S1', 'P4', 200)
insert into shipment values ('S1', 'P5', 100)
insert into shipment values ('S1', 'P6', 100)
insert into shipment values ('S2', 'P1', 300)
insert into shipment values ('S2', 'P2', 400)
insert into shipment values ('S3', 'P2', 200)
insert into shipment values ('S4', 'P2', 200)
insert into shipment values ('S4', 'P4', 300)
insert into shipment values ('S4', 'P5', 400)

--check our tables work
select * from supplier
select * from parts
select * from shipment, parts

--part 3 question 1
select distinct [sno] 
from shipment 

--part 3 question 2
select [sno] 
from supplier 
where [city] = 'Paris' and [status] > 20

--part 3 question 3
select [sno], [status] 
from supplier 
where city = 'Paris'
order by [status] desc

--part 3 question 4
select *
from supplier, parts
where city=STOREDCITY
order by CITY

--part 3 question 5
SELECT SUM(QTY) 
FROM sp 
WHERE SNO = 'S4'

--part 4 question 1
SELECT SNO
FROM shipment
GROUP BY SNO
HAVING COUNT(PNO) > 1

--part 4 question 2
SELECT DISTINCT SNAME
FROM SP A
JOIN S B
ON A.SNO = B.SNO
JOIN p C
ON A.PNO = C.PNO
WHERE COLOR = 'Red'

SELECT SNAME 
FROM S join SP on S.SNO = SP.SNO join P on SP.PNO = P.PNO
WHERE Color = 'Red'


--part 4 question 3
SELECT DISTINCT supplier.SNO
FROM supplier
WHERE supplier.SNO 
NOT IN (
SELECT shipment.SNO
FROM shipment
WHERE shipment.PNO = 'P2')

--part 4 question 4
SELECT PNO, SUM(QTY) AS TOTALORDER
FROM sp
GROUP BY PNO

--part 4 question 5
SELECT PNO, S.SNO, SNAME
FROM S join SP on S.SNO = SP.SNO
WHERE PNO in
(Select PNO FROM SP GROUP BY PNO Having count(*) > 1)
ORDER BY PNO ASC

--Rewrite the following SQL statement to fix its problem(s).
SELECT City, Count(*)
FROM shipment join supplier on shipment.SNO = supplier.SNO
Where QTY > 100
GROUP BY City
HAVING Count(*) > 3
ORDER By City

--If two suppliers are in the same city,
--list the city and two supplier’s names
SELECT S.CITY, S.SNAME, S2.SNAME
FROM supplier AS S
JOIN supplier AS S2
ON S.CITY = S2.CITY
AND S.SNAME != S2.SNAME
ORDER BY CITY

--List SNO, SName, and PNO for suppliers that ship two or more red parts
SELECT DISTINCT SNAME
FROM shipment A
LEFT JOIN supplier B
ON A.SNO = B.SNO
LEFT JOIN parts C
ON A.PNO = C.PNO
WHERE COLOR = 'Red'
GROUP BY SNAME
HAVING COUNT(*) > 2

--For each red part, list the number of suppliers who ship the part.
SELECT parts.PNAME, COUNT(*) AS NUM_SHIPPERS
FROM parts
JOIN shipment
ON parts.PNO = shipment.PNO
WHERE COLOR = 'Red'
GROUP BY PNAME
ORDER BY NUM_SHIPPERS

--List the suppliers who do not ship any red part. 
SELECT DISTINCT supplier.SNO
FROM supplier
WHERE supplier.SNO 
NOT IN (
SELECT shipment.SNO
FROM parts
JOIN shipment
ON parts.PNO = shipment.PNO
WHERE parts.COLOR = 'Red')



SELECT DISTINCT SNAME
FROM shipment A
LEFT JOIN supplier B
ON A.SNO = B.SNO
LEFT JOIN parts C
ON A.PNO = C.PNO
GROUP BY SNAME
HAVING COUNT(*) = 3

SELECT SNAME 
FROM supplier 
WHERE SNO NOT in
(Select SNO FROM shipment WHERE PNO = 'P2')


SELECT PNO, SNO
FROM shipment
WHERE IN(
SELECT )

SELECT SUPPLIER.CITY, COUNT(*)
FROM supplier, shipment
GROUP BY CITY


--Get supplier names for suppliers who
--supply a part supplied by S3 Using 
--EXISTS. Yes You have to use EXISTS.
SELECT DISTINCT S.SNAME
FROM S, SP
WHERE SP.SNO = S.SNO
AND EXISTS
(
	SELECT SP.SNO, SP.PNO
	FROM SP
	WHERE SP.SNO = 'S3'
)

--Get supplier names for suppliers who
--supply at least one red part using EXISTS
SELECT DISTINCT S.SNAME 
FROM S
WHERE EXISTS
(
	SELECT SP.PNO 
	FROM SP JOIN P
	ON SP.PNO = P.PNO
	WHERE COLOR = 'Red'
	AND SP.SNO = S.SNO
)

--2.3
--Give two different approaches to get supplier names
--for suppliers who do not supply parts supplied by S3.
SELECT DISTINCT S.SNO, SNAME
FROM S
WHERE S.SNO NOT IN
(
	SELECT SP.SNO
	FROM SP JOIN SP AS SP2
	ON SP.PNO = SP2.PNO
	WHERE SP2.SNO = 'S3'
);

--2.4
--Get part numbers and suppliers’ names for all parts 
--shipped by more than one supplier without using 
--Having Count (*) anywhere in your SQL statement.
--[Hint must use re-name to join a table with itself].
SELECT DISTINCT SP.PNO, S.SNO, SNAME
FROM SP JOIN SP AS SP2
ON SP.PNO = SP2.PNO
JOIN S ON S.SNO = SP.SNO
WHERE SP.SNO != SP2.SNO
ORDER BY PNO ASC;

--2.5
--Get part names for parts supplied by all suppliers. 
--[modify your database contents to test your query if necessary.]

--I ADDED A RECORD TO SP FOR TESTING. [S5, P2, 100]
SELECT DISTINCT PNO, PNAME
FROM P 
WHERE NOT EXISTS
(
	SELECT *
	FROM S
	WHERE NOT EXISTS
	(
		SELECT *
		FROM SP
		WHERE SP.PNO = P.PNO
		AND SP.SNO = S.SNO
	) 
);

--2.6
--Get supplier names for suppliers who supply at least all those
--parts supplied by supplier S7.[Do not even start this one
-- unless you completely understand Q5].

--I ADDED RECORDS TP SP FOR TESTING
SELECT PNO, PNAME
FROM P
WHERE NOT EXISTS
(
	SELECT *
	FROM S
	WHERE NOT EXISTS
	(
		SELECT *
		FROM SP
		WHERE SNO IN (SELECT SNO FROM s)
	)
);

--2.7
--Get the supplier’s name for the suppler that has the most
--shipment in terms of QTY. Your query should return one record. 
--[Hint: research on using TOP for SQL Server or 
--LIMIT for MySQL. Yes, research is necessary].
SELECT TOP 1 S.SNO, S.SNAME, SUM(QTY) AS CT 
FROM S JOIN SP 
ON S.SNO = SP.SNO
GROUP BY S.SNO, S.SNAME
ORDER BY CT DESC;

--2.8
--Get the supplier names for the suppliers that only ship red parts.

--I MODIFIED THE SP RECORD FOR S5 FROM [S5, P2, 100]
-- TO [S5, P4, 100] FOR TESTING MY QUERY
SELECT SNO, SNAME
FROM S
WHERE SNO NOT IN
(	
	SELECT S.SNO
	FROM S JOIN SP 
	ON S.SNO = SP.SNO 
	JOIN P 
	ON SP.PNO = P.PNO
	WHERE Color != 'Red'
);

--2.9
--Remove the shipment records for S1 on P2. [Figure out which table].
--Add the record back. 
DELETE FROM dbo.SP WHERE SNO = 'S1'AND PNO = 'P2';

INSERT INTO dbo.SP VALUES ('S1', 'P2', 200);

SELECT * FROM SP;

--2.10
--Remove S3 from the database, that is, S3 will no longer
--exist in the database anywhere!
DELETE FROM dbo.SP WHERE SNO LIKE 'S3';

DELETE FROM dbo.S WHERE SNO LIKE 'S3';

SELECT * FROM S
where exists (select * from P)

SELECT SNO
FROM S
WHERE NOT  EXISTS
(
	SELECT *
	FROM P
	WHERE NOT EXISTS
	(
		SELECT *
		FROM SP
		WHERE SNO = 'S777'
	)
	AND  EXISTS
	(
		SELECT * FROM SP
		WHERE SP.PNO = P.PNO
		AND SP.SNO = S.SNO
	)
)
SELECT P.PNO, S.SNAME, S.SNO, P.PNAME
FROM S JOIN SP ON S.SNO = SP.SNO
JOIN P ON P.PNO = SP.PNO
ORDER BY P.PNO

SELECT *
FROM S
WHERE EXISTS (Select * from P)select * from Sp--This should be a subquery. Getting the PNO and SName if the QTY of a shipment records is greater than the average of the QTYs in the SP table.select AVG(sp.qty) as qtAVG from SP )select s.sname, sp.pnofrom s join sp on s.sno = sp.snowhere sp.pno in(	select sp.pno	from sp	group by sp.pno, sp.qty	having sp.qty > avg(sp.qty)) select * from pupdate dbo.pset p.pno = 'p7'where p.pno = 'p5'select sp.pno, s.sno, s.snamefrom sp join s on sp.sno = s.snowhere sp.pno not in (select p.pno from p)SELECT * FROM SPSELECT S.SNO, S.SNAME FROM SWHERE NOT EXISTS(	SELECT *	FROM P	WHERE  PNO IN (SELECT PNO FROM SP WHERE SNO = 'S2')
	AND NOT EXISTS	(		SELECT *		FROM SP		WHERE SP.PNO = P.PNO		AND SP.SNO = S. SNO	))