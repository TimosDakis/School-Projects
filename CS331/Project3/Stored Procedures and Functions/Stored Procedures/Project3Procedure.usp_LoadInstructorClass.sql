USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadInstructorClass]    Script Date: 5/8/2022 6:15:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-07
-- Description:	Load data into [Staff].[InstructorClass]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadInstructorClass] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Staff].[InstructorClass]
    (
        [InstructorId],
        [ClassId],
        [InstructorFullName],
        [CourseName],
        [UserAuthorizationKey]
    )
    SELECT [InstructorId],
           [ClassId],
           [InstructorFullName],
           [CourseName],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateInstructorClass](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Staff].[InstructorClass]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Staff].[InstructorClass]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;