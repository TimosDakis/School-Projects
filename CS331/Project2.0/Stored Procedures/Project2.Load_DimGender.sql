USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimGender]    Script Date: 4/3/2022 3:10:13 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Mikhaiel Gomes
-- Create date: 2022-04-01
-- Description:	Loads data into [CH01-01-Dimension].[DimGender]
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimGender] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();
    INSERT INTO [CH01-01-Dimension].[DimGender]
    (
        Gender,
        GenderDescription,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           OLD.Gender,
           GenderDescription = (CASE OLD.Gender
                                    WHEN 'M' THEN
                                        'Male'
                                    ELSE
                                        'Female'
                                END
                               ),
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimGender');

    EXEC ('CREATE VIEW G9_5.uvw_DimGender AS
	SELECT DG.Gender,
           DG.GenderDescription,
           DG.UserAuthorizationKey,
           DG.DateAdded,
           DG.DateOfLastUpdate FROM [CH01-01-Dimension].DimGender AS DG');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimGender
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimGender] is loading data into [CH01-01-Dimension].[DimGender]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
