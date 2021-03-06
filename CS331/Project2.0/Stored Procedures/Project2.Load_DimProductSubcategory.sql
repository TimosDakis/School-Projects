USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimProductSubcategory]    Script Date: 4/2/2022 10:03:30 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Loads data into [CH01-01-Dimension].[DimProductSubcategory]
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProductSubcategory] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].DimProductSubcategory
    (
        ProductCategoryKey,
        ProductSubcategory,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           PC.ProductCategoryKey,
           O.ProductSubcategory,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS O
        INNER JOIN [CH01-01-Dimension].DimProductCategory AS PC
            ON PC.ProductCategory = O.ProductCategory;

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimProductSubcategory');
    EXEC ('CREATE VIEW G9_5.uvw_DimProductSubcategory AS
    SELECT ProductSubcategoryKey,
           ProductCategoryKey,
           ProductSubcategory,
           UserAuthorizationKey,
           DateAdded,
           DateOfLastUpdate
    FROM [CH01-01-Dimension].DimProductSubcategory;');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimProductSubcategory
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimProductSubcategory] is loading data into [CH01-01-Dimension].[DimProductSubcategory]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
