USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadClassRoomLocation]    Script Date: 5/8/2022 6:04:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-07
-- Description:	Load data into [Location].[ClassRoomLocation]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadClassRoomLocation] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Location].[ClassRoomLocation]
    (
        [ClassId],
        [RoomId],
        [CourseName],
        [Building],
        [Room],
        [UserAuthorizationKey]
    )
    SELECT [ClassId],
           [RoomId],
           [CourseName],
           [Building],
           [Room],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateClassRoomLocation](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Location].[ClassRoomLocation]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Location].[ClassRoomLocation]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;