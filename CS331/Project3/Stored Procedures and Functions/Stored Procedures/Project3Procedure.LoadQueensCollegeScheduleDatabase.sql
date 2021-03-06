USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[LoadQueensCollegeScheduleDatabase]    Script Date: 5/8/2022 6:30:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-08
-- Description:	Loads all data into the QueensCollegeSchedule Database
-- =============================================
ALTER PROCEDURE [Project3Procedure].[LoadQueensCollegeScheduleDatabase] @UserAuthorizationKey INT
-- Add the parameters for the stored procedure here
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();
    --
    --	Drop All of the foreign keys prior to truncating tables in the queens college schedule database
    --
    EXEC [Project3Procedure].[usp_DropForeignKeysFromQueensClassScheduleDatabase] @UserAuthorizationKey = 1;
    --
    --	Check row count before truncation
    EXEC [Project3Procedure].[ShowTableStatusRowCount] @TableStatus = N'''Pre-truncate of tables''',
                                                       @UserAuthorizationKey = 1;
    --
    --	Always truncate the QueensCollegeScheduleDatabase
    --
    EXEC [Project3Procedure].[TruncateQueensCollegeScheduleDatabase] @UserAuthorizationKey = 1;
    --
    --	create the cleaned flat table
    --
    EXEC [Project3Procedure].[usp_CleanFileUpload] @UserAuthorizationKey = 1;
    --
    --	Load the queens college schedule database
    --
    EXEC [Project3Procedure].[usp_LoadDepartment] @UserAuthorizationKey = 4;
    EXEC [Project3Procedure].[usp_LoadCourse] @UserAuthorizationKey = 4;
    EXEC [Project3Procedure].[usp_LoadClass] @UserAuthorizationKey = 1;
    EXEC [Project3Procedure].[usp_LoadInstructor] @UserAuthorizationKey = 5;
    EXEC [Project3Procedure].[usp_LoadModeOfInstruction] @UserAuthorizationKey = 3;
    EXEC [Project3Procedure].[usp_LoadDay] @UserAuthorizationKey = 5;
    EXEC [Project3Procedure].[usp_LoadBuildingLocation] @UserAuthorizationKey = 2;
    EXEC [Project3Procedure].[usp_LoadRoomLocation] @UserAuthorizationKey = 2;
    EXEC [Project3Procedure].[usp_LoadClassModeOfInstruction] @UserAuthorizationKey = 3;
    EXEC [Project3Procedure].[usp_LoadClassDay] @UserAuthorizationKey = 1;
    EXEC [Project3Procedure].[usp_LoadDepartmentInstructor] @UserAuthorizationKey = 1;
    EXEC [Project3Procedure].[usp_LoadInstructorClass] @UserAuthorizationKey = 1;
    EXEC [Project3Procedure].[usp_LoadClassRoomLocation] @UserAuthorizationKey = 1;
    --
    --	Recreate all of the foreign keys prior after loading the queens college schedule database
    --
    EXEC [Project3Procedure].[usp_AddForeignKeysToQueensClassScheduleDatabase] @UserAuthorizationKey = 1; -- int
    --
    --	Check row count before truncation
    --
    EXEC [Project3Procedure].[ShowTableStatusRowCount] @TableStatus = N'''Row Count after loading the queens college schedule database''',
                                                       @UserAuthorizationKey = 1;
    --
    --
    --

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'[Project3Procedure].[LoadQueensCollegeScheduleDatabase] is loading the QueensCollegeSchedule Database',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;
