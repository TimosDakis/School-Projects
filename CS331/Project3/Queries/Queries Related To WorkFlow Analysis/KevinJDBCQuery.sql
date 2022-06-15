USE [QueensClassSchedule];
EXEC Process.usp_ShowWorkflowStep;
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
FROM Process.WorkFlowStep AS WFS
    INNER JOIN DbSecurity.UserAuthorization AS UA
        ON UA.UserAuthorizationKey = WFS.UserAuthorizationKey
WHERE UA.UserAuthorizationKey = 5
ORDER BY WFS.WorkFlowStepKey;