/*
	Problem 01: For different orders and individual products in it show the product name, non discounted sale, discount amount and order ID from the AdventureWorks2017 database. (Simple)
	
*/
USE [AdventureWorks2017];
GO

SELECT p.Name AS ProductName
	,NonDiscountSales = (OrderQty * UnitPrice)
	,Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)
	,sod.SalesOrderID
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
ORDER BY ProductName DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Non-discounted prices and discount amount'), INCLUDE_NULL_VALUES;
/*
	Problem 02: From AdventureWorks2017 display  total selling prices for all the products grouping by their special offer, along with the productid, product name and description, quantity sold per offer type, average price. (Complex) 
*/
USE [AdventureWorks2017];
GO

SELECT S.ProductID
	,p.[Name]
	,S.SpecialOfferID
	,SO.[Description]
	,COUNT([OrderQty]) AS [Count]
	,(AVG(UnitPrice)) AS [Average Price]
	,STR(SUM(LineTotal)) AS SubTotal
FROM Sales.SalesOrderDetail AS S
INNER JOIN [Sales].[SpecialOffer] AS SO ON SO.[SpecialOfferID] = S.SpecialOfferID
INNER JOIN [Production].[Product] AS p ON p.[ProductID] = S.ProductID
GROUP BY S.ProductID
	,p.[Name]
	,S.SpecialOfferID
	,SO.[Description]
ORDER BY S.ProductID
	,[Count] DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Sale Report by offertype'), INCLUDE_NULL_VALUES;
/*
	Problem 03:  Show all the products and their average price that were sold more than 10 times in 2014.(simple)
*/
USE AdventureWorks2017;
GO

SELECT sod.ProductID
	,CAST(AVG(sod.UnitPrice) AS DECIMAL(18, 2)) AS [Average Price] --, YEAR(soh.OrderDate) as [Year]
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Sales.SalesOrderHeader AS soh ON soh.SalesOrderID = sod.SalesOrderID
WHERE OrderQty > 10
	AND YEAR(soh.OrderDate) = '2014'
GROUP BY ProductID --, YEAR(soh.OrderDate)
ORDER BY [Average Price] DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('AdventureWorks2017 10+ sold products'), INCLUDE_NULL_VALUES;
/*
	Problem 04:  For each category and sub category of products show the total sales made for each quarter in 2013. (Complex)
*/
USE AdventureWorks2017;
GO

SELECT PC.Name AS Category
	,PS.Name AS Subcategory
	,DATEPART(yy, SOH.OrderDate) AS [Year]
	,'Q' + DATENAME(qq, SOH.OrderDate) AS [Qtr]
	,STR(SUM(DET.UnitPrice * DET.OrderQty)) AS [$ Sales]
FROM Production.ProductSubcategory AS PS
INNER JOIN Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail DET 
	ON SOH.SalesOrderID = DET.SalesOrderID
INNER JOIN Production.Product AS P 
	ON DET.ProductID = P.ProductID 
	ON PS.ProductSubcategoryID = P.ProductSubcategoryID 
INNER JOIN Production.ProductCategory AS PC 
	ON PS.ProductCategoryID = PC.ProductCategoryID 
WHERE YEAR(SOH.OrderDate) = '2013'
GROUP BY DATEPART(yy, SOH.OrderDate)
	,PC.Name
	,PS.Name
	,'Q' + DATENAME(qq, SOH.OrderDate)
	,PS.ProductSubcategoryID
ORDER BY Category
	,SubCategory
	,[Qtr];


-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Products sold per quarter 2013'), INCLUDE_NULL_VALUES;
/*
	Problem 05:  Show total money made per territory for years 2011-2014(inclusive) and show total money for all 4 years as well.
	( shows warnings: Warning: Null value is eliminated by an aggregate or other SET operation.)(simple)
*/
USE AdventureWorks2017;
GO

SELECT [Name]
	,CAST(SUM(CASE 
				WHEN YEAR([OrderDate]) = 2011
					THEN ([SubTotal])
				END) AS DECIMAL(18, 2)) AS [2011]
	,CAST(SUM(CASE 
				WHEN YEAR([OrderDate]) = 2012
					THEN ([SubTotal])
				END) AS DECIMAL(18, 2)) AS [2012]
	,CAST(SUM(CASE 
				WHEN YEAR([OrderDate]) = 2013
					THEN ([SubTotal])
				END) AS DECIMAL(18, 2)) AS [2013]
	,CAST(SUM(CASE 
				WHEN YEAR([OrderDate]) = 2014
					THEN ([SubTotal])
				END) AS DECIMAL(18, 2)) AS [2014]
	,CAST(SUM([SubTotal]) AS DECIMAL(18, 2)) AS Total
FROM [Sales].[SalesOrderHeader] AS S
INNER JOIN [Sales].[SalesTerritory] AS T ON T.[TerritoryID] = S.TerritoryID
GROUP BY [Name]
ORDER BY [Name];

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Report per territory 2011-14'), INCLUDE_NULL_VALUES;
/*
	Problem 06:  Find the parts that need to be restocked.(medium)
*/
USE AdventureWorks2017;
GO

SELECT s.[ProductSubcategoryID]
	,s.[Name]
	,p.[Name]
	,p.[ProductNumber]
	,p.[SafetyStockLevel]
	,p.[ReorderPoint]
	,inv.[Quantity]
	,inv.Shelf
	,inv.Bin
FROM [Production].[Product] AS p
INNER JOIN [Production].[ProductInventory] AS inv ON p.[ProductID] = inv.[ProductID]
INNER JOIN [Production].[ProductSubcategory] AS s ON s.ProductCategoryID = p.ProductSubcategoryID
WHERE inv.[Quantity] < p.[ReorderPoint]
	AND p.ProductSubcategoryID IS NOT NULL
ORDER BY s.[ProductSubcategoryID];


-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Restock), INCLUDE_NULL_VALUES;
/*
	Problem 7: Make a performance analysis report for the employees. (complex)
*/
USE AdventureWorks2017;
GO

SELECT CONCAT (
		[FirstName]
		,+ ' '
		,+ [LastName]
		) AS Employee
	,t.[TerritoryID]
	,t.[Name] AS [Territory]
	,s.SalesLastYear AS [Emp Sales Last Year]
	,[SalesQuota] AS [Emp Sales Quota]
	,s.SalesYTD AS [Emp Sales YTD]
	,[Bonus] AS [Emp Bonus]
	,[CommissionPct] AS [Emp Commission%]
	,[HireDate]
	,[MaritalStatus]
	,t.[SalesLastYear] AS [Territory Sales Last Year]
	,t.[SalesYTD] AS [Territory Sales YTD]
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN Sales.SalesPerson AS s ON s.BusinessEntityID = e.BusinessEntityID
INNER JOIN [Sales].[SalesTerritory] AS t ON t.[TerritoryID] = s.TerritoryID
ORDER BY TerritoryID;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Employee Performance Report), INCLUDE_NULL_VALUES;
/*
	Problem 8: Show how many orders made by each customers.
*/
USE AdventureWorks2017;
GO

SELECT s.CustomerID
	,p.FirstName + ' ' + p.LastName AS Name
	,COUNT(so.SalesOrderDetailID) AS [Count]
FROM Sales.Customer s
JOIN Person.Person p ON s.PersonID = p.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader h ON h.CustomerID = s.CustomerID
LEFT JOIN Sales.SalesOrderDetail so ON so.SalesOrderID = h.SalesOrderID
GROUP BY s.CustomerID
	,p.FirstName + ' ' + p.LastName
ORDER BY s.CustomerID;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Customer Order Count), INCLUDE_NULL_VALUES;
/*
	Problem 9: Find the best selling item by value
*/
USE AdventureWorks2017;
GO

SELECT p.Name
	,SUM(sod.OrderQty * sod.UnitPrice) AS [Total Sale Value]
FROM [Production].[Product] AS p
JOIN [Sales].[SalesOrderDetail] AS sod ON p.ProductID = sod.ProductID
GROUP BY p.Name
ORDER BY [Total Sale Value] DESC;

/*
	Problem 10: List the ProductName and the quantity of what was ordered by the french territory(medium)
	
*/
USE AdventureWorks2017;

SELECT [Production].[Product].Name
	,SalesOrderDetail.OrderQty
FROM [Sales].[Customer]
JOIN [Sales].[SalesOrderHeader] ON Customer.CustomerID = SalesOrderHeader.CustomerID
JOIN [Sales].[SalesOrderDetail] ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
JOIN [Production].[Product] ON SalesOrderDetail.ProductID = Product.ProductID
WHERE Customer.TerritoryID = (
		SELECT TerritoryID
		FROM [Sales].[SalesTerritory]
		WHERE Name = N'France'
		);

/*
	Problem 11: Show all for how many years the employees has been hired for and their pay rates.
	(Complex)Best Query: Ineresting problem, easily readable
*/
USE AdventureWorks2017;
GO
DROP FUNCTION IF EXISTS dbo.Worklength;
GO
	CREATE FUNCTION dbo.Worklength (@hired DATE)
	RETURNS INT
	AS
	BEGIN
		DECLARE @length INT;

		SELECT @length = DATEDIFF(year, @hired, GETDATE())
		FROM HumanResources.Employee
		WHERE HireDate = @hired

		RETURN @length;
	END;
GO
SELECT CONCAT (
		P.FirstName
		,' '
		,P.LastName
		) AS [Name]
	,H.Rate
	,dbo.Worklength(E.HireDate) AS [Total Years]
FROM HumanResources.Employee AS E
INNER JOIN Person.Person AS P ON E.BusinessEntityID = P.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory AS H ON E.BusinessEntityID = H.BusinessEntityID
ORDER BY dbo.Worklength(E.HireDate)
	,H.Rate
	,P.LastName;
	-- FOR JSON PATH, ROOT('Emplyee details'), INCLUDE_NULL_VALUES;
DROP FUNCTION IF EXISTS dbo.Worklength;
/* 
	Problem 12: Find top 5 money making product purcahsed by married customers who has more than one child.(Complex)
	
*/
USE AdventureWorksDW2017;
GO

WITH MarriedCustomer
AS (
	SELECT P.EnglishProductName AS [Product]
		,COUNT(P.EnglishProductName) AS Quantity
		,AVG(I.SalesAmount) AS Price
	FROM dbo.FactInternetSales AS I
	INNER JOIN dbo.DimCustomer AS C ON I.CustomerKey = C.CustomerKey
	INNER JOIN dbo.DimProduct AS P ON I.ProductKey = P.ProductKey
	WHERE C.MaritalStatus = N'M'
		AND C.TotalChildren > 1
	GROUP BY P.EnglishProductName
	)
SELECT TOP (5) Product AS [Product Name]
	,Sum(Quantity * Price) AS Total
FROM MarriedCustomer
GROUP BY Product
ORDER BY Total DESC;
GO

/*
	Problem 13: Find the top 5 spending customers. (Complex)
	best query: reduces inner query
*/
USE Northwinds2022TSQLV7;
GO

DROP FUNCTION IF EXISTS dbo.TotalSpent;
GO

CREATE FUNCTION dbo.TotalSpent (@name AS VARCHAR(50))
RETURNS NUMERIC(18, 2)
AS
BEGIN
	DECLARE @total FLOAT

	SELECT @total = SUM(OD.unitprice * OD.Quantity)
	FROM Sales.[Order] AS O
	INNER JOIN Sales.OrderDetail AS OD ON O.orderid = OD.orderid
	INNER JOIN Sales.Customer AS C ON O.CustomerId = C.CustomerId
	WHERE C.CustomerContactName = @name

	RETURN @total;
END;

GO

SELECT TOP 5 C.CustomerContactName AS [Name]
	,dbo.TotalSpent(C.CustomerContactName) AS [Total Spent]
	,O.ShipToCity AS City
FROM Sales.[Order] AS O
INNER JOIN Sales.OrderDetail AS OD ON O.orderid = OD.orderid
INNER JOIN Sales.Customer AS C ON O.CustomerId = C.CustomerId
GROUP BY C.CustomerContactName
	,O.ShipToCity
ORDER BY [Total Spent] DESC;
--FOR JSON PATH, ROOT('Top 5 customers'), INCLUDE_NULL_VALUES;
GO

DROP FUNCTION IF EXISTS dbo.TotalSpent;
GO


	/*
	worst
	Problem 14: For customers in WideWorldDW find out for the customers who bought developer joke mug, how many have they purchased? (medium)
*/
USE WideWorldImportersDW;
GO

SELECT C.[Primary Contact] AS [Customer]
	,COUNT(C.[Primary Contact]) AS [Number of Mugs]
FROM Fact.[Order] AS O
INNER JOIN Dimension.Customer AS C ON C.[Customer Key] = O.[Customer Key]
WHERE O.[Description] LIKE N'%Developer joke mug%'
GROUP BY C.[Primary Contact]
ORDER BY COUNT(C.[Primary Contact]) DESC;
--FOR JSON PATH, ROOT('Dev Joke Mug'), INCLUDE_NULL_VALUES;


--corrected
USE WideWorldImportersDW;
GO

SELECT C.[Primary Contact] AS [Customer]
	,COUNT(C.[Primary Contact]) AS [Number of Mugs]
FROM Fact.[Order] AS O
INNER JOIN Dimension.Customer AS C ON C.[Customer Key] = O.[Customer Key]
WHERE C.[Customer Key] != 0
	AND Lower(O.[Description]) LIKE (LOWER(N'%Developer joke mug%'))
GROUP BY C.[Primary Contact]
ORDER BY COUNT(C.[Primary Contact]) DESC;
--FOR JSON PATH, ROOT('Dev Joke Mug'), INCLUDE_NULL_VALUES;
/*
	Problem 15: Find the number of parents in every region for the AdventureWorksDW2017. (medium)
*/
USE AdventureWorksDW2017;
GO

SELECT G.EnglishCountryRegionName AS [Country]
	,COUNT(G.EnglishCountryRegionName) AS [Number of Parents]
FROM dbo.DimCustomer AS C
INNER JOIN dbo.DimGeography AS G ON C.GeographyKey = G.GeographyKey
WHERE C.TotalChildren > 0
GROUP BY G.EnglishCountryRegionName
ORDER BY COUNT(G.EnglishCountryRegionName);

/*
	Problem 16: Find all the estimated delivery from the WideWorldImporters where the customer is a toy store.(simple)
*/
USE WideWorldImporters;
GO

SELECT C.CustomerName AS [Customer Name]
	,O.ExpectedDeliveryDate AS [Expected Delivery Date]
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O ON C.CustomerId = O.CustomerId
WHERE DATEDIFF(day, O.orderdate, O.ExpectedDeliveryDate) > 1
	AND O.orderdate >= '20130101'
	AND O.orderdate < '20130201'
	AND C.CustomerName LIKE '%toys%'
ORDER BY O.ExpectedDeliveryDate;

/* 
	Problem 17: Find information about all the customers who purchased white mug/s in February. (medium)
	worst
*/
USE WideWorldImportersDW;

SELECT S.[SalesPerson Key] AS [Salesperson Key]
	,C.[Customer]
	,O.Quantity
	,O.[Order Date Key]
FROM Fact.[Order] AS O
INNER JOIN Dimension.Customer AS C ON C.[Customer Key] = O.[Customer Key]
INNER JOIN Fact.Sale AS S ON S.[SalesPerson Key] = O.[SalesPerson Key]
WHERE C.[Customer Key] != 0
	AND O.[Description] LIKE N'%mug%%white%'
	AND MONTH(O.[Order Date Key]) = 2
GROUP BY S.[SalesPerson Key]
	,C.[Customer]
	,O.Quantity
	,O.[Order Date Key]
ORDER BY S.[SalesPerson Key]
	,O.[Order Date Key];
--FOR JSON PATH, ROOT('WhiteMug'), INCLUDE_NULL_VALUES;
-- corrected
USE WideWorldImportersDW;

SELECT S.[SalesPerson Key] AS [Salesperson Key]
	,C.[Customer]
	,O.Quantity
	,O.[Order Date Key]
FROM Fact.[Order] AS O
INNER JOIN Dimension.Customer AS C ON C.[Customer Key] = O.[Customer Key]
INNER JOIN Fact.Sale AS S ON S.[SalesPerson Key] = O.[SalesPerson Key]
WHERE C.[Customer Key] != 0
	AND O.[Description] LIKE N'%mug%'
	AND O.[Description] LIKE N'%white%'
	AND MONTH(O.[Order Date Key]) = 2
GROUP BY S.[SalesPerson Key]
	,C.[Customer]
	,O.Quantity
	,O.[Order Date Key]
ORDER BY S.[SalesPerson Key]
	,O.[Order Date Key];

/* 
	Problem 18: From WideWorldImporters find the regular customers who has average transaction amount above -5000 for the last 3 months of 2015.
	(medium)(worst)
*/
USE WideWorldImporters;

SELECT C.CustomerName AS [Customer Name]
	,AVG(T.TransactionAmount) AS [Average Transaction]
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O ON C.CustomerId = O.CustomerId
INNER JOIN Sales.CustomerTransactions AS T ON C.CustomerId = T.CustomerId
WHERE T.TaxAmount = 0
	AND O.OrderDate >= '20151001'
	AND O.Orderdate < '20160101'
	AND C.CustomerName NOT LIKE N'Wingtip%'
	AND C.CustomerName NOT LIKE N'Tailspin%'
GROUP BY C.CustomerName
HAVING AVG(T.TransactionAmount) > - 5000
ORDER BY AVG(T.TransactionAmount)
--FOR JSON PATH, ROOT('Regular Customer Transaction'), INCLUDE_NULL_VALUES
;

--corrected
USE WideWorldImporters;

SELECT C.CustomerName AS [Customer Name]
	,AVG(T.TransactionAmount) AS [Average Transaction]
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O ON C.CustomerId = O.CustomerId
INNER JOIN Sales.CustomerTransactions AS T ON C.CustomerId = T.CustomerId
WHERE T.TaxAmount = 0
	AND O.OrderDate >= '20151001'
	AND O.Orderdate < '20160101'
	AND LOWER(C.CustomerName) NOT LIKE N'toys%'
GROUP BY C.CustomerName
HAVING AVG(T.TransactionAmount) > - 5000
ORDER BY AVG(T.TransactionAmount);
/* 
	Problem 19: Based on education level show how many "skilled manual" owns 3 or more cars (simple)
*/
USE AdventureWorksDW2017;
GO

SELECT C.EnglishEducation AS [Education Level]
	,COUNT(C.EnglishOccupation) AS [Count]
FROM dbo.DimCustomer AS C
INNER JOIN dbo.DimGeography AS G ON C.GeographyKey = G.GeographyKey
WHERE G.EnglishCountryRegionName = N'United States'
	AND C.NumberCarsOwned >= 3
GROUP BY C.EnglishEducation
ORDER BY C.EnglishEducation;

/* 
	Problem 20: Write a function that returns the number of products with highest unitprice from Northwinds2022TSQLV7. (complex)
*/

USE Northwinds2022TSQLV7;
GO

DROP FUNCTION

IF EXISTS Production.TopProducts;GO
	CREATE FUNCTION Production.TopProducts (
		@supid AS INT
		,@n AS INT
		)
	RETURNS TABLE
	AS
	RETURN

	SELECT TOP (@n) ProductId
		,ProductName
		,UnitPrice
	FROM Production.Product
	WHERE SupplierId = @supid
	ORDER BY UnitPrice DESC;
GO

SELECT *
FROM Production.TopProducts(5, 2)
GO

DROP FUNCTION

IF EXISTS Production.TopProducts;GO


