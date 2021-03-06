USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateDay]    Script Date: 5/8/2022 5:17:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kevin Tang
-- Create date: 2022-05-07
-- Description: Generates a table to be used in loading [Temporal].[Day]
-- =============================================

ALTER FUNCTION [Project3Function].[tvf_CreateDay]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [Day],
           CASE [Day]
               WHEN N'M' THEN
                   N'Monday'
               WHEN N'T' THEN
                   N'Tuesday'
               WHEN N'W' THEN
                   N'Wednesday'
               WHEN N'TH' THEN
                   N'Thursday'
               WHEN N'F' THEN
                   N'Friday'
               WHEN N'S' THEN
                   N'Saturday'
               WHEN N'SU' THEN
                   N'Sunday'
               ELSE
                   N'To Be Determined'
           END AS [DayName],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
);