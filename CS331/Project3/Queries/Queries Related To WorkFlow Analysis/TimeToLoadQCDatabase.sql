USE [QueensClassSchedule];

-- Show workflow table
EXEC Process.usp_ShowWorkflowStep;
GO

-- Time to load QC schedule database
-- Query 1
SELECT CONCAT(DATEDIFF(MILLISECOND, MIN(StartingDateTime), MAX(EndingDateTime)), ' ms') AS TimeToLoadQCDatabase
FROM Process.WorkFlowStep;
GO

-- Query 2
SELECT CONCAT(DATEDIFF(MILLISECOND, StartingDateTime, EndingDateTime), ' ms') AS TimeToLoadQCDatabase
FROM Process.WorkFlowStep
WHERE WorkFlowStepDescription LIKE '_____________________LoadQueens%';
GO

-- Query 3
SELECT CONCAT(DATEDIFF(MILLISECOND, MIN(StartingDateTime), MAX(EndingDateTime)), ' ms') AS TimeToLoadQCDatabase
FROM Process.WorkFlowStep
WHERE WorkFlowStepDescription NOT LIKE '_____________________LoadQueens%';
GO

-- Query 4
WITH TimeToRunAllProcedures
AS (SELECT (SUM(DATEDIFF(MILLISECOND, StartingDateTime, EndingDateTime))) AS TimeToRunProcedures
    FROM Process.WorkFlowStep
    WHERE WorkFlowStepDescription NOT LIKE '_____________________LoadQueens%'),
     TimeOfAllGapsBetweenAllProcedures
AS (SELECT (SUM(DATEDIFF(MILLISECOND, WF1.EndingDateTime, WF2.StartingDateTime))) AS TimeOfGapsBetweenProcedures
    FROM Process.WorkFlowStep AS WF1
        INNER JOIN Process.WorkFlowStep AS WF2
            ON WF2.WorkFlowStepKey = WF1.WorkFlowStepKey + 1
               AND WF2.WorkFlowStepDescription NOT LIKE '_____________________LoadQueens%')
SELECT CONCAT(TimeOfProcedures.TimeToRunProcedures, ' ms') AS TimeToRunProcedures,
       CONCAT(TimeOfGaps.TimeOfGapsBetweenProcedures, ' ms') AS TimeOfGapsBetweenProcedures,
       CONCAT((TimeOfProcedures.TimeToRunProcedures + TimeOfGaps.TimeOfGapsBetweenProcedures), ' ms') AS TimeToLoadQCDatabase
FROM TimeToRunAllProcedures AS TimeOfProcedures
    CROSS JOIN TimeOfAllGapsBetweenAllProcedures AS TimeOfGaps;
GO
