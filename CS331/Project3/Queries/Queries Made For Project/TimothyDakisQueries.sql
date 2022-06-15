USE [QueensClassSchedule];

/*
	Query 1: Show all instructors who are teaching in classes in multiple departments
*/

SELECT DISTINCT
       [DI1].[InstructorId],
       [DI1].[InstructorFullName],
	   COUNT([DI1].[DepartmentId]) AS NumberOfDepartments
FROM [Staff].[DepartmentInstructor] AS [DI1]
GROUP BY [DI1].[InstructorId], [DI1].[InstructorFullName]
HAVING COUNT([DI1].[DepartmentId]) > 1
ORDER BY COUNT([DI1].[DepartmentId]) DESC;

/*
	Query 2: How many instructors are in each department?
*/

SELECT [DI1].[DepartmentId],
       [DI1].[Department],
       COUNT([DI1].[InstructorId]) AS [NumberOfInstructors]
FROM [Staff].[DepartmentInstructor] AS [DI1]
GROUP BY [DI1].[DepartmentId],
         [DI1].[Department]
ORDER BY COUNT([DI1].[InstructorId]) DESC;

/*
	3) How may classes that are being taught that semester grouped by course
	   and aggregating the total enrollment, total class limit and the percentage of enrollment.
*/

SELECT [C].[CourseName],
       COUNT([C].[ClassId]) AS [NumberOfUniqueClasses],
       SUM([C].[TotalEnrollmentInClass]) AS [TotalEnrolled],
       SUM([C].[ClassLimit]) AS [TotalLimit],
       CONCAT(LEFT(CAST(100.0 * SUM([C].[TotalEnrollmentInClass]) / (SUM([C].[ClassLimit])) AS Nvarchar(30)), 5), '%') AS [PercentEnrolled]
FROM [Class].[Class] AS [C]
    INNER JOIN [Staff].[InstructorClass] AS [IC]
        ON [IC].[ClassId] = [C].[ClassId]
WHERE [C].[ClassLimit] > 0 -- Filter out as these classes are limitless
GROUP BY [C].[CourseName]
ORDER BY 100 * SUM([C].[TotalEnrollmentInClass]) / (SUM([C].[ClassLimit])) DESC;