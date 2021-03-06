USE [QueensClassSchedule];
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadCourse]    Script Date: 5/8/2022 4:27:48 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Konrad Rakowski
-- Create date: 2022-05-07
-- Description:	Load data into [Class].[Course]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadCourse] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Class].[Course]
    (
        [CourseName],
        [CourseDescription],
        [CourseHour],
        [CourseCredit],
        [UserAuthorizationKey]
    )
    SELECT [CourseName],
           [CourseDescription],
           CAST([CourseHour] AS NUMERIC(5, 2)),
           CAST([CourseCredit] AS NUMERIC(5, 2)),
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateCourse](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Class].[Course]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Class].[Course]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;