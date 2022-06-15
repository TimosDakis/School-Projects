USE BIClass;

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