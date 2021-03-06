USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimOccupation]    Script Date: 4/3/2022 2:38:40 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author: Shivanie Kemraj
-- Create date: 2022-04-02
-- Description: Loads data into [CH01-01-Dimension].[DimOccupation]
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimOccupation] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].[DimOccupation]
    (
        Occupation,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           OLD.Occupation,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD
    ORDER BY OLD.Occupation; -- Order by Occupation to mimic the key mapping of initial table

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimOccupation');

    EXEC ('CREATE VIEW G9_5.uvw_DimOccupation AS
	SELECT DO.OccupationKey,
           DO.Occupation,
           DO.UserAuthorizationKey,
           DO.DateAdded,
           DO.DateOfLastUpdate FROM [CH01-01-Dimension].DimOccupation AS DO');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimOccupation
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimOccupation] is loading data into [CH01-01-Dimension].[DimOccupation]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;

END;
