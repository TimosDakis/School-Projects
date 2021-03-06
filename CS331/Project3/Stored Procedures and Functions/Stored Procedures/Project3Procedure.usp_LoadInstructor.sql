USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadInstructor]    Script Date: 5/8/2022 5:29:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kevin Tang
-- Create date: 2022-05-07
-- Description:	Load data into [Staff].[Instructor]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadInstructor] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Staff].[Instructor]
    (
        [InstructorLastName],
        [InstructorFirstName],
        [UserAuthorizationKey]
    )
    SELECT [InstructorLastName],
           [InstructorFirstName],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateInstructor](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Staff].[Instructor]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Staff].[Instructor]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;