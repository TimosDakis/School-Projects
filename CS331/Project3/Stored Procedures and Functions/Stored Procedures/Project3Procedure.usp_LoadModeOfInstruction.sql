USE [QueensClassSchedule];
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_LoadModeOfInstruction]    Script Date: 5/7/2022 3:50:08 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Shivanie Kemraj
-- Create date: 2022-05-06
-- Description:	Load data into [Class].[ModeOfInstruction]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_LoadModeOfInstruction] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Class].[ModeOfInstruction]
    (
        [ModeOfInstruction],
        [UserAuthorizationKey]
    )
    SELECT [ModeOfInstruction],
           [UserAuthorizationKey]
    FROM [Project3Function].[tvf_CreateModeOfInstruction](@UserAuthorizationKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Class].[ModeOfInstruction]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Loading data into [Class].[ModeOfInstruction]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;