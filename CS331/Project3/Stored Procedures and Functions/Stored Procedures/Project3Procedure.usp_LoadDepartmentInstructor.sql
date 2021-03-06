USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadDepartmentInstructor]    Script Date: 5/8/2022 6:20:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-07
-- Description:	Load data into [Staff].[DepartmentInstructor]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadDepartmentInstructor] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Staff].[DepartmentInstructor]
    (
        [DepartmentId],
        [InstructorId],
        [Department],
        [InstructorFullName],
        [UserAuthorizationKey]
    )
    SELECT [DepartmentId],
           [InstructorId],
           [Department],
           [InstructorFullName],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateDepartmentInstructor](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Staff].[DepartmentInstructor]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Staff].[DepartmentInstructor]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;