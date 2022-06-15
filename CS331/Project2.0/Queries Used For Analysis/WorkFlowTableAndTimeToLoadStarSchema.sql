USE BIClass;

-- Show workflow table
EXEC Process.usp_ShowWorkflowSteps;
GO

-- Time to load Star Schema
-- Query 1
SELECT CONCAT(DATEDIFF(MILLISECOND, MIN(StartingDateTime), MAX(EndingDateTime)), ' ms') AS TimeToLoadStarSchema
FROM Process.WorkFlowSteps;
GO

-- Query 2
SELECT CONCAT(DATEDIFF(MILLISECOND, StartingDateTime, EndingDateTime), ' ms') AS TimeToLoadStarSchema
FROM Process.WorkFlowSteps
WHERE WorkFlowStepDescription LIKE '____________LoadStar%';
GO

-- Query 3
SELECT CONCAT(DATEDIFF(MILLISECOND, MIN(StartingDateTime), MAX(EndingDateTime)), ' ms') AS TimeToLoadStarSchema
FROM Process.WorkFlowSteps
WHERE WorkFlowStepDescription NOT LIKE '____________LoadStar%';
GO

-- Query 4
WITH TimeToRunAllProcedures
AS (SELECT (SUM(DATEDIFF(MILLISECOND, StartingDateTime, EndingDateTime))) AS TimeToRunProcedures
    FROM Process.WorkFlowSteps
    WHERE WorkFlowStepDescription NOT LIKE '____________LoadStar%'),
     TimeOfAllGapsBetweenAllProcedures
AS (SELECT (SUM(DATEDIFF(MILLISECOND, WF1.EndingDateTime, WF2.StartingDateTime))) AS TimeOfGapsBetweenProcedures
    FROM Process.WorkFlowSteps AS WF1
        INNER JOIN Process.WorkFlowSteps AS WF2
            ON WF2.WorkFlowStepKey = WF1.WorkFlowStepKey + 1
               AND WF2.WorkFlowStepDescription NOT LIKE '____________LoadStar%')
SELECT CONCAT(TimeOfProcedures.TimeToRunProcedures, ' ms') AS TimeToRunProcedures,
       CONCAT(TimeOfGaps.TimeOfGapsBetweenProcedures, ' ms') AS TimeOfGapsBetweenProcedures,
       CONCAT((TimeOfProcedures.TimeToRunProcedures + TimeOfGaps.TimeOfGapsBetweenProcedures), ' ms') AS TimeToLoadStarSchema
FROM TimeToRunAllProcedures AS TimeOfProcedures
    CROSS JOIN TimeOfAllGapsBetweenAllProcedures AS TimeOfGaps;