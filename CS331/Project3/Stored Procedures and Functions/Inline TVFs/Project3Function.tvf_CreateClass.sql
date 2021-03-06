USE [QueensClassSchedule];
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateClass]    Script Date: 5/6/2022 6:58:23 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-06
-- Description:	Generates a table to be used in loading [Class].[Class]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateClass]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [Semester] AS [SemesterOfClass],
           [Sec] AS [SectionCode],
           [Code] AS [ClassCode],
           LEFT([Course (hr, crd)], CHARINDEX('(', [Course (hr, crd)]) - 1) AS [CourseName],
           [Time] AS [ClassTime],
           [Limit] AS [ClassLimit],
           [Enrolled] AS [EnrolledInClass],
           [Overtally] AS [ClassOvertally],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
);