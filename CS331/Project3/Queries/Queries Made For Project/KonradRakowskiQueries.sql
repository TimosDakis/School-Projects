USE [QueensClassSchedule];


--Query 1: Which 5 instructors, with ties, offer the most hours to students.

SELECT DISTINCT TOP 5 WITH TIES
       [I].[InstructorFullName],
       SUM([Course].[CourseHour]) AS [HoursOffered]
FROM [Staff].[InstructorClass] AS [I]
    INNER JOIN [Class].[Class] AS [Class]
        ON [I].[ClassId] = [Class].[ClassId]
    INNER JOIN [Class].[Course] AS [Course]
        ON [Class].[CourseName] = [Course].[CourseName]
WHERE [InstructorFullName] <> 'TBD'
GROUP BY [I].[InstructorFullName]
ORDER BY SUM([Course].[CourseHour]) DESC;

GO

--Query 2: Which course has the most TBD days?

WITH [CourseTBD]
AS (SELECT [C].[CourseName],
           COUNT([C].[CourseName]) AS [Total]
    FROM [Class].[Class] AS [C]
    WHERE [C].[ClassTime] = 'TBD'
    GROUP BY [C].[CourseName])
SELECT TOP 1
       [TBD].[CourseName],
       [TBD].[Total]
FROM [CourseTBD] AS [TBD]
ORDER BY [TBD].[Total] DESC;