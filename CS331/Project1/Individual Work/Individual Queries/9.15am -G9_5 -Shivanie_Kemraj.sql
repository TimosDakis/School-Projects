------------------------
--Simple Queries
/* should have up to 2 tables joined. 
The tables can be physical tables or views
*/
------------------------

/* Problem 1:
return customer id, orderid and its current status
using AdventureWorks2017
*/

USE AdventureWorks2017;
SELECT CustomerID, SalesOrderId, [Status]
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, SalesOrderId;

/* Problem 2:
return employee's full name with their birthday
using AdventureWorksDW2017
*/

USE AdventureWorksDW2017;
SELECT FirstName + ' ' + LastName AS FullName,
    BirthDate
FROM dbo.DimEmployee;

/* Problem 3:
return orderid and comments
using WideWorldImporters
*/

USE WideWorldImporters;
SELECT OrderId, Comments
FROM Sales.Orders;

/* Problem 4:
return orderkey with unit price
using WideWorldImportersDW
*/

USE WideWorldImportersDW;
SELECT [Order Key], [Unit Price]
FROM Fact.[Order]
ORDER BY [Order Key];

/* Problem 5:
return customer id and order id
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
SELECT CustomerId, OrderId
FROM Sales.[Order];

------------------------
--Medium Queries
/* should have from 2 to 3 tables joined and
use built-in SQL functions group by summarization. 
It should include combinations of subqueries or CTE or virtual tables.
*/
------------------------

/* Problem 6:
get the customername, customerid, and total orders made per customer
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
WITH Cust AS
(
    SELECT UPPER(C.CustomerContactName) AS CustomerName , O.CustomerId, O.OrderId
    FROM Sales.Customer AS C
        CROSS JOIN Sales.[Order] AS O
    WHERE O.CustomerId = C.CustomerId
)

SELECT C.CustomerName, C.CustomerID, Count(C.OrderId) AS TotalOrders
FROM Cust AS C
GROUP BY C.CustomerName, C.CustomerID;

/* Problem 7:
returns concated employee's name with order id
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
SELECT CONCAT(E.EmployeeFirstName, ' ' ,E.EmployeeLastName) AS FullName, O.OrderID
FROM HumanResources.Employee AS E
    INNER JOIN Sales.[Order] AS O
ON E.EmployeeId = (
    SELECT O.EmployeeId
)
GROUP BY O.OrderID, E.EmployeeFirstName, E.EmployeeLastName;

/* Problem 8:
returns custid with order year
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
SELECT C.CustomerId, YEAR(OrderDate) AS YEAR
FROM Sales.Customer AS C
    CROSS JOIN Sales.[Order] AS O
WHERE C.CustomerId = (
    SELECT O.CustomerId
)
GROUP BY C.CustomerId, YEAR(OrderDate);

/* Problem 9:
returns emplid , empl's name, birthday and department they work in
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
SELECT E.EmployeeId, T.EmployeeFullName, E.BirthDate, T.Department
FROM HumanResources.Employee AS E
    CROSS JOIN Triggered.Employee AS T
WHERE CONCAT(E.EmployeeFirstName, ' ')= (
    SELECT T.EmployeeFullName
)
GROUP BY E.EmployeeId, T.EmployeeFullName, E.BirthDate, T.Department;


/* Problem 10:
returns cust id, cust's name and order year
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
WITH CustInfo AS (
SELECT O.CustomerId, YEAR(O.OrderDate) AS orderyear, C.CustomerContactName
FROM Sales.[Order] AS O
  CROSS JOIN Sales.Customer AS C
  WHERE C.CustomerId = O.CustomerId
)
SELECT CustInfo.CustomerId, CustInfo.CustomerContactName, CustInfo.orderyear
FROM CustInfo
GROUP BY orderyear, CustInfo.CustomerContactName, CustInfo.CustomerId

/* Problem 11:
returns custid, emplid and order year
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
SELECT CO.CustomerID, O.EmployeeId, YEAR(CO.Ordermonth) AS [Year]
FROM Sales.[Order] AS O
    CROSS JOIN Sales.uvw_CustomerOrder AS CO
WHERE CO.CustomerID = (
    SELECT O.CustomerID
)
GROUP BY CO.CustomerID, O.EmployeeId, YEAR(CO.Ordermonth)
ORDER BY CO.CustomerID, O.EmployeeId;

/* Problem 12:
returns emplid, orderid, order year
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
SELECT O.EmployeeId, OD.OrderId, year(O.Orderdate) AS [Order Year]
FROM Sales.OrderDetail AS OD
    CROSS JOIN Sales.[Order] AS O
WHERE O.OrderId = (
    SELECT OD.OrderId 
) 
GROUP BY O.EmployeeId, OD.OrderId, year(O.Orderdate);

/* Problem 13:
shows digits (from 1-10) and it's square value
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;
SELECT SUM(D1.digit+1) AS digits,
    (D2.digit+1)*(D1.digit+1) AS squares
FROM dbo.Digits AS D1
    CROSS JOIN dbo.Digits AS D2
WHERE D1.digit = (
    SELECT D2.digit
) 
GROUP BY (D2.digit+1)*(D1.digit+1);

------------------------
--Complex Queries
/*  should have from 3 or more tables joined, custom scalar function 
and use built-in SQL functions and group by summarization. 
It should include combinations of subqueries or CTE or virtual tables.
*/
------------------------

/* Problem 14:
concats the employee's first and last name to make full name
returns the orderid , custid, emplid and name
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS HumanResources.findFullName
GO 

CREATE FUNCTION HumanResources.findFullName 
(
    @firstName varchar(30),
    @lastName varchar(30)
)
RETURNS varchar(65)
AS
BEGIN
    DECLARE @Result varchar(65)
    SELECT @RESULT = CONCAT(@firstname, ' ', @lastname)
    RETURN @RESULT
END;
GO

SELECT O.OrderId, C.CustomerId, E.EmployeeId, HumanResources.findFullName(E.EmployeeFirstName, E.EmployeeLastName) AS [NAME]
FROM Sales.Customer AS C
    CROSS JOIN HumanResources.Employee AS E
    CROSS JOIN Sales.[Order] AS O
WHERE C.CustomerId = (
    SELECT O.CustomerId
    WHERE E.EmployeeId = O.EmployeeId
)
GROUP BY O.OrderId, C.CustomerId, E.EmployeeId, HumanResources.findFullName(E.EmployeeFirstName, E.EmployeeLastName);

/* Problem 15:
concats the employee's first and last name to make full name
returns the emplid, name and corresponding dept
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS HumanResources.findFullName
GO 

CREATE FUNCTION HumanResources.findFullName 
(
    @firstName varchar(30),
    @lastName varchar(30)
)
RETURNS varchar(65)
AS
BEGIN
    DECLARE @Result varchar(65)
    SELECT @RESULT = CONCAT(@firstname, ' ', @lastname)
    RETURN @RESULT
END;
GO

SELECT O.EmployeeId, HumanResources.findFullName(E.EmployeeFirstName, E.EmployeeLastName) AS [NAME], T.Department
FROM HumanResources.Employee AS E
    CROSS JOIN  Sales.[Order] AS O
    CROSS JOIN Triggered.Employee AS T
WHERE T.EmployeeId = (
    SELECT E.EmployeeId
    WHERE E.EmployeeId = O.EmployeeId
)
GROUP BY O.EmployeeId, HumanResources.findFullName(E.EmployeeFirstName, E.EmployeeLastName), T.Department;

/* Problem 16:
returns emplid, orderid, and order year
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS sales.orderdate;
GO 

CREATE FUNCTION sales.orderdate
(
    @orderday DATE
)
RETURNS nvarchar(20)
AS
BEGIN
    DECLARE @Result nvarchar(20)
    SELECT @RESULT = DATEPART(year, @orderday)
    RETURN @RESULT
END;
GO

SELECT E.EmployeeId, OD.OrderId ,sales.orderdate(O.OrderDate) AS [Order Year]
FROM Sales.OrderDetail AS OD
    CROSS JOIN HumanResources.Employee AS E
    CROSS JOIN Sales.[Order] AS O
WHERE E.EmployeeId = (
    SELECT O.EmployeeId
    WHERE O.OrderId = OD.OrderId
)
GROUP BY E.EmployeeId, OD.OrderId ,sales.orderdate(O.OrderDate)

/* Problem 17:
returns custid, orderid, order month and order year
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS sales.orderdate;
GO 

CREATE FUNCTION sales.orderdate
(
    @orderday DATE
)
RETURNS nvarchar(20)
AS
BEGIN
    DECLARE @Result nvarchar(20)
    SELECT @RESULT = DATEPART(year, @orderday)
    RETURN @RESULT
END;
GO

SELECT C.CustomerID, O.OrderId, MONTH(CO.Ordermonth) AS [Order Month], sales.orderdate(O.OrderDate) AS [Order Year]
FROM Sales.Customer AS C
    CROSS JOIN Sales.uvw_CustomerOrder AS CO
    CROSS JOIN Sales.[Order] AS O
WHERE CO.CustomerID = (
    SELECT C.CustomerID
    WHERE CO.CustomerID = O.CustomerID
)
GROUP BY C.CustomerID, O.OrderId, MONTH(CO.Ordermonth), sales.orderdate(O.OrderDate)
ORDER BY C.CustomerID, O.OrderId;

/* Problem 18:
returns triggered employee's name, emplid, and their hire year
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS dbo.year;
GO 

CREATE FUNCTION dbo.year
(
    @hiredate DATE
)
RETURNS  nvarchar(20)
AS
BEGIN
    DECLARE @Result  nvarchar(20)
    SELECT @RESULT = DATEPART(year, @hiredate)
    RETURN @RESULT
END;
GO

SELECT TE.EmployeeFullName, O.EmployeeId,  dbo.year(E.Hiredate) AS [Hire Year]
FROM HumanResources.Employee AS E
    CROSS JOIN Sales.[Order] AS O
    CROSS JOIN Triggered.AuditTriggeredEmployeeHistory AS TE
WHERE TE.EmployeeId = (
    SELECT E.EmployeeId
    WHERE E.EmployeeId = O.EmployeeId
)
GROUP BY TE.EmployeeFullName, O.EmployeeId,  dbo.year(E.Hiredate);

/* Problem 19:
returns emplid and amt of years worked for each employee
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS dbo.diffyear;
GO 

CREATE FUNCTION dbo.diffyear
(
    @hiredate DATE
)
RETURNS  nvarchar(20)
AS
BEGIN
    DECLARE @Result  nvarchar(20)
    SELECT @RESULT = DATEDIFF(year, @hiredate, getdate())
    RETURN @RESULT
END;
GO

SELECT O.EmployeeId, dbo.diffyear(E.HireDate) AS [Years Worked]
FROM Sales.Customer AS C
    CROSS JOIN HumanResources.Employee AS E
    CROSS JOIN Sales.[Order] AS O
WHERE C.CustomerId = (
    SELECT O.CustomerId
    WHERE E.EmployeeId = O.EmployeeId
)
GROUP BY O.EmployeeId, dbo.diffyear(E.HireDate)
ORDER BY O.EmployeeId;

/* Problem 20:
returns custid, emplyid, orderid and the season of the orders
using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.Season;
GO
CREATE FUNCTION Sales.Season
(
    @date DATE
)
RETURNS nvarchar(20)
AS
BEGIN
    DECLARE @Result nvarchar(20);
    DECLARE @Month INT = MONTH(@date);

    SELECT @Result = CASE
        WHEN @Month IN (12,1,2) THEN 'Winter'
        WHEN @Month BETWEEN 3 AND 5 THEN 'Spring'
        WHEN @Month BETWEEN 6 AND 8 THEN 'Summer'
        WHEN @Month BETWEEN 9 AND 11 THEN 'Autumn'
        ELSE 'ERROR - CANNOT CALCULATE Season'
    END;

    RETURN @Result
END;
GO

SELECT C.customerid, E.employeeid, O.OrderId, Sales.Season(O.orderdate) AS [Order Season]
FROM Sales.Customer AS C
    CROSS JOIN HumanResources.Employee AS E
    CROSS JOIN Sales.[Order] AS O
WHERE C.CustomerId = (
    SELECT O.CustomerId
    WHERE E.EmployeeId = O.EmployeeId
)
GROUP BY C.customerid, E.employeeid, O.OrderId, Sales.Season(O.orderdate);

------------------------------------

------------------------
--top queries
------------------------
/*
-problem 4 // sorted by order key
-problem 7 // uses an inner join rather than cross join
-problem 20 // only scalar function that does something a built in function could not
*/
------------------------
--worst queries 
-- + corrections
------------------------
/*
-problem 2 // can use a concat function to do so
corrected, simplier, query:
*/

USE AdventureWorksDW2017;
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, BirthDate
FROM dbo.DimEmployee;

/*
-problem 11 // can use an inner join to replace the cross join and subquery
corrected, simplier, query:
*/

USE Northwinds2022TSQLV7;
SELECT CO.CustomerID, O.EmployeeId, YEAR(CO.Ordermonth) AS [Year]
FROM Sales.[Order] AS O
   INNER JOIN Sales.uvw_CustomerOrder AS CO
    ON CO.CustomerID = O.CustomerID
GROUP BY CO.CustomerID, O.EmployeeId, YEAR(CO.Ordermonth)
ORDER BY CO.CustomerID, O.EmployeeId;

/*
-problem 14 // can use a built in function for full name, also can use inner joins to replace the cross join and subquery
corrected, simplier, query:
*/

USE Northwinds2022TSQLV7;
SELECT O.OrderId, C.CustomerId, E.EmployeeId, CONCAT(E.EmployeeFirstName, ' ', E.EmployeeLastName) AS [NAME]
FROM Sales.Customer AS C
    INNER JOIN Sales.[Order] AS O
     ON C.CustomerId = O.CustomerId 
    INNER JOIN HumanResources.Employee AS E
     ON E.EmployeeId = O.EmployeeId
GROUP BY O.OrderId, C.CustomerId, E.EmployeeId, CONCAT(E.EmployeeFirstName, ' ', E.EmployeeLastName);