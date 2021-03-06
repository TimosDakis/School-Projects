USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[ShowTableStatusRowCount]    Script Date: 4/2/2022 11:17:08 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Creates a table showing number of rows in each table of the Star Schema
-- =============================================
ALTER PROCEDURE [Project2].[ShowTableStatusRowCount]
    @TableStatus VARCHAR(64),
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- UNION ALL between each select so only 1 output is generated
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimCustomer',
           NumberOfRows = COUNT(*)
    FROM [CH01-01-Dimension].DimCustomer
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimGender',
           COUNT(*)
    FROM [CH01-01-Dimension].DimGender
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimMaritalStatus',
           COUNT(*)
    FROM [CH01-01-Dimension].DimMaritalStatus
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimOccupation',
           COUNT(*)
    FROM [CH01-01-Dimension].DimOccupation
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimOrderDate',
           COUNT(*)
    FROM [CH01-01-Dimension].DimOrderDate
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimProduct',
           COUNT(*)
    FROM [CH01-01-Dimension].DimProduct
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimProductCategory',
           COUNT(*)
    FROM [CH01-01-Dimension].DimProductCategory
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimProductSubcategory',
           COUNT(*)
    FROM [CH01-01-Dimension].DimProductSubcategory
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimTerritory',
           COUNT(*)
    FROM [CH01-01-Dimension].DimTerritory
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.SalesManagers',
           COUNT(*)
    FROM [CH01-01-Dimension].SalesManagers
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Fact.Data',
           COUNT(*)
    FROM [CH01-01-Fact].[Data];

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();
    DECLARE @ProcWorkFlowTableRowCount INT = 0;
    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[ShowTableStatusRowCount] counted rows of all tables',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;

END;