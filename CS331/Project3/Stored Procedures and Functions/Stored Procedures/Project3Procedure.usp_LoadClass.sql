USE [QueensClassSchedule];
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadClass]    Script Date: 5/6/2022 7:05:02 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-06
-- Description:	Load data into [Class].[Class]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadClass] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Class].[Class]
    (
        [SemesterOfClass],
        [SectionCode],
        [ClassCode],
        [CourseName],
        [ClassTime],
        [ClassLimit],
        [EnrolledInClass],
        [ClassOvertally],
        [UserAuthorizationKey]
    )
    SELECT [SemesterOfClass],
           [SectionCode],
           [ClassCode],
           [CourseName],
           [ClassTime],
           [ClassLimit],
           [EnrolledInClass],
           [ClassOvertally],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateClass](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Class].[Class]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Class].[Class]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;