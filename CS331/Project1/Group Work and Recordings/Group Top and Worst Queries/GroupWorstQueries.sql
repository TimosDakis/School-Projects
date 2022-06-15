/*
	Group Worst #1: From WideWorldImporters find the regular customers who has average transaction amount above -5000 for the last 3 months of 2015
	Complexity: Medium
	Written by: Mikhaiel Gomes
	Reasoning: From the REGEX clauses it is not apparent why the Wingtip and Tailspin are being avoided.

*/

USE WideWorldImporters;

SELECT C.CustomerName AS [Customer Name],
       AVG(T.TransactionAmount) AS [Average Transaction]
FROM Sales.Customers AS C
    INNER JOIN Sales.Orders AS O
        ON C.CustomerID = O.CustomerID
    INNER JOIN Sales.CustomerTransactions AS T
        ON C.CustomerID = T.CustomerID
WHERE T.TaxAmount = 0
      AND O.OrderDate >= '20151001'
      AND O.OrderDate < '20160101'
      AND C.CustomerName NOT LIKE N'Wingtip%'
      AND C.CustomerName NOT LIKE N'Tailspin%'
GROUP BY C.CustomerName
HAVING AVG(T.TransactionAmount) > -5000
ORDER BY AVG(T.TransactionAmount);
GO

/*
	Group Worst #1 - CORRECTION
	Correction: Used CTEs to improve readability and so maintainability of the Query. Removed use of a REGEX to determine what is "regular", instead check if part of group or not.
*/

USE WideWorldImporters;

WITH RegularCustomers
AS (SELECT C.CustomerID,
           C.CustomerName AS [Customer Name]
    FROM Sales.Customers AS C
    WHERE C.BuyingGroupID IS NULL),
     OrdersIn2015
AS (SELECT O.OrderID,
           O.CustomerID
    FROM Sales.Orders AS O
    WHERE DATEPART(QUARTER, O.OrderDate) = 4)
SELECT RC.[Customer Name],
       AVG(T.TransactionAmount) AS [Average Transaction]
FROM RegularCustomers AS RC
    INNER JOIN OrdersIn2015 AS O
        ON O.CustomerID = RC.CustomerID
    INNER JOIN Sales.CustomerTransactions AS T
        ON T.CustomerID = RC.CustomerID
WHERE T.TaxAmount = 0
GROUP BY RC.[Customer Name]
HAVING AVG(T.TransactionAmount) > -5000
ORDER BY AVG(T.TransactionAmount);
GO

/*
	Group Worst #2: Shows the details of all products that are priced below $100 using Northwinds2022TSQLV7
	Complexity: Medium
	Written by: Kevin Tang
	Reasoning: Uneccessary subquery, did not specify what table each column belongs to (ambiguitiy concerns), and joining is completely pointless (and use of cross join could have led to erroneous output had it utilized attributes from other table)
*/
USE Northwinds2022TSQLV7;
SELECT DISTINCT
       ProductName,
       ProductId,
       UnitPrice
FROM Production.Product
    CROSS JOIN Production.Supplier AS S
WHERE UnitPrice IN
      (
          SELECT UnitPrice FROM Production.Product WHERE UnitPrice < 100
      );
GO

/*
	Group Worst #2 - CORRECTION
	Correction: Removed join, removed subquery, much more readable and maintainable now. Also properly specified what table a column is from
*/

USE Northwinds2022TSQLV7;
SELECT P.ProductName,
       P.ProductId,
       P.UnitPrice
FROM Production.Product AS P
WHERE P.UnitPrice < 100;
GO

/*
	Group Worst #3: How much has every supplier sold using Northwinds2022TSQLV7?
	Complexity: Medium
	Written by: Timothy Dakis
	Reasoning: Use of CTE largely unneccessary, just reduces readability as opposed to improving it as is the goal with CTEs
*/

USE Northwinds2022TSQLV7;

WITH SupplierAndProduct
AS (SELECT S.SupplierId,
           P.ProductId
    FROM Production.Supplier AS S
        INNER JOIN Production.Product AS P
            ON P.SupplierId = S.SupplierId)
SELECT SP.SupplierId,
       SUM(OD.Quantity) AS TotalProductsSold
FROM SupplierAndProduct AS SP
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.ProductId = SP.ProductId
GROUP BY SP.SupplierId
ORDER BY SP.SupplierId;
GO

/*
	Group Worst #3 - CORRECTION
	Correction: Removal of CTE with just a direct 3 table join makes the query more readable
*/

USE Northwinds2022TSQLV7;

SELECT P.SupplierId,
       SUM(OD.Quantity) AS TotalProductSold
FROM Production.Supplier AS S
    INNER JOIN Production.Product AS P
        ON S.SupplierId = P.SupplierId
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.ProductId = P.ProductId
GROUP BY P.SupplierId
ORDER BY P.SupplierId;
GO