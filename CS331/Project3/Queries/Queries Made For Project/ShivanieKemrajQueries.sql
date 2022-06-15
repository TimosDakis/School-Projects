USE [QueensClassSchedule];

-- 1) Which instructors teach a class on the weekend, and how many classes do they teach?
SELECT [IC].[InstructorFullName],
       COUNT([CD].[ClassId]) AS [Classes on Weekend]
FROM [Staff].[InstructorClass] AS [IC]
    INNER JOIN [Class].[ClassDay] AS [CD]
        ON [IC].[ClassId] = [CD].[ClassId]
WHERE [CD].[DayCode] = 'S'
      OR [CD].[DayCode] = 'SU'
GROUP BY [IC].[InstructorFullName];
GO

-- 2) How many times does each professor use a mode of instruction?

SELECT [IC].[InstructorFullName],
       [CM].[ModeOfInstruction],
       COUNT([CM].[ModeId]) AS [Times Used]
FROM [Staff].[InstructorClass] AS [IC]
    INNER JOIN [Class].[ClassModeOfInstruction] AS [CM]
        ON [IC].[ClassId] = [CM].[ClassId]
GROUP BY [CM].[ModeOfInstruction],
         [IC].[InstructorFullName];
GO

-- 3) How many different instructors teach each course, and who is/are the instructor(s) that teach that course the most?

WITH [CourseAndCount]
AS (SELECT [CourseName],
           COUNT([InstructorId]) AS [Total Instructors],
           COUNT(DISTINCT [InstructorId]) AS [Total Unique Instructors]
    FROM [Staff].[InstructorClass]
    GROUP BY [CourseName]),
     [AmountInstructorTaughtACourse]
AS (SELECT [CourseName],
           [InstructorFullName],
           COUNT(*) AS [TimesTaughtTheCourse]
    FROM [Staff].[InstructorClass]
    GROUP BY [CourseName],
             [InstructorFullName])
SELECT [CAC].[CourseName],
       [CAC].[Total Instructors],
       [CAC].[Total Unique Instructors],
       [AITAC].[InstructorFullName] AS [Instructor Who Taught Course Most],
       [AITAC].[TimesTaughtTheCourse] AS [Times Instructor Taught Course]
FROM [CourseAndCount] AS [CAC]
    INNER JOIN [AmountInstructorTaughtACourse] AS [AITAC]
        ON [AITAC].[CourseName] = [CAC].[CourseName]
WHERE [AITAC].[InstructorFullName] IN
      (
          SELECT TOP (1) WITH TIES
                 [AITAC2].[InstructorFullName]
          FROM [AmountInstructorTaughtACourse] AS [AITAC2]
          WHERE [AITAC2].[CourseName] = [CAC].[CourseName]
          ORDER BY [AITAC2].[TimesTaughtTheCourse] DESC
      );