USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[TruncateStarSchemaData]    Script Date: 4/2/2022 11:06:44 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Truncates the Star Schema and resets all related sequences
-- =============================================
ALTER PROCEDURE [Project2].[TruncateStarSchemaData] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- Truncate all tables
    TRUNCATE TABLE [CH01-01-Dimension].DimCustomer;
    TRUNCATE TABLE [CH01-01-Dimension].DimGender;
    TRUNCATE TABLE [CH01-01-Dimension].DimMaritalStatus;
    TRUNCATE TABLE [CH01-01-Dimension].DimOccupation;
    TRUNCATE TABLE [CH01-01-Dimension].DimOrderDate;
    TRUNCATE TABLE [CH01-01-Dimension].DimProduct;
    TRUNCATE TABLE [CH01-01-Dimension].DimProductSubcategory;
    TRUNCATE TABLE [CH01-01-Dimension].DimProductCategory;
    TRUNCATE TABLE [CH01-01-Dimension].DimTerritory;
    TRUNCATE TABLE [CH01-01-Dimension].SalesManagers;
    TRUNCATE TABLE [CH01-01-Fact].[Data];

    -- Reset all sequences
    ALTER SEQUENCE PkSequence.DataSequenceObject RESTART WITH 1;
    ALTER SEQUENCE PkSequence.DimCustomerSequenceObject RESTART WITH 1;
    ALTER SEQUENCE PkSequence.DimOccupationSequenceObject RESTART WITH 1;
    ALTER SEQUENCE PkSequence.DimProductSequenceObject RESTART WITH 1;
    ALTER SEQUENCE PkSequence.DimProductSubcategorySequenceObject
    RESTART WITH 1;
    ALTER SEQUENCE PkSequence.DimProductCategorySequenceObject RESTART WITH 1;
    ALTER SEQUENCE PkSequence.DimTerritorySequenceObject RESTART WITH 1;
    ALTER SEQUENCE PkSequence.SalesManagerSequenceObject RESTART WITH 1;

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'Truncate all tables of the Star Schema',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;

END;
