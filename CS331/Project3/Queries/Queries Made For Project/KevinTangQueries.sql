USE [QueensClassSchedule];

-- Query 1: How many courses take place in each building, and how many different rooms are used per building?

SELECT [Building],
       COUNT(DISTINCT [CourseName]) AS [NumberOfCourses],
       COUNT(DISTINCT [Room]) AS [NumberOfRooms]
FROM [Location].[ClassRoomLocation]
GROUP BY [Building];
GO

-- Query 2: How many students are enrolled in each department?

SELECT [D].[DepartmentName],
       SUM([C].[TotalEnrollmentInClass]) AS [TotalStudentsEnrolled]
FROM [Class].[Class] AS [C]
    INNER JOIN [Department].[Department] AS [D]
        ON LEFT([C].[CourseName], CHARINDEX(' ', [C].[CourseName]) - 1) = [D].[DepartmentName]
GROUP BY [D].[DepartmentName]
ORDER BY [TotalStudentsEnrolled] DESC;