USE BIClass;

-- Truncate WorkFlowsSteps
TRUNCATE TABLE Process.WorkFlowSteps;
GO
-- Load the star schema
EXEC Project2.LoadStarSchemaData @UserAuthorizationKey = 1;
GO

-- Show workflow table
EXEC Process.usp_ShowWorkflowSteps;
GO