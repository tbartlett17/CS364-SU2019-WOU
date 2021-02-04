use AdventureWorks2017

-- This is a comment
-- Note: This does not seem to be case sensitive?
select * from [HumanResources].[Department]

--SHOW ME ALL THE DEPARTMENT NAMES
select name from HumanResources.Department

--SHOW ME ALL GROUPS
select groupname from HumanResources.Department

--SHOW ME ALL THE DISTINCT GROUPINGS
select distinct groupname from HumanResources.Department

--SHOW ME ALL DEPARTMENT NAMES WHO ARE A PART OF MANUFACTURING
select name, groupname from HumanResources.Department
where groupname like 'manufacturing'

--GIVE ME ALL EMPLOYEES FROM EMPLOYEE TABLE
select * from HumanResources.Employee

--GIVE ME A LIST OF ALL EMPLOYEES WHO HAVE A ORGLEVEL = 2
SELECT * FROM HumanResources.Employee WHERE OrganizationLevel = 2

-- GIVE ME A LIST OF ALL EMPLOYEES WHO HAVE ORGLEVEL =2 OR 3
SELECT * FROM HumanResources.Employee WHERE OrganizationLevel in (2,3)

--GIVE ME A LIST OF EMPLOYEES WHO HAVE A TITLE AS FACILITIES MANAGER
SELECT * FROM HumanResources.Employee where jobtitle like 'facilities manager'

--GIVE ME A LIST OF EMPLOYEES WHO HAVE A TITLE AS MANAGER (OF ANY KIND) (using a wild card: %) (this pulls titles of _____ manager)
SELECT * FROM HumanResources.Employee where jobtitle like '%manager'

--GIVE ME A LIST OF EMPLOYEES WHO HAVE the word control in ther title (using a wild card: %) (this pulls titles of _____ control ________)
SELECT * FROM HumanResources.Employee where jobtitle like '%control%'

--GET A LIST OF ALL EMPLOYEES BORN AFTER Jan 1, 1980
SELECT * FROM HumanResources.Employee where BirthDate > '1/1/1980'

--GET A LIST OF ALL EMPLOYEES BORN between Jan 1, 1970 Jan 1, 1980 (NOTE: BOTH THE FOLLOWING ARE THE SAME)
SELECT * FROM HumanResources.Employee where BirthDate between '1/1/1970' and '1/1/1980'
SELECT * FROM HumanResources.Employee where BirthDate > '1/1/1970' AND  BirthDate < '1/1/1980'

--CALCULATED COLUMS
select name, ListPrice from Production.Product

--makes a temp col for adjusted_list_price
select name, listprice, listprice + 10 as adjusted_list_price from Production.Product

--permforms calculation, creates a new table and stores the info there. the table is made whereever the focus is
--which we set to AventureWorks2017 by using the 'use' keyword
select name, listprice, listprice + 10 as adjusted_list_price into production.product_2 from Production.Product

--checkout the table we made
select * from Production.product_2

--we can make a temp table by using'#'. temp tables are only viewable while a connection to the database is maintained.
--perhaps good for complex calculation where you need to break them up into steps. make temp tables of steps
--then make a finalized table later
select name, listprice, listprice + 10 as adjusted_list_price into #tempTable from Production.Product

--HOW TO DELETE DATA FROM A TABLE (note:  this is a direct match)
delete from Production.product_2 where name like 'Bearing Ball'

select * from Production.product_2

--UPDATING A TABLE
update Production.product_2
set name = 'blade_new'
where name like 'blade'

select * from Production.product_2


--JOINING MULTIPLE TABLES TOGETHER
-- first some setup 
Create table myEmployee (employeeID int, firstName varchar(20), lastName varchar(20))
insert into myEmployee values (1, 'Michael', 'Scot')
insert into myEmployee values (2, 'Pam', 'Beesly')
insert into myEmployee values (3, 'Dwight', 'Schrute')

create table mySalary (employeeID int, salary float)
insert into mySalary values (1, 10000)
insert into mySalary values (2, 8000)
insert into mySalary values (3, 6000)

create table myPhone (employeeID int, phoneNumber float)
insert into myPhone values (1, 1111111111)
insert into myPhone values (2, 2222222222)

create table myParking (employeeID int, parkingSpot varchar(20))
insert into myParking values (1, 'a1')
insert into myParking values (2, 'a2')

create table myCustomer (customerID int, customerName varChar(20))
truncate table myCustomer
insert into myCustomer values (1, 'Rakesh')
insert into myCustomer values (3, 'John')

create table myOrder (orderNum int, orderName varchar(20), customerID int)
insert into myOrder values (1, 'someOrder1', 1)
insert into myOrder values (2, 'someOrder2', 2)
insert into myOrder values (3, 'someOrder3', 7)
insert into myOrder values (4, 'someOrder4', 8)

select * from myEmployee
select * from mySalary
--INNER JOIN (note: 'A' and 'B' are aliases (think instanciated object))
select A.firstName, A.lastName, B.salary from myEmployee A inner join mySalary B on A.employeeID = B.employeeID

select * from myEmployee
select * from myPhone
--LEFT OUTER JOIN
select A.firstName, A.lastName, B.phoneNumber from myEmployee A left join myPhone B on A.employeeID = B.employeeID

select * from myEmployee
select * from myParking
--RIGHT OUTER JOIN
select A.parkingSpot, B.firstName, B.lastName from myParking A right join myEmployee B on A.employeeID = B.employeeID

select * from myCustomer
select * from myOrder
--FULL OUTER JOIN
select A.customerID,A.customerName, B.orderNum, B.orderName from myCustomer A full outer join myOrder B on A.customerID = B.customerID

select * from myCustomer
select * from mySalary
--CROSS JOIN (note: both forms are the same)
select * from myCustomer cross join mySalary
select * from myCustomer, mySalary

--DATE FUNCTIONS
select GETDATE()
select GETDATE()-2

select DATEPART(yyyy, getdate()) as yearNumber
select DATEPART(mm, getdate()) as monthNumber
select DATEPART(dd, getdate()) as yearNumber

--DATEADD
select DATEADD(day, 4, getdate())
select DATEADD(day, 4, '6/28/2018')
select DATEADD(month, 4, getdate())
select DATEADD(year, 4, getdate())

use AdventureWorks2017
--DATEDIFF
select top 10 * from Production.WorkOrder
select workOrderID, ProductID, startDate, EndDate, DATEDIFF(day, StartDate, EndDate) from Production.WorkOrder

--GET FIRST DAY OF THIS MONTH
Select DATEADD(dd, -(DATEPART(day, getDate())-1), getdate())

--mySalary
--AGGREGATE FUNCTIONS 
select * from mySalary
select AVG(salary) from mySalary

--COUNT is a row-wise opeerator. counts num of rows
select count(salary) from mySalary
select count(*) from mySalary

select sum(salary) from mySalary

select min(salary) from mySalary
select max(salary) from mySalary

--STRING FUNCTIONS

select * from myOrder

--STRING CONCAT
print concat('String1', ' String2')
select orderNum, orderName, concat(orderName, ' ', RAND()) as concatenatedtext from myOrder

--GET FIRST 5 CHARS FROM  ORDER NAMES
select orderNum, orderName, LEFT(orderName, 5) from myOrder

--GET LAST 5 CHARS FROM  ORDER NAMES
select orderNum, orderName, RIGHT (orderName, 5) from myOrder

--GET MIDDLE 5 CHARS FROM ORDER NAMES
select orderNum, orderName, substring(orderName, 2, 5) from myOrder

--TO UPPERCASE and TO LOWWERCASE
select orderNum, orderName, UPPER(orderName) from myOrder

--GET LENGTH OF STRINGS
select orderNum, orderName, LEN(orderName) from myOrder

--A CHALLENGE make only the first char of string a capital
select orderNum, orderName, concat(UPPER(LEFT(OrderName, 1)), LOWER(SUBSTRING(ORDERNAME, 2, LEN(ORDERNAME)))) from myOrder

--TRIM FUNCTION (removes spaces)
select '      myText     '
select len('      myText     ')
select LTRIM('      myText     ')
select RTRIM('      myText     ')
select LTRIM(RTRIM('      myText     '))

