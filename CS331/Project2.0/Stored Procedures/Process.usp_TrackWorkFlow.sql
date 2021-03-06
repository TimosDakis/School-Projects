USE [BIClass]
GO
/****** Object:  StoredProcedure [Process].[usp_TrackWorkFlows]    Script Date: 4/1/2022 4:34:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-03-31
-- Description:	Inputs information into [Process].WorkFlowSteps]
-- =============================================
ALTER PROCEDURE [Process].[usp_TrackWorkFlows]
    -- Add the parameters for the stored procedure here
    @UserAuthorizationKey INT,
    @WorkFlowDescription NVARCHAR(100),
    @WorkFlowStepTableRowCount INT,
    @StartTime DATETIME2,
    @EndTime DATETIME2
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO Process.WorkFlowSteps
    (
        WorkFlowStepDescription,
        WorkFlowStepTableRowCount,
        StartingDateTime,
        EndingDateTime,
        UserAuthorizationKey
    )
    VALUES
    (@WorkFlowDescription, @WorkFlowStepTableRowCount, @StartTime, @EndTime, @UserAuthorizationKey);

END;
