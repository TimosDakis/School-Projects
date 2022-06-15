USE [QueensClassSchedule]

-- Truncate WorkFlowsSteps
TRUNCATE TABLE Process.WorkFlowStep;
GO
-- Load the star schema
EXEC [Project3Procedure].[LoadQueensCollegeScheduleDatabase] @UserAuthorizationKey = 1 -- int
GO

-- Show workflow table
EXEC Process.usp_ShowWorkflowStep;
GO