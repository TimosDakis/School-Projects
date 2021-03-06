USE [BIClass];
GO
/****** Object:  StoredProcedure [Utils].[DropProcsInCSCI331FinalProject]    Script Date: 4/2/2022 11:26:00 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-04-02
-- Description:	Drops all procedures of the Star Schema
-- =============================================
ALTER PROCEDURE [Utils].[DropProcsInCSCI331FinalProject] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    --select concat('drop prodcedure if exists  ', schema_name(o.schema_id), '.', name)
    --from sys.objects as o
    --where o.type = 'P'
    --      and o.schema_id = 9;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();

    DROP PROC IF EXISTS Project2.Load_SalesManagers;
    DROP PROC IF EXISTS Project2.Load_DimProductSubcategory;
    DROP PROC IF EXISTS Project2.Load_DimProductCategory;
    DROP PROC IF EXISTS Project2.Load_DimGender;
    DROP PROC IF EXISTS Project2.Load_DimMaritalStatus;
    DROP PROC IF EXISTS Project2.Load_DimOccupation;
    DROP PROC IF EXISTS Project2.Load_DimOrderDate;
    DROP PROC IF EXISTS Project2.Load_DimTerritory;
    DROP PROC IF EXISTS Project2.Load_DimProduct;
    DROP PROC IF EXISTS Project2.Load_DimCustomer;
    DROP PROC IF EXISTS Project2.Load_Data;
    DROP PROC IF EXISTS Project2.TruncateStarSchemaData;
    DROP PROC IF EXISTS Project2.LoadStarSchemaData;
    DROP PROC IF EXISTS Project2.AddForeignKeysToStarSchemaData;
    DROP PROC IF EXISTS Project2.DropForeignKeysFromStarSchemaData;
    DROP PROC IF EXISTS Project2.ShowTableStatusRowCount;

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT = 0;

    EXEC Process.usp_TrackWorkFlows @UserAuthorizationKey = @UserAuthorizationKey,
                                    @WorkFlowDescription = N'[Utils].[DropProcsInCSCI331FinalProject] dropped all procedures of the Star Schema',
                                    @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                    @StartTime = @ProcStartTime,
                                    @EndTime = @ProcEndTime;
END;
