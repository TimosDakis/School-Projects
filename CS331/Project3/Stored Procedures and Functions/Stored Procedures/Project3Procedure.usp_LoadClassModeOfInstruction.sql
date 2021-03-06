USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadClassModeOfInstruction]    Script Date: 5/8/2022 4:32:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shivanie Kemraj
-- Create date: 2022-05-06
-- Description:	Load data into [Class].[ClassModeOfInstruction]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadClassModeOfInstruction] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Class].[ClassModeOfInstruction]
    (
        [ClassId],
        [ModeId],
        [CourseName],
        [ModeOfInstruction],
        [UserAuthorizationKey]
    )
    SELECT [ClassId],
           [ModeId],
           [CourseName],
           [ModeOfInstruction],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateClassModeOfInstruction](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Class].[ClassModeOfInstruction]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = 3,
                                        @WorkFlowDescription = N'Loading data into [Class].[ClassModeOfInstruction]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;
