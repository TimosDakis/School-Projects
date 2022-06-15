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
GO

-- Time taken for all of each person's procedures
SELECT UA.UserAuthorizationKey,
       CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName) AS MemberName,
       CONCAT(SUM(DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime)), ' ms') AS TimeToExecuteAllProcedures
FROM Process.WorkFlowSteps AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE WFS.WorkFlowStepDescription NOT LIKE '____________LoadStar%'
GROUP BY UA.UserAuthorizationKey,
         CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName);
GO

-- Time taken for each person's procedure and as a % of the overall loadstarschemadata procedure
SELECT UA.UserAuthorizationKey,
       CONCAT(UA.GroupMemberFirstName, ' ', UA.GroupMemberLastName) AS MemberName,
       WFS.WorkFlowStepKey,
       WFS.WorkFlowStepDescription,
       CONCAT((DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime)), ' ms') AS TimeToExecuteProcedure,
       CONCAT(   CAST(100. * DATEDIFF(MILLISECOND, WFS.StartingDateTime, WFS.EndingDateTime) /
                      (
                          SELECT SUM(DATEDIFF(MILLISECOND, WFS2.StartingDateTime, WFS2.EndingDateTime))
                          FROM Process.WorkFlowSteps AS WFS2
                          WHERE WFS2.WorkFlowStepDescription LIKE '____________LoadStar%'
                      ) AS NUMERIC(5, 2)),
                 '%'
             ) AS PercentOfTimeToLoadStarSchemaData
FROM Process.WorkFlowSteps AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE WFS.WorkFlowStepDescription NOT LIKE '____________LoadStar%'
ORDER BY WFS.WorkFlowStepKey;
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
FROM Process.WorkFlowSteps AS WFS
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
FROM Process.WorkFlowSteps AS WFS
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
FROM Process.WorkFlowSteps AS WFS
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
FROM Process.WorkFlowSteps AS WFS
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
FROM Process.WorkFlowSteps AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE UA.UserAuthorizationKey = 5
ORDER BY WFS.WorkFlowStepKey;