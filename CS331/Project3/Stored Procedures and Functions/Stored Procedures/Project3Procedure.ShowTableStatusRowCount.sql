USE [QueensClassSchedule];
GO
/****** Object:  StoredProcedure [Project3Procedure].[ShowTableStatusRowCount]    Script Date: 5/7/2022 9:31:50 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-07
-- Description:	Creates a table showing number of rows in each table of the QueensCollegeSchedule Database
-- =============================================
ALTER PROCEDURE [Project3Procedure].[ShowTableStatusRowCount]
    @TableStatus VARCHAR(64),
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- UNION ALL between each select so only 1 output is generated
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Uploadfile].[CleanedCurrentSemesterCourseOfferings]',
           [NumberOfRows] = COUNT(*)
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Class].[Class]',
           COUNT(*)
    FROM [Class].[Class]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Class].[ClassDay]',
           COUNT(*)
    FROM [Class].[ClassDay]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Class].[ClassModeOfInstruction]',
           COUNT(*)
    FROM [Class].[ClassModeOfInstruction]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Class].[Course]',
           COUNT(*)
    FROM [Class].[Course]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Class].[ModeOfInstruction]',
           COUNT(*)
    FROM [Class].[ModeOfInstruction]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Department].[Department]',
           COUNT(*)
    FROM [Department].[Department]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Location].[BuildingLocation]',
           COUNT(*)
    FROM [Location].[BuildingLocation]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Location].[ClassRoomLocation]',
           COUNT(*)
    FROM [Location].[ClassRoomLocation]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Location].[RoomLocation]',
           COUNT(*)
    FROM [Location].[RoomLocation]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Staff].[DepartmentInstructor]',
           COUNT(*)
    FROM [Staff].[DepartmentInstructor]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Staff].[Instructor]',
           COUNT(*)
    FROM [Staff].[Instructor]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Staff].[InstructorClass]',
           COUNT(*)
    FROM [Staff].[InstructorClass]
    UNION ALL
    SELECT [TableStatus] = @TableStatus,
           [TableName] = '[Temporal].[Day]',
           COUNT(*)
    FROM [Temporal].[Day];

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();
    DECLARE @ProcWorkFlowTableRowCount INT = 0;
    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'[Project3Procedure].[ShowTableStatusRowCount] counted rows of all tables',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;