USE [QueensClassSchedule];
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadClassDay]    Script Date: 5/7/2022 9:41:37 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-07
-- Description:	Load data into [Class].[ClassDay]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadClassDay] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Class].[ClassDay]
    (
        [ClassId],
        [DayCode],
        [CourseName],
        [UserAuthorizationKey]
    )
    SELECT [ClassId],
           [DayCode],
           [CourseName],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateClassDay](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Class].[ClassDay]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Class].[ClassDay]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;