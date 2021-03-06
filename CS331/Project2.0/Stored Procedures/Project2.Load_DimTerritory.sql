USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimTerritory]    Script Date: 4/3/2022 2:59:33 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author: Shivanie Kemraj
-- Create date: 2022-04-02
-- Description: Loads data into [CH01-01-Dimension].[DimTerritory]
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimTerritory] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].[DimTerritory]
    (
        TerritoryGroup,
        TerritoryCountry,
        TerritoryRegion,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           OLD.TerritoryGroup,
           OLD.TerritoryCountry,
           OLD.TerritoryRegion,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;



    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimTerritory');

    EXEC ('CREATE VIEW G9_5.uvw_DimTerritory AS
	SELECT DT.TerritoryKey,
           DT.TerritoryGroup,
           DT.TerritoryCountry,
           DT.TerritoryRegion,
           DT.UserAuthorizationKey,
           DT.DateAdded,
           DT.DateOfLastUpdate FROM [CH01-01-Dimension].DimTerritory AS DT');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimTerritory
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimTerritory] is loading data into [CH01-01-Dimension].[DimTerritory]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
