USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimProduct]    Script Date: 4/2/2022 10:49:18 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Loads data into [CH01-01-Dimension].[DimProduct]
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProduct] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].DimProduct
    (
        ProductSubcategoryKey,
        ProductCategory,
        ProductSubcategory,
        ProductCode,
        ProductName,
        Color,
        ModelName,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           PSC.ProductSubcategoryKey,
           OLD.ProductCategory,
           OLD.ProductSubcategory,
           OLD.ProductCode,
           OLD.ProductName,
           OLD.Color,
           OLD.ModelName,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD
        INNER JOIN [CH01-01-Dimension].DimProductSubcategory AS PSC
            ON PSC.ProductSubcategory = OLD.ProductSubcategory;

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimProduct');

    EXEC ('CREATE VIEW G9_5.uvw_DimProduct AS
	SELECT DP.ProductKey,
           DP.ProductSubcategoryKey,
           DP.ProductCategory,
           DP.ProductSubcategory,
           DP.ProductCode,
           DP.ProductName,
           DP.Color,
           DP.ModelName,
           DP.UserAuthorizationKey,
           DP.DateAdded,
           DP.DateOfLastUpdate FROM [CH01-01-Dimension].DimProduct AS DP');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimProduct
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimProduct] is loading data into [CH01-01-Dimension].[DimProduct]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;