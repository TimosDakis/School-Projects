/*
	Group Top #1: Find which quarter of each year every employee handled most of their orders, how much those orders were worth after discount, and list employees by name using Northwinds2022TSQLV7
	Complexity: Complex
	Written by: Timothy Dakis
	Reasoning: Interesting problem, clearly written, good logical flow to it
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

/*
	Group Top #2: For each category and sub category of products show the total sales made for the quarter in 2013 using AdventureWorks2017
	Complexity: Complex
	Written by: Mikhaiel Gomes
	Reasoning: Pretty intuitive to read, and solves a useful problem. Avoid making unnecessary UDFs by utilizing in built functions instead
*/

USE AdventureWorks2017;
GO

SELECT PC.[Name] AS Category,
       PS.[Name] AS Subcategory,
       DATEPART(yy, SOH.OrderDate) AS [Year],
       'Q' + DATENAME(qq, SOH.OrderDate) AS [Qtr],
       STR(SUM(DET.UnitPrice * DET.OrderQty)) AS [$ Sales]
FROM Production.ProductSubcategory AS PS
    INNER JOIN Sales.SalesOrderHeader AS SOH
        INNER JOIN Sales.SalesOrderDetail DET
            ON SOH.SalesOrderID = DET.SalesOrderID
        INNER JOIN Production.Product P
            ON DET.ProductID = P.ProductID
        ON PS.ProductSubcategoryID = P.ProductSubcategoryID
    INNER JOIN Production.ProductCategory PC
        ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE YEAR(SOH.OrderDate) = '2013'
GROUP BY DATEPART(yy, SOH.OrderDate),
         PC.Name,
         PS.Name,
         'Q' + DATENAME(qq, SOH.OrderDate),
         PS.ProductSubcategoryID
ORDER BY Category,
         Subcategory,
         [Qtr];

/*
	Group Top #3: Display every employee(oldest to youngest) who's birthday is in July using AdventureWorksDW2017
	Complexity: Medium
	Written by: Konrad Rakowski
	Reasoning: Easy to read and understand, good usage of CTE to make query more readable and intuitive to understand
*/

USE AdventureWorksDW2017;

WITH MonthName
AS (SELECT D.EnglishMonthName AS [Month],
           D.MonthNumberOfYear AS MonthNum
    FROM [dbo].[DimDate] AS D
    GROUP BY D.EnglishMonthName,
             D.MonthNumberOfYear)
SELECT DISTINCT
       E.LastName,
       E.FirstName,
       D.Month,
       DAY(E.BirthDate) AS [Day],
       YEAR(E.BirthDate) AS [Year]
FROM [dbo].[DimEmployee] AS E
    INNER JOIN MonthName AS D
        ON MONTH(E.BirthDate) = D.MonthNum
WHERE MONTH(E.BirthDate) = 7
ORDER BY [Year],
         [Day];