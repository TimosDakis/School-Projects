/*
	Exclude '0' as consider that "unlimited enrollment / no cap"
	Looking for all cases where enrollment exceeds limit
	Response: 
		Likely make an overtally column, and when load table, decrease enrollment by overtally
		or just include the overtally column in it and call it a day
		difference in results primarily comes down to if we want a check constraint on if enrolled <= Limit or not
*/
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings
WHERE CAST(Enrolled AS INT) > CAST(Limit AS INT) AND CAST(Limit AS INT) <> 0 -- 546 rows

/*
	Brief overall look to spot any initial potential data anomalies
	Checking length as all things are strings and there are certain minimum lengths each would logically have
*/
SELECT COUNT(*) AS [InvalidSemesterCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Semester) <= 2 -- 0
SELECT COUNT(*) AS [InvalidSectionCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Sec) < 1 -- 0
SELECT COUNT(*) AS [InvalidCodeCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Code) <= 2 -- 0
SELECT COUNT(*) AS [InvalidCourseCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN([Course (hr, crd)]) <= 2 -- 0
SELECT COUNT(*) AS [InvalidDescriptionCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Description) <= 1 -- 0
SELECT COUNT(*) AS [InvalidDayCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Day) < 1 -- 1226
SELECT COUNT(*) AS [InvalidTimeCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Time) <= 1 -- 729
SELECT COUNT(*) AS [InvalidInstructorCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Instructor) <= 1 -- 170
SELECT COUNT(*) AS [InvalidLocationCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Location) <= 1 -- 1315
SELECT COUNT(*) AS [InvalidEnrolledCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Enrolled) < 1 -- 0
SELECT COUNT(*) AS [InvalidLimitCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Limit) < 1 -- 0
SELECT COUNT(*) AS [InvalidModeOfInstructionCount] FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN([Mode of Instruction]) <= 2 -- 0

-- Only rows to return "invalids": Day, Time, Instructor, and Location

-- Looking at "Day" issues:
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE DAY NOT LIKE N'[A-Z]%' -- Matches the 1226 rows found above
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE DAY = N'' -- Also matches the 1226 rows found
/*
	Analysis result:
		Issue: Day is empty string
		Solution: Whenever Day is empty string, make it "TBD", as it is probably the day just was not decided yet
		Notes: Also seem to occur where time is either "-", or where the time doesnt make sense (e.g. "12:00 AM - 12:00 AM)
*/

-- Looking at things related to "Time" issues:
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE DAY = N'' AND Time = N'-' -- 725 rows
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE DAY <> N'' AND Time = N'-' -- 4 rows
-- 725 + 4 = 729 => MATCHES count of rows above, so that only found cases of where Time was '-'

-- Returns 0 rows
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Time) <= 1
EXCEPT
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE Time = N'-'

-- Returns 0 rows
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE Time = N'-'
EXCEPT
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Time) <= 1
-- This indeed shows that the issue found initially was the cases where Time = '-'
	
/*
	However, noted there are other issues too (where range of time is XX:XX-XX:XX (i.e. where they are the same)
	There are atleast 1226 - 725 = 501 of these cases
*/
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE DAY = N'' AND Time = N'12:00 AM - 12:00 AM' -- This finds all 501 of those rows
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE DAY <> N'' AND Time = N'12:00 AM - 12:00 AM' -- This finds 6 more of these kinds of issue
-- Do a more general query for this XX:XX-XX:XX time issue (i.e. where the start and end times are same, as does not make sense):

-- This also finds 507 rows, so all the issues are where 12:00 AM - 12:00 AM. Likely just some default value
SELECT *
FROM Uploadfile.CurrentSemesterCourseOfferings
WHERE Time <> N'-'
      AND LEFT(Time, CHARINDEX(N'-', Time) - 2) = SUBSTRING(Time, CHARINDEX(N'-', Time) + 2, 100);

SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE Time IN ('-', '12:00 AM - 12:00 AM') -- 1236 affected rows overall = 507 + 729
/*
	Analysis result:
		Issue: Time is either '-' or '12:00 AM - 12:00 AM'
		Solution: Where time is either '-' or '12:00 AM - 12:00 AM', make it 'TBD'
		Reasoning: '-' may have been some filler for not decided, and '12:00 AM - 12:00 AM' just seems like some default value for if no insertions were done
*/

-- Looking at "Instructor" issues
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE Instructor NOT LIKE N'[A-Z]%' -- 170 rows, matches count of issues above
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE Instructor = ',' -- 170 rows, matches count of issues above
/*
	Analysis result:
		Issue: Instructor is ','
		Solution: Where Instructor is ',', make it 'TBD'
		Reasoning: ',' may have been some filler for not decided
*/

-- Looking at "Location" issues
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE Location NOT LIKE N'[A-Z]%' -- 1315 rows, matches the count above
SELECT * FROM uploadfile.CurrentSemesterCourseOfferings WHERE Location = N'' -- 1315 rows, matches count of issues above
/*
	Analysis result:
		Issue: Location is ''
		Solution: Where Location is '', make it 'TBD'
		Reasoning: '' may have been some filler for not decided
*/

-- Issue, data consistency. Some Sections are formatted as X for single digit, whilst others are 0X
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Sec) = 1 -- 771 such cases where its X and not 0X
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE Sec LIKE '0%' -- 2636 such cases where it is 0X and not X
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Sec) <> 1 AND Sec NOT LIKE '0%' -- 1115 rows for any other section case (sums to 4522 rows = all rows in fileupload)
/*
	Analysis result:
		Issue: Some single-digit sections are formatted as X while others are 0X
		Solution: Format X to be 0X
		Reasoning: Majority is formatted as 0X, so consistency wise its most logical to make them all that way
*/

-- Case where there are 2 days in the "Day" column
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE CHARINDEX(',', Day) <> 0 -- 1427 rows
/*
	Issue: To be in normal form, they should be their own row
	Solution: Split it
	Reason: So that it makes it more convenient to load tables, as it allows for more maintainable code to be written
			as opposed to setting up the code again.
*/

SELECT DAY, LEFT(Day, CHARINDEX(',', Day) - 1) AS Day1, SUBSTRING(Day, CHARINDEX(N',', Day) + 2, 100) AS Day2 FROM Uploadfile.CurrentSemesterCourseOfferings WHERE CHARINDEX(',', Day) <> 0
-- issue: there are some Day columns where "Day" has >2 days in it, so need to deal with that somehow:

SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Day) - LEN(REPLACE(Day, ',', '')) = 1 -- 1418 rows (filters out all where there are 2 days in day)
SELECT * FROM Uploadfile.CurrentSemesterCourseOfferings WHERE LEN(Day) - LEN(REPLACE(Day, ',', '')) = 2 -- 9 rows (filters out all where there are 3 days in day), sums to 1427

-- How to break up when there are 2 days:
SELECT Day,
       LEFT(Day, CHARINDEX(',', Day) - 1) AS Day1,
       SUBSTRING(Day, CHARINDEX(N',', Day) + 2, 100) AS Day2
FROM Uploadfile.CurrentSemesterCourseOfferings
WHERE LEN(Day) - LEN(REPLACE(Day, ',', '')) = 1

-- How to break up when there are 3 days:
;WITH [Day1andDay2+]
AS (SELECT Day,
           LEFT(Day, CHARINDEX(',', Day) - 1) AS Day1,
           SUBSTRING(Day, CHARINDEX(N',', Day) + 2, 100) AS [Day2+]
    FROM Uploadfile.CurrentSemesterCourseOfferings
    WHERE LEN(Day) - LEN(REPLACE(Day, ',', '')) = 2)
SELECT Day,
       Day1,
       LEFT([Day2+], CHARINDEX(',', [Day2+]) - 1) AS Day2,
       SUBSTRING([Day2+], CHARINDEX(N',', [Day2+]) + 2, 100) AS Day3
FROM [Day1andDay2+];
-- By adding all these days as individual rows, expect there to be 1418 + 2*9 = 1436 extra rows in the fileupload table
-- This means in total the cleaned fileupload table will have 4522 + 1436 = 5958 rows