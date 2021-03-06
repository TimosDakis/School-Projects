USE [BIClass];
GO
/****** Object:  StoredProcedure [Process].[usp_ShowWorkflowSteps]    Script Date: 4/5/2022 12:26:03 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author: Timothy Dakis
-- Create date: 2022-04-05
-- Description: Outputs all information from [Process].[WorkFlowSteps]
-- =============================================
ALTER PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SELECT WFS.WorkFlowStepKey,
           WFS.WorkFlowStepDescription,
           WFS.WorkFlowStepTableRowCount,
           WFS.StartingDateTime,
           WFS.EndingDateTime,
           WFS.ClassTime,
           WFS.UserAuthorizationKey
    FROM Process.WorkFlowSteps AS WFS;

END;