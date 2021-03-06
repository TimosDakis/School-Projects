USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateInstructor]    Script Date: 5/8/2022 5:25:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Kevin Tang
-- Create date: 2022-05-07
-- Description: Generates a table to be used in loading [Staff].[Instructor]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateInstructor]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [Instructor] AS [InstructorFullName],
           LEFT([CCSCO].[Instructor], CHARINDEX(', ', [CCSCO].[Instructor]) - 1) AS [InstructorLastName],
           RIGHT([CCSCO].[Instructor], LEN([CCSCO].[Instructor]) - CHARINDEX(', ', [CCSCO].[Instructor]) - 1) AS [InstructorFirstName],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
    WHERE [Instructor] <> 'TBD'
    UNION
    SELECT DISTINCT
           [Instructor],
           N'TBD',
           N'TBD',
           @UserAuthorizationKey
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
    WHERE [Instructor] = N'TBD'
);