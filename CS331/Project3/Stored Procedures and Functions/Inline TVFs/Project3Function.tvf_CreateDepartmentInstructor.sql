USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateDepartmentInstructor]    Script Date: 5/8/2022 6:17:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:       Timothy Dakis
-- Create date:  2022-05-07
-- Description:  Generates a table to be used in loading [Staff].[DepartmentInstructor]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateDepartmentInstructor]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [D].[DepartmentId],
           [I].[InstructorId],
           [D].[DepartmentName] AS [Department],
           [I].[InstructorFullName],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
        INNER JOIN [Department].[Department] AS [D]
            ON LEFT([CCSCO].[Course (hr, crd)], CHARINDEX(' ', [CCSCO].[Course (hr, crd)]) - 1) = [D].[DepartmentName]
        INNER JOIN [Staff].[Instructor] AS [I]
            ON [CCSCO].[Instructor] = [I].[InstructorFullName]
);