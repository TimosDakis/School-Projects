--Simple Query 1
--Using WideWorldImportersDW, display the employees whose names begin with T and are SalesPeople
USE WideWorldImportersDW;

SELECT DISTINCT E.Employee
	,E.[Is Salesperson]
FROM [Dimension].[Employee] AS E
WHERE E.Employee LIKE N'T%'
	AND E.[Is Salesperson] = 1;
--FOR JSON PATH, ROOT('T SalesPeople'), INCLUDE_NULL_VALUES;
GO


--Simple Query 2 'Top': Efficient and Easy to Read
--Using Northwinds2022TSQLV7, display orders with the total value be less than 15000
USE Northwinds2022TSQLV7;

SELECT D.OrderId
	,SUM(D.Quantity * D.UnitPrice) AS Total
FROM [Sales].[OrderDetail] AS D
GROUP BY D.OrderId
HAVING SUM(D.Quantity * D.UnitPrice) < 15000
ORDER BY Total DESC;
--FOR JSON PATH, ROOT('Total Value less than 15000'), INCLUDE_NULL_VALUES;
GO


--Simple Query 3 
--Using AdventureWorks2017, display all order information, including product id and quantity 
USE AdventureWorks2017;

SELECT C.CustomerId
	,D.SalesOrderId
	,D.ProductId
	,D.OrderQty
FROM [Sales].[Customer] AS C
JOIN [Sales].[SalesOrderHeader] AS H ON C.CustomerID = H.CustomerID
JOIN [Sales].[SalesOrderDetail] AS D ON H.SalesOrderID = D.SalesOrderID;
--FOR JSON PATH, ROOT('All order info'), INCLUDE_NULL_VALUES;
GO


--Simple Query 4  'Worst': Can be written much easier and have a simpler output
--Using AdventureWorks2017, display the order that has the highest orderid
USE AdventureWorks2017;

SELECT MAX(H.SalesOrderId)
	,H.OrderDate
	,H.CustomerId
FROM [Sales].[SalesOrderHeader] AS H
GROUP BY H.OrderDate
	,H.CustomerID
ORDER BY MAX(H.SalesOrderId) DESC;
--FOR JSON PATH, ROOT('Highest OrderId'), INCLUDE_NULL_VALUES;
GO


--Simple Query 4 FIX
USE AdventureWorks2017;

SELECT H.SalesOrderID
	,H.OrderDate
	,H.CustomerId
FROM [Sales].[SalesOrderHeader] AS H
WHERE H.SalesOrderID = (
		SELECT MAX(H2.SalesOrderId)
		FROM [Sales].[SalesOrderHeader] AS H2
		);
--FOR JSON PATH, ROOT('Highest OrderId'), INCLUDE_NULL_VALUES;
GO


--Simple Query 5
--Using AdventureWorks2017, display orders that were done after 08/01/2013, where the 
--salespersonid is equal to 276
USE AdventureWorks2017;

SELECT H.SalesOrderId
	,H.SalesPersonId
	,H.OrderDate
FROM [Sales].[SalesOrderHeader] AS H
WHERE H.OrderDate > '20130801'
	AND H.SalesPersonID IN (276);
--FOR JSON PATH, ROOT('Output'), INCLUDE_NULL_VALUES;
GO


--Medium Query 1
--Using AdventureWorks2017, display the highest total value on an item.
USE AdventureWorks2017;

WITH Product
AS (
	SELECT P.Name
		,P.ProductId
	FROM [Production].[Product] AS P
	GROUP BY P.Name
		,P.ProductId
	)
SELECT P.Name
	,SUM(D.OrderQty * D.UnitPrice) AS TotalValue
FROM Product AS P
JOIN [Sales].[SalesOrderDetail] AS D ON P.ProductID = D.ProductID
GROUP BY P.Name
ORDER BY TotalValue DESC;
--FOR JSON PATH, ROOT('Highest Total Value on Item'), INCLUDE_NULL_VALUES;
GO


--Medium Query 2  'Worst': Could possibly be written more efficiently 
--Using AdventureWorks2017, display how many 'silver' products have been sold
--to an address that is located in 'New York" (city).
USE AdventureWorks2017;

WITH Product
AS (
	SELECT P.ProductId
		,P.Color
	FROM [Production].[Product] AS P
	WHERE P.Color = 'silver'
	)
SELECT SUM(D.OrderQty) AS SilverTotal
FROM Product AS P
JOIN [Sales].[SalesOrderDetail] AS D ON P.ProductID = D.ProductID
JOIN [Sales].[SalesOrderHeader] AS H ON D.SalesOrderId = H.SalesOrderID
JOIN [Person].[Address] AS A ON H.ShipToAddressID = A.AddressID
WHERE A.City = 'New York';
--FOR JSON PATH, ROOT('Silver Output'), INCLUDE_NULL_VALUES;
GO

--Medium Query 2 FIX
USE AdventureWorks2017;

WITH Product
AS (
	SELECT P.ProductId
		,P.Color
	FROM [Production].[Product] AS P
	WHERE P.Color = 'silver'
	)
	,City
AS (
	SELECT A.AddressID
		,A.City
	FROM [Person].[Address] AS A
	WHERE A.City = 'New York'
	)
SELECT SUM(D.OrderQty) AS SilverTotal
FROM Product AS P
JOIN [Sales].[SalesOrderDetail] AS D ON P.ProductID = D.ProductID
JOIN [Sales].[SalesOrderHeader] AS H ON D.SalesOrderId = H.SalesOrderID
JOIN City AS A ON H.ShipToAddressID = A.AddressID;
--FOR JSON PATH, ROOT('Silver Output'), INCLUDE_NULL_VALUES;
GO


--Medium Query 3
--Using AdventureWorks2017, display all of the size  'L' products ordered
USE AdventureWorks2017;

WITH Product
AS (
	SELECT P.Name
		,P.ProductID
	FROM [Production].[Product] AS P
	WHERE P.Size = 'L'
	GROUP BY P.Name
		,P.ProductID
	)
SELECT P.Name
	,SUM(D.OrderQty)
FROM Product AS P
LEFT OUTER JOIN [Sales].[SalesOrderDetail] AS D ON P.ProductId = D.ProductID
GROUP BY P.Name;
--FOR JSON PATH, ROOT('L Output'), INCLUDE_NULL_VALUES;
GO


--Medium Query 4
--Using WideWorldImporters, display all orders and customers that had an expected delivery in the month of March 2014
USE WideWorldImporters;

WITH MasterDate
AS (
	SELECT O.OrderId
		,O.ExpectedDeliveryDate AS DeliveryDate
		,O.CustomerID
	FROM [Sales].[Orders] AS O
	WHERE MONTH(O.ExpectedDeliveryDate) = '03'
		AND YEAR(O.ExpectedDeliveryDate) = '2014'
	)
SELECT C.CustomerId
	,C.CustomerName
	,O.OrderId
	,O.DeliveryDate
FROM [Sales].[Customers] AS C
INNER JOIN MasterDate AS O ON O.CustomerID = C.CustomerID
ORDER BY O.DeliveryDate;
--FOR JSON PATH, ROOT('Expected Delivery Output'), INCLUDE_NULL_VALUES;
GO


-- Medium Query 5
--Using NorthWinds2022TSQLV7, display the total order value for each country.
USE Northwinds2022TSQLV7;

WITH Country
AS (
	SELECT O.ShipToCountry AS Country
		,O.OrderId
	FROM [Sales].[Order] AS O
	GROUP BY O.ShipToCountry
		,O.OrderId
	)
SELECT O.Country
	,SUM(D.UnitPrice * D.Quantity)
FROM Country AS O
JOIN [Sales].[OrderDetail] AS D ON O.OrderId = D.OrderId
GROUP BY O.Country
ORDER BY SUM(D.UnitPrice * D.Quantity) DESC;
--FOR JSON PATH, ROOT('Each Country Output'), INCLUDE_NULL_VALUES;
GO


--Medium Query 6   'Top': Efficient and easy to read
--Using AdventureWorksDW2017, display every employee(oldest to youngest) who's birthday is in July.
USE AdventureWorksDW2017;

WITH MonthName
AS (
	SELECT D.EnglishMonthName AS Month
		,D.MonthNumberOfYear AS MonthNum
	FROM [dbo].[DimDate] AS D
	GROUP BY D.EnglishMonthName
		,D.MonthNumberOfYear
	)
SELECT DISTINCT E.LastName
	,E.FirstName
	,D.Month
	,DAY(E.BirthDate) AS Day
	,YEAR(E.BirthDate) AS Year
FROM [dbo].[DimEmployee] AS E
JOIN MonthName AS D ON MONTH(E.BirthDate) = D.MonthNum
WHERE MONTH(E.BirthDate) = 7
ORDER BY Year
	,Day
--FOR JSON PATH, ROOT('Birthday Output'), INCLUDE_NULL_VALUES;
GO


--Medium Query 7
--Using Northwinds2022TSQLV7, display the total orders performed by employees
USE Northwinds2022TSQLV7;

WITH C1
AS (
	SELECT COUNT(E.EmployeeId) AS OrdersPerformed
		,E.EmployeeFirstName AS FirstName
		,E.EmployeeLastName AS LastName
		,E.EmployeeId
	FROM [HumanResources].[Employee] AS E
	GROUP BY E.EmployeeFirstName
		,E.EmployeeLastName
		,E.EmployeeId
	)
	,C2
AS (
	SELECT E.OrdersPerformed
		,E.FirstName
		,E.LastName
		,E.EmployeeId
	FROM C1 AS E
	)
SELECT E.FirstName
	,E.LastName
	,COUNT(OrdersPerformed) AS OrdersPerformed
FROM C2 AS E
JOIN [Sales].[Order] AS O ON E.EmployeeId = O.EmployeeId
GROUP BY E.FirstName
	,E.LastName
	,E.OrdersPerformed
ORDER BY OrdersPerformed DESC;
--FOR JSON PATH, ROOT('Employee Output'), INCLUDE_NULL_VALUES;
GO


--Medium Query 8
--Using Northwinds2022TSQLV7, display how many orders were placed in France, as well as the total value
USE Northwinds2022TSQLV7;

WITH Total
AS (
	SELECT SUM(D.UnitPrice * D.Quantity) AS TotalSpent
		,D.OrderId
	FROM [Sales].[OrderDetail] AS D
	GROUP BY D.OrderId
	)
SELECT O.ShipToCountry AS Country
	,COUNT(O.OrderId) AS NumberOfOrders
	,SUM(D.TotalSpent) AS TotalSpent
FROM [Sales].[Order] AS O
JOIN Total AS D ON O.OrderId = D.OrderId
WHERE O.ShipToCountry = 'France'
GROUP BY O.ShipToCountry;
--FOR JSON PATH, ROOT('France Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 1
--Using AdventureWorks2017, display the total sales per month in the state id of 54.
USE AdventureWorks2017;

DROP FUNCTION

IF EXISTS getStateId;GO
	CREATE FUNCTION getStateId (@prvid AS INT)
	RETURNS TABLE
	AS
	RETURN

	SELECT AddressId
		,AddressLine1
		,AddressLine2
		,City
		,StateProvinceId
		,PostalCode
		,SpatialLocation
		,rowguid
		,ModifiedDate
	FROM [Person].[Address]
	WHERE StateProvinceID = @prvid;
GO

WITH DATE
AS (
	SELECT H.OrderDate AS SalesYear
		,H.OrderDate AS SalesMonth
		,H.SalesOrderId AS ID
		,H.ShipToAddressID AS ShipId
	FROM [Sales].[SalesOrderHeader] AS H
	)
SELECT YEAR(H.SalesYear) AS SalesYear
	,MONTH(H.SalesMonth) AS SalesMonth
	,SUM(D.OrderQty * D.UnitPrice) AS TotalValue
FROM DATE AS H
JOIN [Sales].[SalesOrderDetail] AS D ON H.ID = D.SalesOrderID
JOIN getStateId(54) AS A ON H.ShipId = A.AddressID
GROUP BY H.SalesMonth
	,H.SalesYear
ORDER BY H.SalesMonth
	,H.SalesYear;
--FOR JSON PATH, ROOT('StateId Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 2
--Using AdventureWorks2017, display the top 5 most recent orders for each customer from state id 50.
USE AdventureWorks2017;

DROP FUNCTION

IF EXISTS getStateId;GO
	CREATE FUNCTION getStateId (@prvid AS INT)
	RETURNS TABLE
	AS
	RETURN

	SELECT AddressId
		,AddressLine1
		,AddressLine2
		,City
		,StateProvinceId
		,PostalCode
		,SpatialLocation
		,rowguid
		,ModifiedDate
	FROM [Person].[Address]
	WHERE StateProvinceID = @prvid;
GO

WITH Customer
AS (
	SELECT C.CustomerId
	FROM [Sales].[Customer] AS C
	)
SELECT C.CustomerId
	,T.SalesOrderId
	,T.OrderDate
FROM Customer AS C
CROSS APPLY (
	SELECT TOP (5) SalesOrderId
		,OrderDate
	FROM [Sales].[SalesOrderHeader] AS H
	JOIN getStateId(50) AS A ON H.ShipToAddressID = A.AddressID
	WHERE H.CustomerId = C.CustomerID
	ORDER BY OrderDate DESC
		,SalesOrderID DESC
	) AS T;
--FOR JSON PATH, ROOT('Recent Orders Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 3
--Using NorthWinds2022TSQLV7, display every order done by company 'JUWXK'
--and sort by year .
USE Northwinds2022TSQLV7;

DROP FUNCTION

IF EXISTS getCompanyName;GO
	CREATE FUNCTION getCompanyName (@cpy AS VARCHAR(100))
	RETURNS TABLE
	AS
	RETURN

	SELECT CustomerId
		,CustomerCompanyName
		,CustomerContactName
		,CustomerContactTitle
		,CustomerAddress
		,CustomerCity
		,CustomerRegion
		,CustomerPostalCode
		,CustomerCountry
		,CustomerPhoneNumber
		,CustomerFaxNumber
	FROM [Sales].[Customer]
	WHERE CustomerCompanyName = @cpy;
GO

WITH OrderInfo
AS (
	SELECT O.OrderDate AS Year
		,O.CustomerId
		,O.OrderId
	FROM [Sales].[Order] AS O
	)
SELECT P.ProductName
	,D.Quantity
	,YEAR(O.Year) AS Year
FROM getCompanyName('Customer JUWXK') AS C
JOIN OrderInfo AS O ON C.CustomerId = O.CustomerId
JOIN [Sales].[OrderDetail] AS D ON O.OrderId = D.OrderId
JOIN [Production].[Product] AS P ON D.ProductId = P.ProductId
GROUP BY P.ProductName
	,D.Quantity
	,Year
ORDER BY Year;
--FOR JSON PATH, ROOT('Company Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 4
--Using NorthWinds2022TSQLV7, display all customers from Canada that ordered productid 21.
USE Northwinds2022TSQLV7;

DROP FUNCTION

IF EXISTS getCountry;GO
	CREATE FUNCTION getCountry (@ctry AS VARCHAR(100))
	RETURNS TABLE
	AS
	RETURN

	SELECT CustomerId
		,CustomerCompanyName AS CompanyName
		,CustomerContactName
		,CustomerContactTitle
		,CustomerAddress
		,CustomerCity
		,CustomerRegion
		,CustomerPostalCode
		,CustomerCountry
		,CustomerPhoneNumber
		,CustomerFaxNumber
	FROM [Sales].[Customer]
	WHERE CustomerCountry = @ctry;
GO

WITH OrderInfo
AS (
	SELECT O.CustomerId
		,O.OrderId
	FROM [Sales].[Order] AS O
	)
SELECT C.CustomerId
	,C.CompanyName
FROM getCountry('Canada') AS C
WHERE EXISTS (
		SELECT *
		FROM OrderInfo AS O
		WHERE O.CustomerId = C.CustomerId
			AND EXISTS (
				SELECT *
				FROM [Sales].[OrderDetail] AS D
				WHERE D.OrderId = O.OrderId
					AND ProductId = 21
				)
		)
GROUP BY C.CustomerId
	,C.CompanyName
ORDER BY C.CustomerId;
--FOR JSON PATH, ROOT('Canada Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 5      'Worst': Difficult to read 
--Using WideWorldImporters, display the transaction id of every customer who ordered 
--where the payment was received at the end of every month in 2015
USE WideWorldImporters;

DROP FUNCTION

IF EXISTS getDte;GO
	CREATE FUNCTION getDte (@date AS INT)
	RETURNS TABLE
	AS
	RETURN

	SELECT OrderId
		,CustomerId
		,SalespersonPersonID
		,PickedByPersonID
		,ContactPersonID
		,BackorderOrderID
		,OrderDate
		,ExpectedDeliveryDate
		,CustomerPurchaseOrderNumber
		,IsUndersupplyBackordered
		,Comments
		,DeliveryInstructions
		,InternalComments
		,PickingCompletedWhen
		,LastEditedBy
		,LastEditedWhen
	FROM [Sales].[Orders]
	WHERE EOMONTH(OrderDate) = OrderDate
		AND YEAR(OrderDate) = @date;
GO

WITH TransactionName
AS (
	SELECT TT.TransactionTypeName AS Condition
		,TT.TransactionTypeId AS ID
	FROM [Application].[TransactionTypes] AS TT
	WHERE TT.TransactionTypeID = 3
	)
SELECT T.CustomerTransactionID
	,O.OrderDate
	,TT.Condition
FROM [Sales].[CustomerTransactions] AS T
JOIN getDte(2015) AS O ON T.CustomerID = O.CustomerID
JOIN TransactionName AS TT ON T.TransactionTypeID = TT.ID
GROUP BY T.CustomerTransactionID
	,O.OrderDate
	,TT.Condition
ORDER BY O.OrderDate;
--FOR JSON PATH, ROOT('Date Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 5 FIX
USE WideWorldImporters;

DROP FUNCTION

IF EXISTS getDte;GO
	CREATE FUNCTION getDte (@date AS INT)
	RETURNS TABLE
	AS
	RETURN

	SELECT CustomerId
		,OrderDate
	FROM [Sales].[Orders]
	WHERE EOMONTH(OrderDate) = OrderDate
		AND YEAR(OrderDate) = @date;
GO

WITH TransactionName
AS (
	SELECT TT.TransactionTypeName AS Condition
		,TT.TransactionTypeId AS ID
	FROM [Application].[TransactionTypes] AS TT
	WHERE TT.TransactionTypeID = 3
	)
SELECT T.CustomerTransactionID
	,O.OrderDate
	,TT.Condition
FROM [Sales].[CustomerTransactions] AS T
JOIN getDte(2015) AS O ON T.CustomerID = O.CustomerID
JOIN TransactionName AS TT ON T.TransactionTypeID = TT.ID
GROUP BY T.CustomerTransactionID
	,O.OrderDate
	,TT.Condition
ORDER BY O.OrderDate;
--FOR JSON PATH, ROOT('Date Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 6   
--Using NorthWinds2022TSQLV7, display the customers who spent the most money in 2014.
USE Northwinds2022TSQLV7;

DROP FUNCTION

IF EXISTS getDte;GO
	CREATE FUNCTION getDte (@date AS INT)
	RETURNS TABLE
	AS
	RETURN

	SELECT OrderId
		,CustomerId
		,EmployeeId
		,ShipperId
		,OrderDate
		,RequiredDate
		,ShipToDate
		,Freight
		,ShipToName
		,ShipToAddress
		,ShipToCity
		,ShipToRegion
		,ShipToPostalCode
		,ShipToCountry
		,UserAuthenticationId
		,DateAdded
		,DateOfLastUpdate
	FROM [Sales].[Order]
	WHERE YEAR(OrderDate) = @date;
GO

WITH Total
AS (
	SELECT SUM(D.Quantity * D.UnitPrice) AS Total
		,D.OrderId
	FROM [Sales].[OrderDetail] AS D
	GROUP BY D.OrderId
	)
SELECT C.CustomerCompanyName AS CompanyName
	,O.OrderDate AS DATE
	,SUM(D.Total) AS Total
FROM [Sales].[Customer] AS C
JOIN getDte(2014) AS O ON C.CustomerId = O.CustomerId
JOIN Total AS D ON O.OrderId = D.OrderId
GROUP BY C.CustomerCompanyName
	,O.OrderDate
ORDER BY Total DESC;
--FOR JSON PATH, ROOT('Most Money Output'), INCLUDE_NULL_VALUES;
GO


--Complex Query 7     'Top': Easy to read and somewhat efficient
--Using Northwilds2022TSQLV7, display the customers who purchased discontinued items
USE Northwinds2022TSQLV7;

DROP FUNCTION

IF EXISTS getDiscontinued;GO
	CREATE FUNCTION getDiscontinued (@disc AS INT)
	RETURNS TABLE
	AS
	RETURN

	SELECT ProductId
		,ProductName
		,SupplierId
		,CategoryId
		,UnitPrice
		,Discontinued
	FROM [Production].[Product]
	WHERE Discontinued = @disc;
GO

WITH Ord
AS (
	SELECT O.OrderId
		,O.OrderDate AS DATE
		,O.CustomerId
	FROM [Sales].[Order] AS O
	GROUP BY O.OrderId
		,O.OrderDate
		,O.CustomerId
	)
	,Ord2
AS (
	SELECT C.CustomerCompanyName AS CompanyName
		,C.CustomerId
	FROM [Sales].[Customer] AS C
	GROUP BY C.CustomerCompanyName
		,C.CustomerId
	)
SELECT C.CompanyName
	,P.ProductId
	,O.OrderId
	,O.DATE
	,SUM(D.UnitPrice * D.Quantity) AS Paid
FROM Ord2 AS C
JOIN Ord AS O ON C.CustomerId = O.CustomerId
JOIN [Sales].[OrderDetail] AS D ON O.OrderId = D.OrderId
JOIN getDiscontinued(1) AS P ON D.ProductId = P.ProductId
GROUP BY C.CompanyName
	,P.ProductId
	,O.OrderId
	,O.DATE;
--FOR JSON PATH, ROOT('Discontinued Output'), INCLUDE_NULL_VALUES;
GO
