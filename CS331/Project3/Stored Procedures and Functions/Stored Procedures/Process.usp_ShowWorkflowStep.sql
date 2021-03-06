USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Process].[usp_ShowWorkflowStep]    Script Date: 5/7/2022 9:18:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Timothy Dakis
-- Create date: 2022-05-07
-- Description: Outputs all information from [Process].[WorkFlowStep]
-- =============================================
ALTER PROCEDURE [Process].[usp_ShowWorkflowStep]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SELECT [WFS].[WorkFlowStepKey],
           [WFS].[WorkFlowStepDescription],
           [WFS].[WorkFlowStepTableRowCount],
           [WFS].[StartingDateTime],
           [WFS].[EndingDateTime],
           [WFS].[ClassTime],
           [WFS].[UserAuthorizationKey]
    FROM [Process].[WorkFlowStep] AS [WFS];
END;