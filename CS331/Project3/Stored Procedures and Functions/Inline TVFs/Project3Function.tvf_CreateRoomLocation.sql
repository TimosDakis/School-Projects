USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateRoomLocation]    Script Date: 5/8/2022 5:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Mikhaiel Gomes
-- Create date:   2022-05-07
-- Description:   Generates a table to be used in loading [Location].[RoomLocation]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateRoomLocation]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [Location] AS [Room],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [QueensClassSchedule].[Uploadfile].[CleanedCurrentSemesterCourseOfferings]
);