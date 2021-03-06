USE [QueensClassSchedule]
GO
/****** Object:  UserDefinedFunction [Project3Function].[tvf_CreateDepartment]    Script Date: 5/8/2022 4:14:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================
-- Author:        Konrad Rakowski
-- Create date:   2022-05-07
-- Description :  Generates a table to be used in loading [Department].[Department]
-- =========================================================================
ALTER FUNCTION [Project3Function].[tvf_CreateDepartment]
(
    @UserAuthorizationKey INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
           LEFT([Offer].[Course (hr, crd)], CHARINDEX(' ', [Offer].[Course (hr, crd)]) - 1) AS [DepartmentName],
           @UserAuthorizationKey AS [UserAuthorizationKey]
    FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [Offer]
);