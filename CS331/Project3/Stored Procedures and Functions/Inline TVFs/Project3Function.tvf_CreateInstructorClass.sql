USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateInstructorClass]    Script Date: 5/8/2022 6:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:       Timothy Dakis
-- Create date:  2022-05-07
-- Description:  Generates a table to be used in loading [Staff].[InstructorClass]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateInstructorClass]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [I].[InstructorId],
           [C].[ClassId],
           [I].[InstructorFullName],
           [C].[CourseName],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
        INNER JOIN [Class].[Class] AS [C]
            ON [CCSCO].[Sec] = [C].[SectionCode]
               AND [CCSCO].[Code] = [C].[ClassCode]
               AND [CCSCO].[Time] = [C].[ClassTime]
        INNER JOIN [Staff].[Instructor] AS [I]
            ON [CCSCO].[Instructor] = [I].[InstructorFullName]
);