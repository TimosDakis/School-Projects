USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_DimCustomer]    Script Date: 4/1/2022 4:36:04 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-03-31
-- Description:	Loads data into [CH01-01-Dimension].[DimCustomer]
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimCustomer] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].[DimCustomer]
    (
        CustomerName,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           OLD.CustomerName,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD;

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_DimCustomer');

    EXEC ('CREATE VIEW G9_5.uvw_DimCustomer AS
	SELECT DC.CustomerKey,
           DC.CustomerName,
           DC.UserAuthorizationKey,
           DC.DateAdded,
           DC.DateOfLastUpdate FROM [CH01-01-Dimension].DimCustomer AS DC');

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].DimCustomer
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_DimCustomer] is loading data into [CH01-01-Dimension].[DimCustomer]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
