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

-- Time taken for all of each person's procedures
SELECT [UA].[UserAuthorizationKey],
       CONCAT([UA].[GroupMemberFirstName], ' ', [UA].[GroupMemberLastName]) AS [MemberName],
       CONCAT(SUM(DATEDIFF(MILLISECOND, [WFS].[StartingDateTime], [WFS].[EndingDateTime])), ' ms') AS [TimeToExecuteAllProcedures],
       CONCAT(
                 SUM(SUM(DATEDIFF(MILLISECOND, [WFS].[StartingDateTime], [WFS].[EndingDateTime]))) OVER (ORDER BY [UA].[UserAuthorizationKey]
                                                                                                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                                                                                        ),
                 ' ms'
             ) AS [RunningTotalTime]
FROM [Process].[WorkFlowStep] AS [WFS]
    INNER JOIN [DbSecurity].[UserAuthorization] AS [UA]
        ON [UA].[UserAuthorizationKey] = [WFS].[UserAuthorizationKey]
WHERE [WFS].[WorkFlowStepDescription] NOT LIKE '_____________________LoadQueens%'
GROUP BY [UA].[UserAuthorizationKey],
         CONCAT([UA].[GroupMemberFirstName], ' ', [UA].[GroupMemberLastName]);
GO

-- Time taken for each person's procedure and as a % of the overall loadqueenscollegeschedule procedure
WITH [ProcedureStats]
AS (SELECT [UA].[UserAuthorizationKey],
           CONCAT([UA].[GroupMemberFirstName], ' ', [UA].[GroupMemberLastName]) AS [MemberName],
           [WFS].[WorkFlowStepKey],
           [WFS].[WorkFlowStepDescription],
           DATEDIFF(MILLISECOND, [WFS].[StartingDateTime], [WFS].[EndingDateTime]) AS [TimeToExecuteProcedure],
           CAST(100. * DATEDIFF(MILLISECOND, [WFS].[StartingDateTime], [WFS].[EndingDateTime]) /
                (
                    SELECT SUM(DATEDIFF(MILLISECOND, [WFS2].[StartingDateTime], [WFS2].[EndingDateTime]))
                    FROM [Process].[WorkFlowStep] AS [WFS2]
                    WHERE [WFS2].[WorkFlowStepDescription] LIKE '_____________________LoadQueens%'
                ) AS NUMERIC(5, 2)) [PercentOfTimeToLoadQCDatabaseData]
    FROM [Process].[WorkFlowStep] AS [WFS]
        INNER JOIN [DbSecurity].[UserAuthorization] AS [UA]
            ON [UA].[UserAuthorizationKey] = [WFS].[UserAuthorizationKey]
    WHERE [WFS].[WorkFlowStepDescription] NOT LIKE '_____________________LoadQueens%')
SELECT [PS].[UserAuthorizationKey],
       [PS].[MemberName],
       [PS].[WorkFlowStepKey],
       [PS].[WorkFlowStepDescription],
       CONCAT([PS].[TimeToExecuteProcedure], 'ms') AS [TimeToExecuteProcedure],
       CONCAT(   SUM([PS].[TimeToExecuteProcedure]) OVER (ORDER BY [PS].[UserAuthorizationKey],
                                                                   [PS].[WorkFlowStepKey]
                                                          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                                         ),
                 'ms'
             ) AS [RunningTotalTime],
       CONCAT([PS].[PercentOfTimeToLoadQCDatabaseData], '%') AS [PercentOfTimeToLoadQCDatabaseData]
FROM [ProcedureStats] AS [PS]
ORDER BY [PS].[UserAuthorizationKey],
         [PS].[WorkFlowStepKey];
GO

-- Getting each persons work flow steps
-- Timothy's
SELECT CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName) AS MemberName,
       UA.UserAuthorizationKey,
       WFS.WorkFlowStepKey,
       WFS.WorkFlowStepDescription,
       WFS.WorkFlowStepTableRowCount,
       WFS.StartingDateTime,
       WFS.EndingDateTime,
	   CONCAT(DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime), ' ms') AS ExecutionTime,
       UA.ClassTime
FROM Process.WorkFlowStep AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE UA.UserAuthorizationKey = 1
ORDER BY WFS.WorkFlowStepKey;

-- Mikhaiel's
SELECT CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName) AS MemberName,
       UA.UserAuthorizationKey,
       WFS.WorkFlowStepKey,
       WFS.WorkFlowStepDescription,
       WFS.WorkFlowStepTableRowCount,
       WFS.StartingDateTime,
       WFS.EndingDateTime,
	   CONCAT(DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime), ' ms') AS ExecutionTime,
       UA.ClassTime
FROM Process.WorkFlowStep AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE UA.UserAuthorizationKey = 2
ORDER BY WFS.WorkFlowStepKey;

-- Shivanies's
SELECT CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName) AS MemberName,
       UA.UserAuthorizationKey,
       WFS.WorkFlowStepKey,
       WFS.WorkFlowStepDescription,
       WFS.WorkFlowStepTableRowCount,
       WFS.StartingDateTime,
       WFS.EndingDateTime,
	   CONCAT(DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime), ' ms') AS ExecutionTime,
       UA.ClassTime
FROM Process.WorkFlowStep AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE UA.UserAuthorizationKey = 3
ORDER BY WFS.WorkFlowStepKey;

-- Konrad's
SELECT CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName) AS MemberName,
       UA.UserAuthorizationKey,
       WFS.WorkFlowStepKey,
       WFS.WorkFlowStepDescription,
       WFS.WorkFlowStepTableRowCount,
       WFS.StartingDateTime,
       WFS.EndingDateTime,
	   CONCAT(DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime), ' ms') AS ExecutionTime,
       UA.ClassTime
FROM Process.WorkFlowStep AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE UA.UserAuthorizationKey = 4
ORDER BY WFS.WorkFlowStepKey;

-- Kevin's
SELECT CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName) AS MemberName,
       UA.UserAuthorizationKey,
       WFS.WorkFlowStepKey,
       WFS.WorkFlowStepDescription,
       WFS.WorkFlowStepTableRowCount,
       WFS.StartingDateTime,
       WFS.EndingDateTime,
	   CONCAT(DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime), ' ms') AS ExecutionTime,
       UA.ClassTime
FROM Process.WorkFlowStep AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE UA.UserAuthorizationKey = 5
ORDER BY WFS.WorkFlowStepKey;