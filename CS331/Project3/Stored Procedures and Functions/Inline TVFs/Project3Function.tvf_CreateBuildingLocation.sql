USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateBuildingLocation]    Script Date: 5/8/2022 4:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Mikhaiel Gomes
-- Create date:   2022-05-07
-- Description:   Generates a table to be used in loading [Location].[BuildingLocation]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateBuildingLocation]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    WITH [BuildingAbbreviations]
    AS (SELECT DISTINCT
               LEFT([CCSCO1].[Location], 2) AS [BuildingAbbreviation]
        FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO1]
        WHERE [Location] <> N'TBD'
        UNION
        SELECT DISTINCT
               [Location]
        FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO2]
        WHERE [CCSCO2].[Location] = N'TBD')
    SELECT [BA].[BuildingAbbreviation],
           CASE [BA].[BuildingAbbreviation]
               WHEN N'AR' THEN
                   'No Corresponding Name #1' -- Could not find corresponding name
               WHEN N'CD' THEN
                   'No Corresponding Name #2' -- Could not find corresponding name
               WHEN N'CH' THEN
                   'Colwin Hall'
               WHEN N'DY' THEN
                   'Delany Hall'
               WHEN N'FG' THEN
                   'FitzGerald Gym'
               WHEN N'GB' THEN
                   'G Building'
               WHEN N'GC' THEN
                   'Gertz Center'
               WHEN N'GT' THEN
                   'Goldstein Theatre'
               WHEN N'HH' THEN
                   'Honors Hall'
               WHEN N'IB' THEN
                   'I Building'
               WHEN N'JH' THEN
                   'Jefferson Hall'
               WHEN N'KG' THEN
                   'King Hall'
               WHEN N'KY' THEN
                   'Kiely Hall'
               WHEN N'KP' THEN
                   'Klapper Hall'
               WHEN N'MU' THEN
                   'Music Building'
               WHEN N'PH' THEN
                   'Powdermaker Hall'
               WHEN N'QH' THEN
                   'Queens Hall'
               WHEN N'RA' THEN
                   'Rathaus Hall'
               WHEN N'RE' THEN
                   'Remsen Hall'
               WHEN N'RO' THEN
                   'Rosenthal Library'
               WHEN N'RZ' THEN
                   'Razran Hall'
               WHEN N'SB' THEN
                   'Science Building'
               WHEN N'SU' THEN
                   'Student Union'
               ELSE
                   'To Be Determined'
           END AS [BuildingName],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [BuildingAbbreviations] AS [BA]
);