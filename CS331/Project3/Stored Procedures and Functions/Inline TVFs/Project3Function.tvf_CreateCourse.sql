USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateCourse]    Script Date: 5/8/2022 4:22:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================
-- Author:        Konrad Rakowski
-- Create date:   2022-05-07
-- Description :  Generates a table to be used in loading [Class].[Course]
-- =========================================================================
ALTER FUNCTION [Project3Function].[tvf_CreateCourse]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           LEFT([Offer].[Course (hr, crd)], CHARINDEX(' (', [Offer].[Course (hr, crd)]) - 1) AS [CourseName],
           [Offer].[Description] AS [CourseDescription],
           SUBSTRING(
                        LEFT([Offer].[Course (hr, crd)], CHARINDEX(',', [Offer].[Course (hr, crd)]) - 1),
                        CHARINDEX('(', [Offer].[Course (hr, crd)]) + 1,
                        LEN(LEFT([Offer].[Course (hr, crd)], CHARINDEX(',', [Offer].[Course (hr, crd)]) - 1)) - 1
                    ) AS [CourseHour],
           SUBSTRING(
                        LEFT([Offer].[Course (hr, crd)], CHARINDEX(')', [Offer].[Course (hr, crd)]) - 1),
                        CHARINDEX(', ', [Offer].[Course (hr, crd)]) + 2,
                        LEN(LEFT([Offer].[Course (hr, crd)], CHARINDEX(')', [Offer].[Course (hr, crd)]) - 1)) - 1
                    ) AS [CourseCredit],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [Offer]
);