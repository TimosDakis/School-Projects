USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_AddForeignKeysToQueensClassScheduleDatabase]    Script Date: 5/6/2022 6:12:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-06
-- Description:	Add the Foreign Keys to the QueensClassSchedule Database
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_AddForeignKeysToQueensClassScheduleDatabase] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- Adding all FKs to each table
    ALTER TABLE [Class].[Class]
    ADD CONSTRAINT [FK_Class_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]),
        CONSTRAINT [FK_Class_Course]
        FOREIGN KEY ([CourseName])
        REFERENCES [Class].[Course] ([CourseName]);

    ALTER TABLE [Class].[ClassDay]
    ADD CONSTRAINT [FK_ClassDay_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]),
        CONSTRAINT [FK_ClassDay_Class]
        FOREIGN KEY ([ClassId])
        REFERENCES [Class].[Class] ([ClassId]),
        CONSTRAINT [FK_ClassDay_Course]
        FOREIGN KEY ([CourseName])
        REFERENCES [Class].[Course] ([CourseName]),
        CONSTRAINT [FK_ClassDay_Day]
        FOREIGN KEY ([DayCode])
        REFERENCES [Temporal].[Day] ([DayCode]);

    ALTER TABLE [Class].[ClassModeOfInstruction]
    ADD CONSTRAINT [FK_ClassModeOfInstruction_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]),
        CONSTRAINT [FK_ClassModeOfInstruction_Class]
        FOREIGN KEY ([ClassId])
        REFERENCES [Class].[Class] ([ClassId]),
        CONSTRAINT [FK_ClassModeOfInstruction_Course]
        FOREIGN KEY ([CourseName])
        REFERENCES [Class].[Course] ([CourseName]),
        CONSTRAINT [FK_ClassModeOfInstruction_ModeOfInstruction_1]
        FOREIGN KEY ([ModeId])
        REFERENCES [Class].[ModeOfInstruction] ([ModeId]),
        CONSTRAINT [FK_ClassModeOfInstruction_ModeOfInstruction_2]
        FOREIGN KEY ([ModeOfInstruction])
        REFERENCES [Class].[ModeOfInstruction] ([ModeOfInstruction]);

    ALTER TABLE [Class].[Course]
    ADD CONSTRAINT [FK_Course_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Class].[ModeOfInstruction]
    ADD CONSTRAINT [FK_ModeOfInstruction_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Department].[Department]
    ADD CONSTRAINT [FK_Department_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Location].[BuildingLocation]
    ADD CONSTRAINT [FK_BuildingLocation_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Location].[ClassRoomLocation]
    ADD CONSTRAINT [FK_ClassRoomLocation_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]),
        CONSTRAINT [FK_ClassRoomLocation_Class]
        FOREIGN KEY ([ClassId])
        REFERENCES [Class].[Class] ([ClassId]),
        CONSTRAINT [FK_ClassRoomLocation_Course]
        FOREIGN KEY ([CourseName])
        REFERENCES [Class].[Course] ([CourseName]),
        CONSTRAINT [FK_ClassRoomLocation_RoomLocation_1]
        FOREIGN KEY ([RoomId])
        REFERENCES [Location].[RoomLocation] ([RoomId]),
        CONSTRAINT [FK_ClassRoomLocation_RoomLocation_2]
        FOREIGN KEY ([Room])
        REFERENCES [Location].[RoomLocation] ([Room]),
        CONSTRAINT [FK_ClassRoomLocation_BuildingLocation]
        FOREIGN KEY ([Building])
        REFERENCES [Location].[BuildingLocation] ([BuildingAbbreviation]);

    ALTER TABLE [Location].[RoomLocation]
    ADD CONSTRAINT [FK_RoomLocation_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]),
        CONSTRAINT [FK_RoomLocation_BuildingLocation]
        FOREIGN KEY ([BuildingOfRoom])
        REFERENCES [Location].[BuildingLocation] ([BuildingAbbreviation]);

    ALTER TABLE [Process].[WorkFlowStep]
    ADD CONSTRAINT [FK_WorkFlowStep_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Staff].[DepartmentInstructor]
    ADD CONSTRAINT [FK_DepartmentInstructor_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]),
        CONSTRAINT [FK_DepartmentInstructor_Department_1]
        FOREIGN KEY ([DepartmentId])
        REFERENCES [Department].[Department] ([DepartmentId]),
        CONSTRAINT [FK_DepartmentInstructor_Department_2]
        FOREIGN KEY ([Department])
        REFERENCES [Department].[Department] ([DepartmentName]),
        CONSTRAINT [FK_DepartmentInstructor_Instructor]
        FOREIGN KEY ([InstructorId])
        REFERENCES [Staff].[Instructor] ([InstructorId]);

    ALTER TABLE [Staff].[Instructor]
    ADD CONSTRAINT [FK_Instructor_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Staff].[InstructorClass]
    ADD CONSTRAINT [FK_InstructorClass_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]),
        CONSTRAINT [FK_InstructorClass_Instructor]
        FOREIGN KEY ([InstructorId])
        REFERENCES [Staff].[Instructor] ([InstructorId]),
        CONSTRAINT [FK_InstructorClass_Class]
        FOREIGN KEY ([ClassId])
        REFERENCES [Class].[Class] ([ClassId]),
        CONSTRAINT [FK_InstructorClass_Course]
        FOREIGN KEY ([CourseName])
        REFERENCES [Class].[Course] ([CourseName]);

    ALTER TABLE [Temporal].[Day]
    ADD CONSTRAINT [FK_Day_UserAuthorization]
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Adding all Foreign Keys to the QueensClassSchedule Database',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;
