USE BIClass
EXEC Process.usp_ShowWorkflowSteps;
GO

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