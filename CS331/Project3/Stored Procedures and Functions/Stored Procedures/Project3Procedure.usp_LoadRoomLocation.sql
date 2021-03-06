USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadRoomLocation]    Script Date: 5/8/2022 5:04:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mikhaiel Gomes
-- Create date: 2022-05-07
-- Description:	Load data into [Location].[RoomLocation]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadRoomLocation] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Location].[RoomLocation]
    (
        [Room],
        [UserAuthorizationKey]
    )
    SELECT [Room],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateRoomLocation](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Location].[RoomLocation]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Location].[RoomLocation]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;