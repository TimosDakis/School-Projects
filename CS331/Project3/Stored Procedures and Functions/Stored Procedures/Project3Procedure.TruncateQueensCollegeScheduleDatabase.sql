USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[TruncateQueensCollegeScheduleDatabase]    Script Date: 5/7/2022 9:23:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-07
-- Description:	Truncates the QueensCollegeSchedule Database
-- =============================================
ALTER PROCEDURE [Project3Procedure].[TruncateQueensCollegeScheduleDatabase] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- Truncate all tables
    TRUNCATE TABLE [Class].[Class];
    TRUNCATE TABLE [Class].[ClassDay];
    TRUNCATE TABLE [Class].[ClassModeOfInstruction];
    TRUNCATE TABLE [Class].[Course];
    TRUNCATE TABLE [Class].[ModeOfInstruction];
    TRUNCATE TABLE [Department].[Department];
    TRUNCATE TABLE [Location].[BuildingLocation];
    TRUNCATE TABLE [Location].[ClassRoomLocation];
    TRUNCATE TABLE [Location].[RoomLocation];
    TRUNCATE TABLE [Staff].[DepartmentInstructor];
    TRUNCATE TABLE [Staff].[Instructor];
    TRUNCATE TABLE [Staff].[InstructorClass];
    TRUNCATE TABLE [Temporal].[Day];

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Truncate all tables of the QueensCollegeSchedule Database',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;