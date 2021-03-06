USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateClassModeOfInstruction]    Script Date: 5/8/2022 4:31:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shivanie Kemraj
-- Create date: 2022-05-06
-- Description:	Generates a table to be used in loading [Class].[ClassModeOfInstruction]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateClassModeOfInstruction]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [C].[ClassId] AS [ClassId],
           [CM].[ModeId] AS [ModeId],
           [C].[CourseName] AS [CourseName],
           [CO].[Mode of Instruction] AS [ModeOfInstruction],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CO]
        INNER JOIN [Class].[Class] AS [C]
            ON [C].[ClassCode] = [CO].[Code]
               AND [C].[ClassTime] = [CO].[Time]
               AND [C].[SectionCode] = [CO].[Sec]
        INNER JOIN [Class].[ModeOfInstruction] AS [CM]
            ON [CO].[Mode of Instruction] = [CM].[ModeOfInstruction]
);