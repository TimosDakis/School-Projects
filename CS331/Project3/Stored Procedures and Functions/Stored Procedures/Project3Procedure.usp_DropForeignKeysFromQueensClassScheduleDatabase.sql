USE [QueensClassSchedule];
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_DropForeignKeysFromQueensClassScheduleDatabase]    Script Date: 5/6/2022 6:26:57 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-01
-- Description:	Drop the Foreign Keys from the QueensClassSchedule Database
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_DropForeignKeysFromQueensClassScheduleDatabase] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- Dropping all FKs from QueensClassSchedule Database
    ALTER TABLE [Class].[Class]
    DROP CONSTRAINT [FK_Class_UserAuthorization],
         CONSTRAINT [FK_Class_Course];

    ALTER TABLE [Class].[ClassDay]
    DROP CONSTRAINT [FK_ClassDay_UserAuthorization],
         CONSTRAINT [FK_ClassDay_Class],
         CONSTRAINT [FK_ClassDay_Course],
         CONSTRAINT [FK_ClassDay_Day];

    ALTER TABLE [Class].[ClassModeOfInstruction]
    DROP CONSTRAINT [FK_ClassModeOfInstruction_UserAuthorization],
         CONSTRAINT [FK_ClassModeOfInstruction_Class],
         CONSTRAINT [FK_ClassModeOfInstruction_Course],
         CONSTRAINT [FK_ClassModeOfInstruction_ModeOfInstruction_1],
         CONSTRAINT [FK_ClassModeOfInstruction_ModeOfInstruction_2];

    ALTER TABLE [Class].[Course]
    DROP CONSTRAINT [FK_Course_UserAuthorization];

    ALTER TABLE [Class].[ModeOfInstruction]
    DROP CONSTRAINT [FK_ModeOfInstruction_UserAuthorization];

    ALTER TABLE [Department].[Department]
    DROP CONSTRAINT [FK_Department_UserAuthorization];

    ALTER TABLE [Location].[BuildingLocation]
    DROP CONSTRAINT [FK_BuildingLocation_UserAuthorization];

    ALTER TABLE [Location].[ClassRoomLocation]
    DROP CONSTRAINT [FK_ClassRoomLocation_UserAuthorization],
         CONSTRAINT [FK_ClassRoomLocation_Class],
         CONSTRAINT [FK_ClassRoomLocation_Course],
         CONSTRAINT [FK_ClassRoomLocation_RoomLocation_1],
         CONSTRAINT [FK_ClassRoomLocation_RoomLocation_2],
         CONSTRAINT [FK_ClassRoomLocation_BuildingLocation];

    ALTER TABLE [Location].[RoomLocation]
    DROP CONSTRAINT [FK_RoomLocation_UserAuthorization],
         CONSTRAINT [FK_RoomLocation_BuildingLocation];

    ALTER TABLE [Process].[WorkFlowStep]
    DROP CONSTRAINT [FK_WorkFlowStep_UserAuthorization];

    ALTER TABLE [Staff].[DepartmentInstructor]
    DROP CONSTRAINT [FK_DepartmentInstructor_UserAuthorization],
         CONSTRAINT [FK_DepartmentInstructor_Department_1],
         CONSTRAINT [FK_DepartmentInstructor_Department_2],
         CONSTRAINT [FK_DepartmentInstructor_Instructor];

    ALTER TABLE [Staff].[Instructor]
    DROP CONSTRAINT [FK_Instructor_UserAuthorization];

    ALTER TABLE [Staff].[InstructorClass]
    DROP CONSTRAINT [FK_InstructorClass_UserAuthorization],
         CONSTRAINT [FK_InstructorClass_Instructor],
         CONSTRAINT [FK_InstructorClass_Class],
         CONSTRAINT [FK_InstructorClass_Course];

    ALTER TABLE [Temporal].[Day] DROP CONSTRAINT [FK_Day_UserAuthorization];


    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Dropping all Foreign Keys from the QueensClassSchedule Database',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;