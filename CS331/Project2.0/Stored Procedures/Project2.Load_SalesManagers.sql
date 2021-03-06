USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[Load_SalesManagers]    Script Date: 4/3/2022 4:17:08 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Kevin Tang
-- Create date: 2022-04-01
-- Description:	Loads data into [CH01-01-Dimension].[SalesManagers]
-- =============================================
ALTER PROCEDURE [Project2].[Load_SalesManagers] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].SalesManagers
    (
        Category,
        SalesManager,
        Office,
        UserAuthorizationKey
    )
    SELECT DISTINCT
           OLD.ProductSubcategory,
           OLD.SalesManager,
           Office = CASE
                        WHEN OLD.SalesManager LIKE 'Marco%' THEN
                            'Redmond'
                        WHEN OLD.SalesManager LIKE 'Alberto%' THEN
                            'Seattle'
                        WHEN OLD.SalesManager LIKE 'Maurizio%' THEN
                            'Redmond'
                        ELSE
                            'Seattle'
                    END,
           @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData AS OLD
    ORDER BY OLD.ProductSubcategory; -- Order by ProductSubcategory to mimic key mapping of initial table

    EXEC ('DROP VIEW IF EXISTS G9_5.uvw_SalesManagers');

    EXEC ('CREATE VIEW G9_5.uvw_SalesManagers AS
	SELECT SM.SalesManagerKey,
           SM.Category,
           SM.SalesManager,
           SM.Office,
           SM.UserAuthorizationKey,
           SM.DateAdded,
           SM.DateOfLastUpdate FROM [CH01-01-Dimension].SalesManagers AS SM
	'    );

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [CH01-01-Dimension].SalesManagers
            );

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[Load_SalesManagers] is loading data into [CH01-01-Dimension].[SalesManagers]',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
