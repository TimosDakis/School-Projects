--1) List the instructor and all their classes, where the instructor is part of multiple departments
SELECT DISTINCT
       [IC].[InstructorId],
       [IC].[InstructorFullName],
       [IC].[CourseName]
FROM [Staff].[InstructorClass] AS [IC]
WHERE [IC].[InstructorId] IN
      (
          SELECT DISTINCT
                 [DI].[InstructorId]
          FROM [Staff].[DepartmentInstructor] AS [DI]
          GROUP BY [InstructorId]
          HAVING COUNT([DepartmentId]) > 1
      );
GO

--2) Find all the classes that are taking place in Kiely Hall, and who is teaching it?
SELECT [CRL].[ClassId],
       [CRL].[CourseName],
       [CRL].[Room],
       [IC].[InstructorFullName]
FROM [QueensClassSchedule].[Location].[ClassRoomLocation] AS [CRL]
    JOIN [Staff].[InstructorClass] AS [IC]
        ON [IC].[ClassId] = [CRL].[ClassId]
WHERE [CRL].[Building] = N'KY';
GO

--3) Which class is taught by the most number of instructors?
SELECT TOP (1)
       [CourseName],
       COUNT(DISTINCT [InstructorId]) AS [Count]
FROM [QueensClassSchedule].[Staff].[InstructorClass]
GROUP BY [CourseName]
ORDER BY [Count] DESC;