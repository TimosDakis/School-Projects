USE [QueensClassSchedule];
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateModeOfInstruction]    Script Date: 5/7/2022 3:47:17 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Shivanie Kemraj
-- Create date: 2022-05-06
-- Description:	Generates a table to be used in loading [Class].[ModeOfInstruction]
-- =============================================
ALTER FUNCTION [Project3Function].[tvf_CreateModeOfInstruction]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           [Mode of Instruction] AS [ModeOfInstruction],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
);
