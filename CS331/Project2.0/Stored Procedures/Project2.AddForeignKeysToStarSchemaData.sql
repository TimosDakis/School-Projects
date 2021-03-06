USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[AddForeignKeysToStarSchemaData]    Script Date: 4/1/2022 5:42:14 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-01
-- Description:	Add the Foreign Keys to the Star Schema
-- =============================================
ALTER PROCEDURE [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    -- Adding Foreign Keys to CH01-01-Fact.Data table
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_SalesManagers
        FOREIGN KEY (SalesManagerKey)
        REFERENCES [CH01-01-Dimension].SalesManagers (SalesManagerKey),
        CONSTRAINT FK_Data_DimGender
        FOREIGN KEY (Gender)
        REFERENCES [CH01-01-Dimension].DimGender (Gender),
        CONSTRAINT FK_Data_DimMaritalStatus
        FOREIGN KEY (MaritalStatus)
        REFERENCES [CH01-01-Dimension].DimMaritalStatus (MaritalStatus),
        CONSTRAINT FK_Data_DimOccupation
        FOREIGN KEY (OccupationKey)
        REFERENCES [CH01-01-Dimension].DimOccupation (OccupationKey),
        CONSTRAINT FK_Data_DimOrderDate
        FOREIGN KEY (OrderDate)
        REFERENCES [CH01-01-Dimension].DimOrderDate (OrderDate),
        CONSTRAINT FK_Data_DimTerritory
        FOREIGN KEY (TerritoryKey)
        REFERENCES [CH01-01-Dimension].DimTerritory (TerritoryKey),
        CONSTRAINT FK_Data_DimProduct
        FOREIGN KEY (ProductKey)
        REFERENCES [CH01-01-Dimension].DimProduct (ProductKey),
        CONSTRAINT FK_Data_DimCustomer
        FOREIGN KEY (CustomerKey)
        REFERENCES [CH01-01-Dimension].DimCustomer (CustomerKey),
        CONSTRAINT FK_Data_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    -- Adding other Foreign Keys that link to DbSecurity.UserAuthorization
    ALTER TABLE [CH01-01-Dimension].DimCustomer
    ADD CONSTRAINT FK_DimCustomer_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimGender
    ADD CONSTRAINT FK_DimGender_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimMaritalStatus
    ADD CONSTRAINT FK_DimMaritalStatus_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimOccupation
    ADD CONSTRAINT FK_DimOccupation_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimOrderDate
    ADD CONSTRAINT FK_DimOrderDate_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimProduct
    ADD CONSTRAINT FK_DimProduct_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimProductCategory
    ADD CONSTRAINT FK_DimProductCategory_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimProductSubcategory
    ADD CONSTRAINT FK_DimProductSubcategory_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].DimTerritory
    ADD CONSTRAINT FK_DimTerritory_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE [CH01-01-Dimension].SalesManagers
    ADD CONSTRAINT FK_SalesManager_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    ALTER TABLE Process.WorkFlowSteps
    ADD CONSTRAINT FK_WorkFlowSteps_UserAuth
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization (UserAuthorizationKey);

    -- Creating Grandparent-parent-child relationship between ProductCategory-ProductSubcategory-Product

    ALTER TABLE [CH01-01-Dimension].DimProductSubcategory
    ADD CONSTRAINT FK_DimProductSubcategory_DimProductCategory
        FOREIGN KEY (ProductCategoryKey)
        REFERENCES [CH01-01-Dimension].DimProductCategory (ProductCategoryKey);

    ALTER TABLE [CH01-01-Dimension].DimProduct
    ADD CONSTRAINT FK_DimProduct_DimProductSubcategory
        FOREIGN KEY (ProductSubcategoryKey)
        REFERENCES [CH01-01-Dimension].DimProductSubcategory (ProductSubcategoryKey);

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'Adding all Foreign Keys to the Star Schema',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;

END;
