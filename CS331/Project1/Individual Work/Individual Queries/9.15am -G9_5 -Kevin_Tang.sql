

/* 
Simple Queries
Should have up to 2 tables joined. 
Tables can be physical tables or views
*/

--(1) 1 simple, finds the start and end times for the three shifts that an employee can work in
--TOP 3 (1)
USE AdventureWorks2017
SELECT S.[Name] AS [Time of Day], S.StartTime, S.EndTime
FROM HumanResources.Shift AS S
LEFT JOIN HumanResources.Employee AS E ON S.ModifiedDate = E.ModifiedDate
FOR JSON PATH, ROOT('Working Shifts');
GO

--(2) 2 simple, finds the same last names that are shared between customers and employees
USE AdventureWorksDW2017
SELECT DISTINCT DC.FirstName
FROM dbo.DimCustomer AS DC
INNER JOIN dbo.DimEmployee AS DE ON DE.LastName = DC.LastName
FOR JSON PATH, ROOT('Shared Names');
GO

--(3) 3 simple, shows the details of all employees whose ID is present in Sales.Order and HumanResources.Employee
USE Northwinds2022TSQLV7
SELECT O.OrderId, O.OrderDate, O.EmployeeId, O.ShipToAddress
FROM Sales.[Order] AS O
INNER JOIN HumanResources.Employee AS E ON O.EmployeeId = E.EmployeeId
FOR JSON PATH, ROOT('Employee IDs');
GO

--(4) 4 simple, shows the details of an order given that they are bought by the customer on the same day it is being supplied
--WORST 3 (1)
USE WideWorldImporters
SELECT DISTINCT TOP (1000) ST.TransactionDate, ST.TransactionAmount, ST.TaxAmount, ST.AmountExcludingTax
FROM Purchasing.SupplierTransactions AS ST
LEFT JOIN Sales.CustomerTransactions AS CT ON ST.TransactionDate = CT.TransactionDate
ORDER BY ST.TransactionAmount DESC
FOR JSON PATH, ROOT('Same Day Purchase');
GO

--(5) 5 simple, shows details of unique orders ordered by the quantity then by its price
USE WideWorldImportersDW
SELECT DISTINCT FS.Package, FS.Quantity, FS.[Unit Price], FS.[Tax Amount]
FROM Fact.Sale AS FS
INNER JOIN Fact.Purchase AS FP ON FS.Quantity = FP.[Ordered Quantity]
ORDER BY FS.Quantity DESC, FS.[Unit Price] DESC
FOR JSON PATH, ROOT('Products Ordered By Quantity');
GO


/* 
Medium Queries
Should have 2 to 3 tables joined and using built-in SQL functions group by summarization. 
Should include combinations of subqueries or CTE or virtual tables.
*/

--(6) 1 medium, shows all employees from USA that have had customers there
USE Northwinds2022TSQLV7
SELECT O.EmployeeId, O.CustomerId, O.OrderDate
FROM Sales.[Order] AS O
INNER JOIN Sales.Customer AS C ON O.CustomerId = C.CustomerId
WHERE EmployeeId IN (SELECT EmployeeId
						FROM HumanResources.Employee
						WHERE EmployeeCountry = N'USA')
FOR JSON PATH, ROOT('USA Orders');

--(7) 2 medium, shows the details of all products that are priced below $100
--WORST 3 (2)
USE Northwinds2022TSQLV7
SELECT DISTINCT ProductName, ProductId, UnitPrice
FROM Production.Product
CROSS JOIN Production.Supplier AS S
WHERE UnitPrice IN (SELECT UnitPrice
					FROM Production.Product
					WHERE UnitPrice < 100)
FOR JSON PATH, ROOT('Inexpensive Products');

--(8) 3 medium, Provides the details of all suppliers from the USA
USE Northwinds2022TSQLV7
SELECT DISTINCT SupplierCompanyName, SupplierCountry, SupplierId
FROM Production.Supplier
INNER JOIN Sales.Shipper ON SupplierCountry = N'USA'
FOR JSON PATH, ROOT('USA Suppliers');

--(9) 4 medium, shows the details of stock items whose quantity is less than 100
USE WideWorldImportersDW
SELECT DISTINCT S.[Stock Item], S.Size, S.[Unit Price], S.[Recommended Retail Price], D.Date
FROM Dimension.[Stock Item] AS S
CROSS JOIN Dimension.Date AS D
WHERE [Quantity Per Outer] IN (SELECT [Ordered Quantity]
					FROM Fact.Purchase
					WHERE [Ordered Quantity] < 100)
FOR JSON PATH, ROOT('Popular Items');

--(10) 5 medium, shows the customer ID as well as the year and month when they ordered
USE Northwinds2022TSQLV7
SELECT O.CustomerId, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth
FROM Sales.[Order] AS O
CROSS JOIN Sales.Customer AS C
WHERE O.CustomerId = (SELECT C.CustomerId)
GROUP BY O.CustomerId, YEAR(OrderDate), Month(OrderDate)
FOR JSON PATH, ROOT('Customer Information');

--(11) 6 medium, returns the employee ID as well as the employee country that is shared with customers
--TOP 3 (2)
USE Northwinds2022TSQLV7
SELECT HRE.EmployeeId, HRE.EmployeeCountry
FROM HumanResources.Employee AS HRE
CROSS JOIN Sales.Customer AS C
WHERE HRE.EmployeeCountry = (SELECT C.CustomerCountry)
GROUP BY HRE.EmployeeId, HRE.EmployeeCountry
FOR JSON PATH, ROOT('Same Countries of Employees and Customers');

--(12) 7 medium, returns details of customer name, ID, and year and month of ordering
USE Northwinds2022TSQLV7;
WITH CustomerInfo AS (SELECT C.CustomerContactName AS CustomerName, O.CustomerId, YEAR(O.OrderDate) AS OrderYear, MONTH(O.OrderDate) AS OrderMonth, C.CustomerCity
						FROM Sales.[Order] AS O
						CROSS JOIN Sales.Customer AS C
						WHERE C.CustomerId = O.CustomerId)
SELECT CustomerInfo.CustomerName, CustomerInfo.CustomerId, CustomerInfo.OrderYear, CustomerInfo.OrderMonth
FROM CustomerInfo
GROUP BY CustomerInfo.CustomerId, CustomerInfo.CustomerName, OrderYear, OrderMonth
FOR JSON PATH, ROOT('Customer Details');


--(13) 8 medium, returns details of employees' name, employee ID, order ID, and title 
--TOP 3 (3)
USE Northwinds2022TSQLV7
SELECT DISTINCT CONCAT(E.EmployeeFirstName, ' ', E.EmployeeLastName, ', ', E.EmployeeTitle) AS [Name And Title], O.EmployeeId, O.OrderId
FROM HumanResources.Employee AS E 
INNER JOIN Sales.[Order] AS O 
ON E.EmployeeId = (SELECT O.EmployeeId)
GROUP BY E.EmployeeLastName, E.EmployeeFirstName, O.EmployeeId, O.OrderID, E.EmployeeTitle
FOR JSON PATH, ROOT('Employee Details');

/*
Complex Queries
Should have from 3 or more tables joined, custom scalar function and use built-in SQL functions and group by summarization. 
Also include combinations of subqueries or CTE or virtual tables.
*/

--(14) 1 complex, shows the top 3 oldest employees at the company
--WORST 3 (3)
USE Northwinds2022TSQLV7;
DROP FUNCTION IF EXISTS dbo.MostRecentHires;
GO
CREATE FUNCTION dbo.MostRecentHires(@hiredate DATE)
RETURNS nvarchar(10) AS BEGIN
DECLARE @diff  nvarchar(10)
SELECT @diff = DATEDIFF(year, @hiredate, getdate())
RETURN @diff
END;
GO

SELECT TOP (3) O.EmployeeId AS [Employee ID], dbo.MostRecentHires(E.HireDate) AS [Years At Company]
FROM Sales.Customer AS C
CROSS JOIN HumanResources.Employee AS E
CROSS JOIN Sales.[Order] AS O
WHERE C.CustomerId = (SELECT O.CustomerId 
						WHERE E.EmployeeId = O.EmployeeId)
GROUP BY O.EmployeeId, dbo.MostRecentHires(E.HireDate)
ORDER BY dbo.MostRecentHires(E.HireDate) DESC
FOR JSON PATH, ROOT('Oldest Workers');


--(15) 2 complex, shows the most recent 1000 ID of an order, the customer's ID, and when they ordered it
USE Northwinds2022TSQLV7;
DROP FUNCTION IF EXISTS sales.orderdate;
GO 
CREATE FUNCTION sales.orderdate (@orderday DATE)
RETURNS nvarchar(10)
AS
BEGIN
DECLARE @part nvarchar(10)
SELECT @part = DATEPART(year, @orderday)
RETURN @part
END;
GO

SELECT TOP (1000) O.OrderId, C.CustomerID, sales.orderdate(O.OrderDate) AS [Order Year], MONTH(CO.Ordermonth) AS [Order Month]
FROM Sales.Customer AS C
CROSS JOIN Sales.uvw_CustomerOrder AS CO
CROSS JOIN Sales.[Order] AS O
WHERE CO.CustomerID = (SELECT C.CustomerID
						WHERE CO.CustomerID = O.CustomerID)
GROUP BY C.CustomerID, O.OrderId, MONTH(CO.Ordermonth), sales.orderdate(O.OrderDate)
ORDER BY O.OrderId DESC, C.CustomerID
FOR JSON PATH, ROOT('Recent Customers and Details');


--(16) 3 complex, returns the details of an order, such as its ID, the product's ID, the amount left in stock, and the year it was ordered
USE Northwinds2022TSQLV7;
DROP FUNCTION IF EXISTS Sales.OrderDate;
GO 
CREATE FUNCTION Sales.OrderDate (@OrderDay DATE)
RETURNS nvarchar(10)
AS
BEGIN
DECLARE @part nvarchar(10)
SELECT @part = DATEPART(year, @OrderDay)
RETURN @part
END;
GO

SELECT TOP (300) OD.OrderId, OD.ProductId, OD.Quantity, Sales.OrderDate(O.OrderDate) AS [OrderYear]
FROM Sales.OrderDetail AS OD
CROSS JOIN HumanResources.Employee AS E
CROSS JOIN Sales.[Order] AS O
WHERE E.EmployeeId = (SELECT O.EmployeeId
						WHERE O.OrderId = OD.OrderId)
GROUP BY OD.OrderId, OD.ProductId, OD.Quantity, Sales.OrderDate(O.OrderDate)
FOR JSON PATH, ROOT('Order Details');


--(17) 4 complex, finds the top 500 Orders and provides details of their purchase
USE Northwinds2022TSQLV7;
DROP FUNCTION IF EXISTS Sales.SeasonOfSale;
GO
CREATE FUNCTION Sales.SeasonOfSale (@date DATE)
RETURNS nvarchar(10)
AS
BEGIN
DECLARE @Result nvarchar(10);
DECLARE @Months INT = MONTH(@date);
SELECT @Result = CASE
	WHEN @Months IN (3, 4, 5) THEN 'Spring'
	WHEN @Months IN (6, 7, 8) THEN 'Summer'
	WHEN @Months IN (9, 10, 11) THEN 'Fall'
	WHEN @Months IN (1, 2, 12) THEN 'Winter'
    ELSE 'Not a month'
    END;
RETURN @Result
END;
GO

SELECT DISTINCT TOP (500) YEAR(O.OrderDate) AS [Year of Order], Sales.SeasonOfSale(O.OrderDate) AS Season, O.OrderId AS [Order ID], C.CustomerId AS [Customer ID]
FROM Sales.Customer AS C
CROSS JOIN Sales.[Order] AS O
CROSS JOIN HumanResources.Employee AS E
WHERE C.CustomerId = (SELECT O.CustomerId
						WHERE E.EmployeeId = O.EmployeeId)
GROUP BY YEAR(O.OrderDate), Sales.SeasonOfSale(O.OrderDate), O.OrderId, C.CustomerId
FOR JSON PATH, ROOT('Top 500 Purchases');

--(18) 5 complex, gives the details of a company and their revenue
USE Northwinds2022TSQLV7;
DROP FUNCTION IF EXISTS Sales.Revenue;
GO
CREATE FUNCTION Sales.Revenue (@UnitPrice AS MONEY, @Discount AS NUMERIC(10, 2))
RETURNS NUMERIC(10, 2)
AS
BEGIN
DECLARE @Result NUMERIC(10, 2) = @UnitPrice * (1.0 - @Discount);
RETURN @Result;
END;
GO

WITH CompanyDetails
AS (SELECT OD.OrderId, OD.ProductId, OD.UnitPrice, OD.DiscountPercentage, Sales.Revenue(OD.UnitPrice, OD.DiscountPercentage)
	AS Revenue
    FROM Sales.OrderDetail AS OD)
SELECT P.SupplierId AS [Supplier ID], S.SupplierCompanyName AS [Company], FORMAT(SUM(CD.Revenue), 'C') AS Revenue
FROM Production.Product AS P
INNER JOIN Production.Supplier AS S ON P.SupplierId = S.SupplierId
INNER JOIN CompanyDetails AS CD ON P.ProductId = CD.ProductId
GROUP BY P.SupplierId, S.SupplierCompanyName
FOR JSON PATH, ROOT('Company and Revenue');


--(19) 6 complex, returns 10 of the full name and ID of an employee
USE Northwinds2022TSQLV7;
DROP FUNCTION IF EXISTS HumanResources.FullName
GO 
CREATE FUNCTION HumanResources.FullName (@FirstName varchar(10),@LastName varchar(10))
RETURNS varchar(10)
AS
BEGIN
DECLARE @Result varchar(10)
SELECT @RESULT = CONCAT(@FirstName, ' ', @LastName)
RETURN @RESULT
END;
GO

SELECT DISTINCT TOP (10) HumanResources.FullName(E.EmployeeFirstName, E.EmployeeLastName) AS [Full Name], E.EmployeeId AS [Employee ID]
FROM Sales.Customer AS C
CROSS JOIN HumanResources.Employee AS E
CROSS JOIN Sales.[Order] AS O
WHERE C.CustomerId = (SELECT O.CustomerId
						WHERE E.EmployeeId = O.EmployeeId)
GROUP BY E.EmployeeId, HumanResources.FullName(E.EmployeeFirstName, E.EmployeeLastName)
FOR JSON PATH, ROOT('Employee Names and IDs');
--(20) 7 complex, returns details of customer and their order
USE Northwinds2022TSQLV7;
DROP FUNCTION IF EXISTS Sales.CustomerFullName
GO 
CREATE FUNCTION Sales.CustomerFullName (@FirstName varchar(10), @LastName varchar(10))
RETURNS varchar(10)
AS
BEGIN
    DECLARE @FullName varchar(10)
    SELECT @FullName = CONCAT(@FirstName, ' ', @LastName)
    RETURN @FullName
END;
GO

SELECT DISTINCT Sales.CustomerFullName(C.CustomerContactName, CustomerCompanyName) AS [Customer's Full Name], O.CustomerId AS [Customer ID], O.OrderId AS [Order ID], OD.ProductId AS [Product ID]
FROM Sales.Customer AS C
CROSS JOIN Sales.[Order] AS O
CROSS JOIN Sales.OrderDetail AS OD
WHERE C.CustomerId = ( SELECT O.CustomerId
						WHERE C.CustomerId = O.CustomerId)
GROUP BY O.CustomerId, O.OrderId, OD.ProductId, Sales.CustomerFullName(C.CustomerContactName, CustomerCompanyName)
FOR JSON PATH, ROOT('Customer Order and Details');


/*
Top 3 queries

Query #1 simple, extremely simple, finds the start and end times of shifts at work
Query #11 medium, very efficient because it returns employee ID and country if customers are also in the same country
Query #13 medium, uses CONCAT and INNER JOIN to combine the name and title of employees for a simpler table as well as displaying details
*/

--Worst 3 queries and fixes

--Query #4
--WORST 3 improved (1)
USE WideWorldImporters
SELECT DISTINCT TOP (1000) ST.TransactionDate, ST.TransactionAmount, ST.TaxAmount, ST.AmountExcludingTax
FROM Purchasing.SupplierTransactions AS ST, Sales.CustomerTransactions AS CT
WHERE ST.TransactionDate = CT.TransactionDate
ORDER BY ST.TransactionAmount DESC
FOR JSON PATH, ROOT('Same Day Purchase');
GO
--LEFT JOIN was unnecessary

--Query #7
--WORST 3 improved (2)
USE Northwinds2022TSQLV7
SELECT DISTINCT ProductName, ProductId, UnitPrice
FROM Production.Product
CROSS JOIN Production.Supplier AS S
WHERE UnitPrice < 100
FOR JSON PATH, ROOT('Inexpensive Products');
GO
--subquery was unnecessary

--Query #14
--WORST 3 improved (3)
USE Northwinds2022TSQLV7;
SELECT TOP (3) O.EmployeeId AS [Employee ID], dbo.MostRecentHires(E.HireDate) AS [Years At Company]
FROM HumanResources.Employee AS E
CROSS JOIN Sales.[Order] AS O
WHERE E.EmployeeId = O.EmployeeId
GROUP BY O.EmployeeId, dbo.MostRecentHires(E.HireDate)
ORDER BY dbo.MostRecentHires(E.HireDate) DESC
FOR JSON PATH, ROOT('Oldest Workers');
GO
--Having two CROSS JOINs was not necessary
