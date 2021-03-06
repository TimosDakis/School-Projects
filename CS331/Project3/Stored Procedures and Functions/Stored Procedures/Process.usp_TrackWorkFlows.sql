USE [QueensClassSchedule];
GO
/****** Object:  StoredProcedure [Process].[usp_TrackWorkFlows]    Script Date: 5/6/2022 5:45:54 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-06
-- Description:	Inputs information into [Process].[WorkFlowStep]
-- =============================================
ALTER PROCEDURE [Process].[usp_TrackWorkFlows]
    -- Add the parameters for the stored procedure here
    @UserAuthorizationKey INT,
    @WorkFlowDescription NVARCHAR(500),
    @WorkFlowStepTableRowCount INT,
    @StartTime DATETIME2,
    @EndTime DATETIME2
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO [Process].[WorkFlowStep]
    (
        [WorkFlowStepDescription],
        [WorkFlowStepTableRowCount],
        [StartingDateTime],
        [EndingDateTime],
        [UserAuthorizationKey]
    )
    VALUES
    (@WorkFlowDescription, @WorkFlowStepTableRowCount, @StartTime, @EndTime, @UserAuthorizationKey);
END;