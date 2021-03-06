USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimProductCategory]    Script Date: 4/2/2022 6:16:21 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Loads data into [CH01-01-Dimension].[DimProductCategory]
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProductCategory] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].DimProductCategory
    (
        ProductCategory,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           ProductCategory,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData;

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimProductCategory');

    EXEC ('CREATE VIEW G9_5.uvw_DimProductCategory AS
    	SELECT ProductCategoryKey,
           ProductCategory,
           UserAuthorizationKey,
           DateAdded,
           DateOfLastUpdate FROM [CH01-01-Dimension].DimProductCategory');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimProductCategory
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimProductCategory] is loading data into [CH01-01-Dimension].[DimProductCategory]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
