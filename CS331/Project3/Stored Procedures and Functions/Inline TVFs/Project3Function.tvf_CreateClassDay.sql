USE [QueensClassSchedule];
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateClassDay]    Script Date: 5/7/2022 9:36:35 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:         Timothy Dakis
-- Create date:	   2022-05-07
-- Description:    Generates a table to be used in loading [Class].[ClassDay]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateClassDay]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [C].[ClassId],
           [CCSCO].[Day] AS [DayCode],
           [C].[CourseName],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
        INNER JOIN [Class].[Class] AS [C]
            ON [CCSCO].[Sec] = [C].[SectionCode]
               AND [CCSCO].[Code] = [C].[ClassCode]
               AND [CCSCO].[Time] = [C].[ClassTime]
);