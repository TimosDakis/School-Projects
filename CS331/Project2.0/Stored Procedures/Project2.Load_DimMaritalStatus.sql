USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimMaritalStatus]    Script Date: 4/3/2022 3:27:13 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Mikhaiel Gomes
-- Create date: 2022-04-02
-- Description:	Loading data into [CH01-01-Dimension].[DimMaritalStatus] 
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].[DimMaritalStatus]
    (
        MaritalStatus,
        MaritalStatusDescription,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           OLD.MaritalStatus,
           MaritalStatusDescription = (CASE OLD.MaritalStatus
                                           WHEN 'S' THEN
                                               'Single'
                                           ELSE
                                               'Married'
                                       END
                                      ),
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;



    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimMaritalStatus');

    EXEC ('CREATE VIEW G9_5.uvw_DimMaritalStatus AS
	SELECT DMS.MaritalStatus,
           DMS.MaritalStatusDescription,
           DMS.UserAuthorizationKey,
           DMS.DateAdded,
           DMS.DateOfLastUpdate FROM [CH01-01-Dimension].DimMaritalStatus AS DMS');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimMaritalStatus
            );
    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimMaritalStatus] is loading data into [CH01-01-Dimension].[DimMaritalStatus]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
