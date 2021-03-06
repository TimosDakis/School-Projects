USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadBuildingLocation]    Script Date: 5/8/2022 4:49:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mikhaiel Gomes
-- Create date: 2022-05-07
-- Description:	Load data into [Location].[BuildingLocation]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadBuildingLocation] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Location].[BuildingLocation]
    (
        [BuildingName],
        [BuildingAbbreviation],
        [UserAuthorizationKey]
    )
    SELECT [BuildingName],
           [BuildingAbbreviation],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateBuildingLocation](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Location].[BuildingLocation]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Location].[BuildingLocation]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;