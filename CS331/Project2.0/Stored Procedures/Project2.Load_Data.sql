USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_Data]    Script Date: 4/3/2022 5:05:50 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Loads data into [CH01-01-Fact].[Data]
--
-- @UserAuthorizationKey is the 
-- UserAuthorizationKey of the Group Member who completed 
-- this stored procedure.
--
-- =============================================
ALTER PROCEDURE [Project2].[Load_Data] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Fact].Data
    (
        SalesManagerKey,
        OccupationKey,
        TerritoryKey,
        ProductKey,
        CustomerKey,
        ProductCategory,
        SalesManager,
        ProductSubcategory,
        ProductCode,
        ProductName,
        Color,
        ModelName,
        OrderQuantity,
        UnitPrice,
        ProductStandardCost,
        SalesAmount,
        OrderDate,
        [MonthName],
        MonthNumber,
        [Year],
        CustomerName,
        MaritalStatus,
        Gender,
        Education,
        Occupation,
        TerritoryRegion,
        TerritoryCountry,
        TerritoryGroup,
        UserAuthorizationKey
    )
    SELECT SM.SalesManagerKey,
           DO.OccupationKey,
           DT.TerritoryKey,
           DP.ProductKey,
           DC.CustomerKey,
           OLD.ProductCategory,
           OLD.SalesManager,
           OLD.ProductSubcategory,
           OLD.ProductCode,
           OLD.ProductName,
           OLD.Color,
           OLD.ModelName,
           OLD.OrderQuantity,
           OLD.UnitPrice,
           OLD.ProductStandardCost,
           OLD.SalesAmount,
           OLD.OrderDate,
           OLD.[MonthName],
           OLD.MonthNumber,
           OLD.[Year],
           OLD.CustomerName,
           OLD.MaritalStatus,
           OLD.Gender,
           OLD.Education,
           OLD.Occupation,
           OLD.TerritoryRegion,
           OLD.TerritoryCountry,
           OLD.TerritoryGroup,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD
        INNER JOIN [CH01-01-Dimension].SalesManagers AS SM
            ON SM.SalesManager = OLD.SalesManager
               AND OLD.ProductSubcategory = SM.Category
        INNER JOIN [CH01-01-Dimension].DimOccupation AS DO
            ON DO.Occupation = OLD.Occupation
        INNER JOIN [CH01-01-Dimension].DimTerritory AS DT
            ON DT.TerritoryCountry = OLD.TerritoryCountry
               AND DT.TerritoryGroup = OLD.TerritoryGroup
               AND DT.TerritoryRegion = OLD.TerritoryRegion
        INNER JOIN [CH01-01-Dimension].DimProduct AS DP
            ON DP.ProductName = OLD.ProductName
        INNER JOIN [CH01-01-Dimension].DimCustomer AS DC
            ON DC.CustomerName = OLD.CustomerName;

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_Data');

    EXEC ('CREATE VIEW G9_5.uvw_Data AS
		SELECT D.SalesKey,
               D.SalesManagerKey,
               D.OccupationKey,
               D.TerritoryKey,
               D.ProductKey,
               D.CustomerKey,
               D.ProductCategory,
               D.SalesManager,
               D.ProductSubcategory,
               D.ProductCode,
               D.ProductName,
               D.Color,
               D.ModelName,
               D.OrderQuantity,
               D.UnitPrice,
               D.ProductStandardCost,
               D.SalesAmount,
               D.OrderDate,
               D.[MonthName],
               D.MonthNumber,
               D.[Year],
               D.CustomerName,
               D.MaritalStatus,
               D.Gender,
               D.Education,
               D.Occupation,
               D.TerritoryRegion,
               D.TerritoryCountry,
               D.TerritoryGroup,
               D.UserAuthorizationKey,
               D.DateAdded,
               D.DateOfLastUpdate FROM [CH01-01-Fact].[Data] AS D');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Fact].[Data]
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_Data] is loading data into [CH01-01-Fact].[Data]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;


