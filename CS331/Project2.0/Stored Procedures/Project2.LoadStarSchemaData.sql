USE [BIClass];
GO
/****** Object:  StoredProcedure [Project2].[LoadStarSchemaData]    Script Date: 4/2/2022 10:59:54 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Loads all data into the Star Schema
-- =============================================
ALTER PROCEDURE [Project2].[LoadStarSchemaData] @UserAuthorizationKey INT
-- Add the parameters for the stored procedure here
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();
    --
    --	Drop All of the foreign keys prior to truncating tables in the star schema
    --
    EXEC [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 1;
    --
    --	Check row count before truncation
    EXEC [Project2].[ShowTableStatusRowCount] @TableStatus = N'''Pre-truncate of tables''',
                                              @UserAuthorizationKey = 1;

    --
    --	Always truncate the Star Schema Data
    --
    EXEC [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 1;
    --
    --	Load the star schema
    --
    EXEC [Project2].[Load_DimProductCategory] @UserAuthorizationKey = 1;
    EXEC [Project2].[Load_DimProductSubcategory] @UserAuthorizationKey = 1;
    EXEC [Project2].[Load_DimProduct] @UserAuthorizationKey = 1;
    EXEC [Project2].[Load_SalesManagers] @UserAuthorizationKey = 5;
    EXEC [Project2].[Load_DimGender] @UserAuthorizationKey = 2;
    EXEC [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey = 2;
    EXEC [Project2].[Load_DimOccupation] @UserAuthorizationKey = 3;
    EXEC [Project2].[Load_DimOrderDate] @UserAuthorizationKey = 4;
    EXEC [Project2].[Load_DimTerritory] @UserAuthorizationKey = 3;
    EXEC [Project2].[Load_DimCustomer] @UserAuthorizationKey = 1;
    EXEC [Project2].[Load_Data] @UserAuthorizationKey = 1;
    --
    --	Recreate all of the foreign keys prior after loading the star schema
    --
    --
    --	Check row count before truncation
    EXEC [Project2].[ShowTableStatusRowCount] @TableStatus = N'''Row Count after loading the star schema''',
                                              @UserAuthorizationKey = 1;

    --
    EXEC [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 1;

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Project2].[LoadStarSchemaData] is loading the Star Schema',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
--
END;
