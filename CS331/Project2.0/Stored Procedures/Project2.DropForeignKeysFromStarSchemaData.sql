USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[DropForeignKeysFromStarSchemaData]    Script Date: 4/1/2022 5:51:22 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-01
-- Description:	Drop the Foreign Keys from the Star Schema
-- =============================================
ALTER PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- Dropping all Foreign Keys from CH01-01-Fact.Data table
    ALTER TABLE [CH01-01-Fact].[Data]
    DROP CONSTRAINT FK_Data_SalesManagers,
         CONSTRAINT FK_Data_DimGender,
         CONSTRAINT FK_Data_DimMaritalStatus,
         CONSTRAINT FK_Data_DimOccupation,
         CONSTRAINT FK_Data_DimOrderDate,
         CONSTRAINT FK_Data_DimTerritory,
         CONSTRAINT FK_Data_DimProduct,
         CONSTRAINT FK_Data_DimCustomer,
         CONSTRAINT FK_Data_UserAuth;

    -- Dropping other Foreign Keys that link to DbSecurity.UserAuthorization

    ALTER TABLE [CH01-01-Dimension].DimCustomer
    DROP CONSTRAINT FK_DimCustomer_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimGender
    DROP CONSTRAINT FK_DimGender_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimMaritalStatus
    DROP CONSTRAINT FK_DimMaritalStatus_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimOccupation
    DROP CONSTRAINT FK_DimOccupation_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimOrderDate
    DROP CONSTRAINT FK_DimOrderDate_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimProduct
    DROP CONSTRAINT FK_DimProduct_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimProductCategory
    DROP CONSTRAINT FK_DimProductCategory_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimProductSubcategory
    DROP CONSTRAINT FK_DimProductSubcategory_UserAuth;

    ALTER TABLE [CH01-01-Dimension].DimTerritory
    DROP CONSTRAINT FK_DimTerritory_UserAuth;

    ALTER TABLE [CH01-01-Dimension].SalesManagers
    DROP CONSTRAINT FK_SalesManager_UserAuth;

    ALTER TABLE Process.WorkFlowSteps
    DROP CONSTRAINT FK_WorkFlowSteps_UserAuth;

    -- Dropping Grandparent-parent-child relationship between ProductCategory-ProductSubcategory-Product
    ALTER TABLE [CH01-01-Dimension].DimProductSubcategory
    DROP CONSTRAINT FK_DimProductSubcategory_DimProductCategory;

    ALTER TABLE [CH01-01-Dimension].DimProduct
    DROP CONSTRAINT FK_DimProduct_DimProductSubcategory;

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'Dropping all Foreign Keys from the Star Schema',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
