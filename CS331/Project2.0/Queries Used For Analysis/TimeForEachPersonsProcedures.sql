USE BIClass;

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