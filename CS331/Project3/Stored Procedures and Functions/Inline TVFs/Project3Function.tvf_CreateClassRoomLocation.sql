USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateClassRoomLocation]    Script Date: 5/8/2022 6:02:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:       Timothy Dakis
-- Create date:  2022-05-07
-- Description:  Generates a table to be used in loading [Location].[ClassRoomLocation]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateClassRoomLocation]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
       [C].[ClassId],
       [RL].[RoomId],
       [C].[CourseName],
       [RL].[BuildingOfRoom] AS [Building],
       [RL].[Room],
       @UserAuthorizationKey AS [UserAuthorizationKey]
FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
    INNER JOIN [Class].[Class] AS [C]
        ON [CCSCO].[Sec] = [C].[SectionCode]
           AND [CCSCO].[Code] = [C].[ClassCode]
           AND [CCSCO].[Time] = [C].[ClassTime]
    INNER JOIN [Location].[RoomLocation] AS [RL]
        ON [CCSCO].[Location] = [RL].[Room]
);