USE [QueensClassSchedule]

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