/*
	Problem 01 (Simple): Find all the products ordered at least once during December using Northwinds2022TSQLV7?
*/

USE Northwinds2022TSQLV7;

SELECT DISTINCT
       OD.ProductId AS ProductOrderedInDecemeber
FROM Sales.[Order] AS O
    INNER JOIN Sales.OrderDetail AS OD
        ON O.OrderId = OD.OrderId
WHERE MONTH(O.OrderDate) = 12
ORDER BY OD.ProductId;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Products Ordered in December'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 02 (Simple): What products need to be reordered (replenished) using AdventureWorks2017?
	Worst Query #1: While required, it just does not make sense to group by ReorderPoint even though it does not negatively affect outcome as ReorderPoint for each ProductId is the same
*/

USE AdventureWorks2017;

SELECT P.ProductID,
       P.ReorderPoint,
       SUM([PI].Quantity) AS CurrentStock
FROM Production.Product AS P
    INNER JOIN Production.ProductInventory AS [PI]
        ON P.ProductID = [PI].ProductID
GROUP BY P.ProductID,
         P.ReorderPoint
HAVING SUM([PI].Quantity) <= P.ReorderPoint;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Products to Restock'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 02 (Simple) - CORRECTED: What products need to be reordered (replenished) using AdventureWorks2017?
	Correction: Using a CTE makes the logical flow better and makes it mildly more readable. Also does not need to group by things it does not make sense to group by
*/

USE AdventureWorks2017;

WITH ProductInventoryStock
AS (SELECT P.ProductID,
           SUM(P.Quantity) AS CurrentStock
    FROM Production.ProductInventory AS P
    GROUP BY P.ProductID)
SELECT P.ProductID,
       P.ReorderPoint,
       S.CurrentStock
FROM Production.Product AS P
    INNER JOIN ProductInventoryStock AS S
        ON S.ProductID = P.ProductID
           AND S.CurrentStock <= P.ReorderPoint;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Products to Restock'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 03 (Simple): What country is each customer from using AdventureWorksDW2017?
*/

USE AdventureWorksDW2017;

SELECT CONCAT(C.FirstName + N' ', C.MiddleName + N' ', C.LastName) AS CustomerFullName,
       G.EnglishCountryRegionName AS CountryNameInEnglish,
       G.SpanishCountryRegionName AS CountryNameInSpanish,
       G.FrenchCountryRegionName AS CountryNameInFrench
FROM dbo.DimCustomer AS C
    INNER JOIN dbo.DimGeography AS G
        ON C.GeographyKey = G.GeographyKey
ORDER BY G.EnglishCountryRegionName;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Customer and Country'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 04 (Simple): Which customers are not part of a group (i.e. they are independent retailers) using WideWorldImporters?
*/

USE WideWorldImporters;

SELECT C.CustomerName
FROM Sales.Customers AS C
WHERE C.BuyingGroupID IS NULL;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Independent Retailers'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 05 (Simple): Which employees are salespeople using WideWorldImportersDW?
*/

USE WideWorldImportersDW;

SELECT E.Employee AS EmployeeName
FROM Dimension.Employee AS E
WHERE E.[Is Salesperson] = 1;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Salespeople'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 06 (Medium): How much of each product was ordered between January and March inclusive each year using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

WITH JanToMarchOrders
AS (SELECT O.OrderId,
           YEAR(O.OrderDate) AS OrderYear
    FROM Sales.[Order] AS O
    WHERE MONTH(O.OrderDate)
    BETWEEN 1 AND 3)
SELECT OD.ProductId,
       SUM(OD.Quantity) AS TotalQuantity,
       O.OrderYear
FROM Sales.OrderDetail AS OD
    INNER JOIN JanToMarchOrders AS O
        ON O.OrderId = OD.OrderId
GROUP BY OD.ProductId,
         O.OrderYear
ORDER BY OD.ProductId,
         O.OrderYear;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Ordered Between January and March'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 07 (Medium): How many orders did each employee handle per year, and how much revenue did those orders in each year generate after discounts using Northwinds2022TSQLV7?
*/

USE Northwinds2022TSQLV7;

WITH EmployeeTotalOrdersPerYear
AS (SELECT O.EmployeeId,
           YEAR(O.OrderDate) AS OrderYear,
           COUNT(O.OrderId) AS TotalOrders
    FROM Sales.[Order] AS O
    GROUP BY O.EmployeeId,
             YEAR(O.OrderDate)),
     EmployeeTotalRevenuePerYear
AS (SELECT O.EmployeeId,
           YEAR(O.OrderDate) AS OrderYear,
           FORMAT(SUM(OD.Quantity * OD.UnitPrice * (1.0 - OD.DiscountPercentage)), 'C') AS TotalRevenueAfterDiscount
    FROM Sales.[Order] AS O
        INNER JOIN Sales.OrderDetail AS OD
            ON OD.OrderId = O.OrderId
    GROUP BY O.EmployeeId,
             YEAR(O.OrderDate))
SELECT OY.EmployeeId,
       (
           SELECT MAX(CONCAT(E.EmployeeFirstName + ' ', E.EmployeeLastName))
           FROM HumanResources.Employee AS E
           WHERE OY.EmployeeId = E.EmployeeId
       ) AS EmployeeName,
       OY.OrderYear,
       OY.TotalOrders,
       RY.TotalRevenueAfterDiscount
FROM EmployeeTotalOrdersPerYear AS OY
    INNER JOIN EmployeeTotalRevenuePerYear AS RY
        ON RY.EmployeeId = OY.EmployeeId
           AND RY.OrderYear = OY.OrderYear;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Employee Handled Orders and Generated Revenue'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 08 (Medium): How much has every supplier sold using Northwinds2022TSQLV7?
	Worst #2: Use of CTE largely unneccessary, just reduces readability as opposed to improving it as is the goal with CTEs
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

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Supplier Product Sold'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 08 (Medium) - CORRECTED: How much has every supplier sold using Northwinds2022TSQLV7?
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

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Supplier Product Sold'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 09 (Medium): How much has revenue increased between a year and the year before for each product using Northwinds2022TSQLV7?
*/

USE Northwinds2022TSQLV7;

WITH ProductRevenueByYear
AS (SELECT OD.ProductId,
           YEAR(O.OrderDate) AS OrderYear,
           SUM(OD.Quantity * OD.UnitPrice * (1.0 - OD.DiscountPercentage)) AS TotalRevenueAfterDiscount
    FROM Sales.[Order] AS O
        INNER JOIN Sales.OrderDetail AS OD
            ON OD.OrderId = O.OrderId
    GROUP BY OD.ProductId,
             YEAR(O.OrderDate))
SELECT CurrentYear.ProductId,
       CurrentYear.OrderYear AS CurrentYear,
       FORMAT(CurrentYear.TotalRevenueAfterDiscount, 'C') AS CurrentRevenueAfterDiscount,
       FORMAT(PreviousYear.TotalRevenueAfterDiscount, 'C') AS PriorYearRevenueAfterDiscount,
       FORMAT((CurrentYear.TotalRevenueAfterDiscount - PreviousYear.TotalRevenueAfterDiscount), 'C') AS RevenueGrowth
FROM ProductRevenueByYear AS CurrentYear
    LEFT OUTER JOIN ProductRevenueByYear AS PreviousYear
        ON CurrentYear.OrderYear = PreviousYear.OrderYear + 1
           AND CurrentYear.ProductId = PreviousYear.ProductId
ORDER BY CurrentYear.ProductId,
         CurrentYear.OrderYear;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Revenue Growth Per Year'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 10 (Medium): Which 3 products are purchased most often by German customers using Northwinds2022TSQLV4?
*/

USE Northwinds2022TSQLV7;

SELECT TOP (3) WITH TIES
       [O+OD].ProductId,
       (
           SELECT MAX(P.ProductName)
           FROM Production.Product AS P
           WHERE [O+OD].ProductId = P.ProductId
       ) AS ProductName,
       COUNT([O+OD].OrderId) AS TimesOrdered
FROM Sales.Customer AS C
    INNER JOIN
    (
        SELECT O.CustomerId,
               OD.OrderId,
               OD.ProductId
        FROM Sales.[Order] AS O
            INNER JOIN Sales.OrderDetail AS OD
                ON OD.OrderId = O.OrderId
    ) AS [O+OD]
        ON [O+OD].CustomerId = C.CustomerId
WHERE C.CustomerCountry = N'Germany'
GROUP BY [O+OD].ProductId
ORDER BY COUNT([O+OD].OrderId) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Product Ordered Most Often by Germans'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 11 (Medium): How many customers are based in each country, amongst how many different cities, and how much does a customer spend on average in each country through internet orders using AdventureWorksDW2017? 
*/

USE AdventureWorksDW2017;

WITH CustomerCountryAndCity
AS (SELECT C.CustomerKey,
           G.City,
           G.EnglishCountryRegionName AS Country
    FROM dbo.DimCustomer AS C
        INNER JOIN dbo.DimGeography AS G
            ON C.GeographyKey = G.GeographyKey)
SELECT CC.Country,
       COUNT(DISTINCT CC.CustomerKey) AS TotalCustomers,
       COUNT(DISTINCT CC.City) AS NumberOfCities,
       FORMAT(SUM(S.UnitPrice * S.OrderQuantity * (1.0 - S.DiscountAmount)), 'C') AS TotalSpentPerCountry,
       FORMAT((SUM(S.UnitPrice * S.OrderQuantity * (1.0 - S.DiscountAmount))) / COUNT(DISTINCT CC.CustomerKey), 'C') AS AverageSpentPerCustomer
FROM CustomerCountryAndCity AS CC
    LEFT OUTER JOIN dbo.FactInternetSales AS S
        ON S.CustomerKey = CC.CustomerKey
GROUP BY CC.Country
ORDER BY COUNT(DISTINCT CC.CustomerKey) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Country and Average Spending per Person There'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 12 (Medium): Who are the top 5 salepeople (i.e. handled most orders) using WideWorldImporters?
*/

USE WideWorldImporters;

WITH Salespeople
AS (SELECT P.PersonID,
           P.FullName
    FROM [Application].People AS P
    WHERE P.IsSalesperson = 1)
SELECT O.SalespersonPersonID,
       S.FullName,
       COUNT(O.OrderID) AS HandledOrders
FROM Salespeople AS S
    LEFT OUTER JOIN Sales.Orders AS O
        ON O.SalespersonPersonID = S.PersonID
WHERE O.SalespersonPersonID IN
      (
          SELECT TOP (5) WITH TIES
                 O2.SalespersonPersonID
          FROM Sales.Orders AS O2
          GROUP BY O2.SalespersonPersonID
          ORDER BY COUNT(O2.OrderID) DESC
      )
GROUP BY O.SalespersonPersonID,
         S.FullName
ORDER BY COUNT(O.OrderID) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Top Salespeople'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 13 (Medium): How much revenue was generated by each gender (assuming only male/female gender) in 2015 using Northwinds2022TSQLV7
	Worst #3: The many derived tables hinder readability
*/

USE Northwinds2022TSQLV7;

SELECT E.Gender,
       FORMAT(SUM([O+OD].EmployeeRevenue), 'C') AS RevenueAfterDiscount
FROM
(
    SELECT E.EmployeeId,
           CASE
               WHEN E.EmployeeTitleOfCourtesy = N'Mr.' THEN
                   'Male'
               WHEN E.EmployeeTitleOfCourtesy IN ( N'Mrs.', N'Ms.' ) THEN
                   'Female'
               ELSE
                   'Unspecified'
           END AS Gender
    FROM HumanResources.Employee AS E
) AS E
    INNER JOIN
    (
        SELECT O.EmployeeId,
               SUM(OD.Quantity * OD.UnitPrice * (1.0 - OD.DiscountPercentage)) AS EmployeeRevenue
        FROM Sales.[Order] AS O
            INNER JOIN Sales.OrderDetail AS OD
                ON OD.OrderId = O.OrderId
        WHERE YEAR(O.OrderDate) = 2015
        GROUP BY O.EmployeeId
    ) AS [O+OD]
        ON [O+OD].EmployeeId = E.EmployeeId
GROUP BY E.Gender
ORDER BY SUM([O+OD].EmployeeRevenue) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Revenue Generated By Gender'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 13 (Medium) - CORRECTED: How much revenue was generated by each gender (assuming only male/female gender) in 2015 using Northwinds2022TSQLV7
	Correction: Used CTEs to improve readability and give it a more logical flow.
*/

USE Northwinds2022TSQLV7;

WITH EmployeeGender
AS (SELECT E.EmployeeId,
           CASE
               WHEN E.EmployeeTitleOfCourtesy = N'Mr.' THEN
                   'Male'
               WHEN E.EmployeeTitleOfCourtesy IN ( N'Mrs.', N'Ms.' ) THEN
                   'Female'
               ELSE
                   'Unspecified'
           END AS Gender
    FROM HumanResources.Employee AS E),
     EmployeeGeneratedRevenue2015
AS (SELECT O.EmployeeId,
           SUM(OD.Quantity * OD.UnitPrice * (1.0 - OD.DiscountPercentage)) AS EmployeeRevenue
    FROM Sales.[Order] AS O
        INNER JOIN Sales.OrderDetail AS OD
            ON OD.OrderId = O.OrderId
    WHERE YEAR(O.OrderDate) = 2015
    GROUP BY O.EmployeeId)
SELECT G.Gender,
       FORMAT(SUM(R.EmployeeRevenue), 'C') AS RevenueAfterDiscount
FROM EmployeeGender AS G
    INNER JOIN EmployeeGeneratedRevenue2015 AS R
        ON R.EmployeeId = G.EmployeeId
GROUP BY G.Gender
ORDER BY SUM(R.EmployeeRevenue) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Revenue Generated By Gender'), INCLUDE_NULL_VALUES;

GO

/*
	Problem 14 (Complex): Find which quarter of each year every employee handled most of their orders, how much those orders were worth after discount, and list employees by name using NorthwindsTSQLV4
    Top #1: All things considered its pretty readable for what it is doing, has a fairly decent logical flow, and it makes use of a lot of concepts learned by this point in this course so I feel like it is a good representation of the fruits of that learning
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.udf_FindYearQuarter;
GO
CREATE FUNCTION Sales.udf_FindYearQuarter
(
    @date DATE
)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Result NVARCHAR(20);

    SELECT @Result = CASE
                         WHEN MONTH(@date)
                              BETWEEN 1 AND 3 THEN
                             'Quarter I'
                         WHEN MONTH(@date)
                              BETWEEN 4 AND 6 THEN
                             'Quarter II'
                         WHEN MONTH(@date)
                              BETWEEN 7 AND 9 THEN
                             'Quarter III'
                         WHEN MONTH(@date)
                              BETWEEN 10 AND 12 THEN
                             'Quarter IV'
                         ELSE
                             'ERROR - CANNOT CALCULATE QUARTER'
                     END;
    RETURN @Result;
END;
GO
DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;
GO
CREATE FUNCTION Sales.udf_RevenueAfterDiscount
(
    @quantity AS INT,
    @unitprice AS MONEY,
    @discount AS NUMERIC(4, 3)
)
RETURNS NUMERIC(20, 2)
AS
BEGIN
    DECLARE @Result NUMERIC(20, 2) = @quantity * @unitprice * (1.0 - @discount);
    RETURN @Result;
END;
GO

WITH OrderByYearAndQuarter
AS (SELECT O.OrderId,
           O.EmployeeId,
           YEAR(O.OrderDate) AS OrderYear,
           Sales.udf_FindYearQuarter(O.OrderDate) AS [Quarter]
    FROM Sales.[Order] AS O),
     EmployeeRevenuePerQuarter
AS (SELECT O.EmployeeId,
           O.OrderYear,
           O.[Quarter],
           CONCAT(E.EmployeeFirstName + ' ', E.EmployeeLastName) AS EmployeeFullName,
           SUM(Sales.udf_RevenueAfterDiscount(OD.Quantity, OD.UnitPrice, OD.DiscountPercentage)) AS QuarterlyRevenue
    FROM HumanResources.Employee AS E
        INNER JOIN OrderByYearAndQuarter AS O
            ON O.EmployeeId = E.EmployeeId
        INNER JOIN Sales.OrderDetail AS OD
            ON O.OrderId = OD.OrderId
    GROUP BY O.EmployeeId,
             O.OrderYear,
             O.[Quarter],
             CONCAT(E.EmployeeFirstName + ' ', E.EmployeeLastName))
SELECT Q1.EmployeeId,
       Q1.EmployeeFullName,
       Q1.OrderYear,
       Q1.[Quarter],
       FORMAT(Q1.QuarterlyRevenue, 'C') AS QuarterlyRevenue
FROM EmployeeRevenuePerQuarter AS Q1
WHERE Q1.[Quarter] =
(
    SELECT TOP (1)
           Q2.[Quarter]
    FROM EmployeeRevenuePerQuarter AS Q2
    WHERE Q2.EmployeeId = Q1.EmployeeId
          AND Q2.OrderYear = Q1.OrderYear
    ORDER BY Q2.QuarterlyRevenue DESC
)
ORDER BY EmployeeId;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Best Quarter Per Employee'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS Sales.udf_FindYearQuarter;
DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;

GO

/*
	Problem 15 (Complex): How much product does each ship ship per season per year using Northwinds2022TSQLV7?
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.udf_FindMeteorologicalSeason;
GO
CREATE FUNCTION Sales.udf_FindMeteorologicalSeason
(
    @date DATE
)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Result NVARCHAR(20);
    DECLARE @Month INT = MONTH(@date);

    SELECT @Result = CASE
                         WHEN @Month IN ( 12, 1, 2 ) THEN
                             'Winter'
                         WHEN @Month
                              BETWEEN 3 AND 5 THEN
                             'Spring'
                         WHEN @Month
                              BETWEEN 6 AND 8 THEN
                             'Summer'
                         WHEN @Month
                              BETWEEN 9 AND 11 THEN
                             'Autumn'
                         ELSE
                             'ERROR - CANNOT CALCULATE Season'
                     END;
    RETURN @Result;
END;
GO

WITH OrdersBySeason
AS (SELECT O.OrderId,
           O.ShipperId,
           YEAR(O.OrderDate) AS OrderYear,
           Sales.udf_FindMeteorologicalSeason(O.OrderDate) AS Season
    FROM Sales.[Order] AS O)
SELECT S.ShipperId,
       S.ShipperCompanyName,
       O.OrderYear,
       O.Season,
       SUM(OD.Quantity) AS TotalShippedProduct
FROM Sales.Shipper AS S
    LEFT OUTER JOIN(OrdersBySeason AS O
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.OrderId = O.OrderId)
        ON O.ShipperId = S.ShipperId
GROUP BY S.ShipperId,
         S.ShipperCompanyName,
         O.OrderYear,
         O.Season
ORDER BY S.ShipperId,
         O.OrderYear,
         O.Season;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Product Shipped Per Season Per Shipper'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS Sales.udf_FindMeteorologicalSeason;

GO

/*
	Problem 16 (Complex): What type of product is ordered most often per customer country using Northwinds2022TSQLV7
	Top #3: While a bit messy I think this query is pretty interesting and has a somewhat decent logical flow to it, utilizing CTE and functions and a subquery to break down the top per country
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.udf_GetProductCategory;
GO
CREATE FUNCTION Sales.udf_GetProductCategory
(
    @categoryid INT
)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Result NVARCHAR(20);

    SELECT @Result =
    (
        SELECT TOP (1)
               CategoryName
        FROM Production.Category AS P
        WHERE @categoryid = P.CategoryId
        ORDER BY P.CategoryId
    );
    RETURN @Result;
END;
GO

WITH ProductAndCategory
AS (SELECT P.ProductId,
           Sales.udf_GetProductCategory(P.CategoryId) AS ProductType
    FROM Production.Product AS P)
SELECT C.CustomerCountry,
       P.ProductType,
       COUNT(OD.ProductId) TimesOrdered
FROM Sales.Customer AS C
    INNER JOIN Sales.[Order] AS O
        ON O.CustomerId = C.CustomerId
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.OrderId = O.OrderId
    INNER JOIN ProductAndCategory AS P
        ON P.ProductId = OD.ProductId
GROUP BY C.CustomerCountry,
         P.ProductType
HAVING P.ProductType IN
       (
           SELECT TOP (1) WITH TIES
                  Sales.udf_GetProductCategory(P2.CategoryId) AS ProductType
           FROM Sales.[Order] AS O2
               INNER JOIN Sales.Customer AS C2
                   ON C2.CustomerId = O2.CustomerId
               INNER JOIN Sales.OrderDetail AS OD2
                   ON OD2.OrderId = O2.OrderId
               INNER JOIN Production.Product AS P2
                   ON P2.ProductId = OD2.ProductId
           WHERE C2.CustomerCountry = C.CustomerCountry
           GROUP BY Sales.udf_GetProductCategory(P2.CategoryId)
           ORDER BY COUNT(OD2.ProductId) DESC
       )
ORDER BY COUNT(OD.ProductId) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Product Per Country'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS Sales.udf_GetProductCategory;

GO

/*
	Problem 17 (Complex): List all dates between the earliest and most recent order, and if an order has been placed or not, and also how much all orders cost on each date after discount using Northwinds2022TSQLV4
	Top #2: This is a top because I think its pretty interesting and has a pretty nice logical flow and read to it. It also makes use of an auxiliary numbers table to assist in querying which is pretty interesting to utilize
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.udf_DateFromAnchor;
GO
CREATE FUNCTION Sales.udf_DateFromAnchor
(
    @AnchorDate DATE,
    @DaysSinceAnchor INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE;

    SELECT @Result = CAST(DATEADD(DAY, @DaysSinceAnchor, @AnchorDate) AS DATE);
    RETURN @Result;
END;
GO
DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;
GO
CREATE FUNCTION Sales.udf_RevenueAfterDiscount
(
    @quantity AS INT,
    @unitprice AS MONEY,
    @discount AS NUMERIC(4, 3)
)
RETURNS NUMERIC(20, 2)
AS
BEGIN
    DECLARE @Result NUMERIC(20, 2) = @quantity * @unitprice * (1.0 - @discount);
    RETURN @Result;
END;
GO

WITH AllDatesFromAnchor
AS (SELECT Sales.udf_DateFromAnchor(
           (
               SELECT MIN(O.OrderDate)FROM Sales.[Order] AS O
           ),
           N - 1
                                   ) AS [Date]
    FROM dbo.Nums
    WHERE Sales.udf_DateFromAnchor(
          (
              SELECT MIN(O.OrderDate)FROM Sales.[Order] AS O
          ),
          N - 1
                                  ) <=
    (
        SELECT MAX(O.OrderDate)FROM Sales.[Order] AS O
    ))
SELECT D.[Date],
       CASE
           WHEN MAX(O.OrderId) IS NULL THEN
               'No'
           ELSE
               'Yes'
       END AS ThereHasBeenAnOrder,
       CONCAT('$', COALESCE(SUM(Sales.udf_RevenueAfterDiscount(OD.Quantity, OD.UnitPrice, OD.DiscountPercentage)), 0)) AS RevenueAfterDiscount
FROM AllDatesFromAnchor AS D
    LEFT OUTER JOIN(Sales.[Order] AS O
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.OrderId = O.OrderId)
        ON D.[Date] = O.OrderDate
GROUP BY D.[Date]
ORDER BY D.[Date];

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Dates'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS Sales.udf_DateFromAnchor;
DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;

GO

/*
	Problem 18 (Complex): Who are the top 3 suppliers in terms of quantity of product supplied for orders, and how much have those suppliers' products generated in revenue using Northwinds2022TSQLV7
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;
GO
CREATE FUNCTION Sales.udf_RevenueAfterDiscount
(
    @quantity AS INT,
    @unitprice AS MONEY,
    @discount AS NUMERIC(4, 3)
)
RETURNS NUMERIC(20, 2)
AS
BEGIN
    DECLARE @Result NUMERIC(20, 2) = @quantity * @unitprice * (1.0 - @discount);
    RETURN @Result;
END;
GO

WITH OrderDetailsAndComputedRevenueAfterDiscount
AS (SELECT OD.OrderId,
           OD.ProductId,
           OD.UnitPrice,
           OD.Quantity,
           OD.DiscountPercentage,
           Sales.udf_RevenueAfterDiscount(OD.Quantity, OD.UnitPrice, OD.DiscountPercentage) AS RevenueAfterDiscount
    FROM Sales.OrderDetail AS OD)
SELECT TOP (3) WITH TIES
       P.SupplierId,
       S.SupplierCompanyName,
       SUM(OD.Quantity) AS TotalProductSupplied,
       FORMAT(SUM(OD.RevenueAfterDiscount), 'C') [RevenueGeneratedBySupplier'sProducts]
FROM Production.Product AS P
    INNER JOIN Production.Supplier AS S
        ON S.SupplierId = P.SupplierId
    INNER JOIN OrderDetailsAndComputedRevenueAfterDiscount AS OD
        ON OD.ProductId = P.ProductId
GROUP BY P.SupplierId,
         S.SupplierCompanyName
ORDER BY SUM(OD.Quantity) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Top Supplier By Quantity'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;

GO

/*
	Problem 19 (Complex): What are the name and phone numbers of all customers who have purchased atleast 100 beverage classed items in 2016 using NorthwindsTSQLV4
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.udf_GetCustomerName;
GO
CREATE FUNCTION Sales.udf_GetCustomerName
(
    @customerid INT
)
RETURNS NVARCHAR(30)
AS
BEGIN
    DECLARE @Result NVARCHAR(30);

    SELECT @Result =
    (
        SELECT TOP (1)
               C.CustomerContactName
        FROM Sales.Customer AS C
        WHERE @customerid = C.CustomerId
        ORDER BY C.CustomerId
    );
    RETURN @Result;
END;
GO
DROP FUNCTION IF EXISTS Sales.udf_GetCustomerPhoneNumber;
GO
CREATE FUNCTION Sales.udf_GetCustomerPhoneNumber
(
    @customerid INT
)
RETURNS NVARCHAR(24)
AS
BEGIN
    DECLARE @Result NVARCHAR(24);

    SELECT @Result =
    (
        SELECT TOP (1)
               C.CustomerPhoneNumber
        FROM Sales.Customer AS C
        WHERE @customerid = C.CustomerId
        ORDER BY C.CustomerId
    );
    RETURN @Result;
END;
GO

WITH OrderAndCustomer
AS (SELECT O.OrderId,
           O.OrderDate,
           O.CustomerId,
           Sales.udf_GetCustomerName(O.CustomerId) AS CustomerName,
           Sales.udf_GetCustomerPhoneNumber(O.CustomerId) AS PhoneNumber
    FROM Sales.[Order] AS O)
SELECT OC.CustomerId,
       OC.CustomerName,
       OC.PhoneNumber,
       SUM(OD.Quantity) AS TotalBevaragesPurchased
FROM OrderAndCustomer AS OC
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.OrderId = OC.OrderId
    INNER JOIN Production.Product AS P
        ON P.ProductId = OD.ProductId
    INNER JOIN Production.Category AS C
        ON P.CategoryId = C.CategoryId
WHERE C.CategoryName = N'Beverages'
      AND YEAR(OC.OrderDate) = 2015
GROUP BY OC.CustomerId,
         OC.CustomerName,
         OC.PhoneNumber
HAVING SUM(OD.Quantity) >= 100;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Customer'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS Sales.udf_GetCustomerName;
DROP FUNCTION IF EXISTS Sales.udf_GetCustomerPhoneNumber;

GO

/*
	Problem 20 (Complex): Which employee working for at least 8 years has handled the most orders, and how much revenue did those orders generate?
*/

USE Northwinds2022TSQLV7;

DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;
GO
CREATE FUNCTION Sales.udf_RevenueAfterDiscount
(
    @quantity AS INT,
    @unitprice AS MONEY,
    @discount AS NUMERIC(4, 3)
)
RETURNS NUMERIC(20, 2)
AS
BEGIN
    DECLARE @Result NUMERIC(20, 2) = @quantity * @unitprice * (1.0 - @discount);
    RETURN @Result;
END;
GO
DROP FUNCTION IF EXISTS Sales.udf_GetYearsWorked;
GO
CREATE FUNCTION Sales.udf_GetYearsWorked
(
    @HireDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT = DATEDIFF(YEAR, @HireDate, SYSDATETIME());
    RETURN @Result;
END;
GO

WITH EmployeesAndYearsWorked
AS (SELECT E.EmployeeId,
           CONCAT(E.EmployeeFirstName + ' ', E.EmployeeLastName) AS EmployeeName,
           Sales.udf_GetYearsWorked(E.HireDate) AS YearsWorked
    FROM HumanResources.Employee AS E)
SELECT TOP (1) WITH TIES
       O.EmployeeId,
       E.EmployeeName,
       COUNT(DISTINCT O.OrderId) AS OrdersHandled,
       CONCAT('$', SUM(Sales.udf_RevenueAfterDiscount(OD.Quantity, OD.UnitPrice, OD.DiscountPercentage))) AS RevenueFromOrders
FROM EmployeesAndYearsWorked AS E
    INNER JOIN Sales.[Order] AS O
        ON O.EmployeeId = E.EmployeeId
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.OrderId = O.OrderId
WHERE E.YearsWorked >= 8
GROUP BY O.EmployeeId,
         E.EmployeeName
ORDER BY COUNT(DISTINCT O.OrderId) DESC;

-- UNCOMMENT AND REMOVE PRIOR ';' FOR JSON
-- FOR JSON PATH, ROOT('Employee'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS Sales.udf_RevenueAfterDiscount;
DROP FUNCTION IF EXISTS Sales.udf_GetYearsWorked;

GO