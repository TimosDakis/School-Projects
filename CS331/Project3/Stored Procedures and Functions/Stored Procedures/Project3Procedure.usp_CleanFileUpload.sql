USE [QueensClassSchedule]
GO
/****** Object:  StoredProcedure [Project3Procedure].[usp_CleanFileUpload]    Script Date: 5/6/2022 7:17:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Timothy Dakis
-- Create date: 2022-05-06
-- Description:	Clean [Uploadfile].[CurrentSemesterCourseOfferings] by making [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
-- =============================================
ALTER PROCEDURE [Project3Procedure].[usp_CleanFileUpload] @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @ProcStartTime DATETIME2 = SYSDATETIME();
    /* 
	Make a duplicate of CurrentSemesterCourseOfferings to apply the changes to
	Reason for this approach:
		to make functions/procedures used to fill in database tables easier to set up, manage, and read
		as all cleansing for source data was done prior to inserting into tables
	*/
    BEGIN TRY
        BEGIN TRAN;
        DROP TABLE IF EXISTS [Uploadfile].[CleanedCurrentSemesterCourseOfferings];
        SELECT [Semester],
               [Sec],
               [Code],
               [Course (hr, crd)],
               [Description],
               [Day],
               [Time],
               [Instructor],
               [Location],
               [Enrolled],
               [Limit],
               [Mode of Instruction],
               -- Adds an Overtally column
               CASE
                   WHEN CAST([Limit] AS INT) <> 0
                        AND CAST([Enrolled] AS INT) > CAST([Limit] AS INT) THEN
                       CAST([Enrolled] AS INT) - CAST([Limit] AS INT)
                   ELSE
                       0
               END AS [Overtally]
        INTO [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        FROM [Uploadfile].[CurrentSemesterCourseOfferings];

        -- If Overtallied, then cap enrolled at limit (do this so we can in future apply a constraint where Enrolled is <= Limit
        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Enrolled] = [Limit]
        WHERE [Overtally] <> 0;

        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Day] = N'TBD'
        WHERE [Day] = N'';

        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Time] = N'TBD'
        WHERE [Time] IN ( '-', '12:00 AM - 12:00 AM' );

        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Instructor] = N'TBD'
        WHERE [Instructor] = N',';

        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Location] = N'TBD'
        WHERE [Location] = N'';

        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Sec] = CONCAT(0, [Sec])
        WHERE LEN([Sec]) = 1;

        -- The following is splitting Day column values with 3 days into rows of 1 day each
        INSERT INTO [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        (
            [Semester],
            [Sec],
            [Code],
            [Course (hr, crd)],
            [Description],
            [Day],
            [Time],
            [Instructor],
            [Location],
            [Enrolled],
            [Limit],
            [Mode of Instruction],
            [Overtally]
        )
        SELECT [CCSCO].[Semester],
               [CCSCO].[Sec],
               [CCSCO].[Code],
               [CCSCO].[Course (hr, crd)],
               [CCSCO].[Description],
               LEFT([Day], CHARINDEX(',', [Day]) - 1) AS [Day],
               [CCSCO].[Time],
               [CCSCO].[Instructor],
               [CCSCO].[Location],
               [CCSCO].[Enrolled],
               [CCSCO].[Limit],
               [CCSCO].[Mode of Instruction],
               [CCSCO].[Overtally]
        FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
        WHERE LEN([CCSCO].[Day]) - LEN(REPLACE([CCSCO].[Day], ',', '')) = 2;

        -- Convert the 3 days into the remaining 2 days => can deal with it as a 2 day column
        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Day] = SUBSTRING([Day], CHARINDEX(N',', [Day]) + 2, 100)
        WHERE LEN([Day]) - LEN(REPLACE([Day], ',', '')) = 2;

        -- The following is splitting Day column values with 2 days into rows of 1 day each
        INSERT INTO [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        (
            [Semester],
            [Sec],
            [Code],
            [Course (hr, crd)],
            [Description],
            [Day],
            [Time],
            [Instructor],
            [Location],
            [Enrolled],
            [Limit],
            [Mode of Instruction],
            [Overtally]
        )
        SELECT [CCSCO].[Semester],
               [CCSCO].[Sec],
               [CCSCO].[Code],
               [CCSCO].[Course (hr, crd)],
               [CCSCO].[Description],
               SUBSTRING([Day], CHARINDEX(N',', [Day]) + 2, 100) AS [Day],
               [CCSCO].[Time],
               [CCSCO].[Instructor],
               [CCSCO].[Location],
               [CCSCO].[Enrolled],
               [CCSCO].[Limit],
               [CCSCO].[Mode of Instruction],
               [CCSCO].[Overtally]
        FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings] AS [CCSCO]
        WHERE LEN([CCSCO].[Day]) - LEN(REPLACE([CCSCO].[Day], ',', '')) = 1;

        UPDATE [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
        SET [Day] = LEFT([Day], CHARINDEX(',', [Day]) - 1)
        WHERE LEN([Day]) - LEN(REPLACE([Day], ',', '')) = 1;
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF (XACT_STATE()) = -1
            ROLLBACK TRAN;
    END CATCH;

    DECLARE @ProcEndTime DATETIME2 = SYSDATETIME();

    DECLARE @ProcWorkFlowTableRowCount INT =
            (
                SELECT COUNT(*)FROM [Uploadfile].[CleanedCurrentSemesterCourseOfferings]
            );

    EXEC [Process].[usp_TrackWorkFlows] @UserAuthorizationKey = @UserAuthorizationKey,
                                        @WorkFlowDescription = N'Created [Uploadfile].[CleanedCurrentSemesterCourseOfferings]',
                                        @WorkFlowStepTableRowCount = @ProcWorkFlowTableRowCount,
                                        @StartTime = @ProcStartTime,
                                        @EndTime = @ProcEndTime;
END;