USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadDay]    Script Date: 5/8/2022 5:23:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kevin Tang
-- Create date: 2022-05-07
-- Description:	Load data into [Temporal].[Day]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadDay] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Temporal].[Day]
    (
        [DayCode],
        [DayName],
        [UserAuthorizationKey]
    )
    SELECT [Day],
           [DayName],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateDay](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Temporal].[Day]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Temporal].[Day]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;