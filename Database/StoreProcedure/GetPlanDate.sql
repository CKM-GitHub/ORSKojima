 BEGIN TRY 
 Drop Function dbo.[GetPlanDate]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetPlanDate]
(
    @PlanDate date,
    @IdoCount tinyInt,
    @StorePlaceKBN tinyInt
)
RETURNS DATE
AS
BEGIN
    
    DECLARE @ResultDay date;
    
    IF @IdoCount = 0
    BEGIN
        SET @ResultDay = @PlanDate;
        RETURN @ResultDay;
    END
        
    IF @StorePlaceKBN = 1
        SELECT @ResultDay = W.CalendarDate
        FROM(
            SELECT M.CalendarDate, ROW_NUMBER() OVER (ORDER BY M.CalendarDate) AS RowNumber
            FROM M_Calendar AS M
            WHERE M.CalendarDate >= @PlanDate
            AND M.DayOff1 = 0
            )W
        WHERE W.RowNumber = @IdoCount

    ELSE IF @StorePlaceKBN = 2
        SELECT @ResultDay = W.CalendarDate
        FROM(
            SELECT M.CalendarDate, ROW_NUMBER() OVER (ORDER BY M.CalendarDate) AS RowNumber
            FROM M_Calendar AS M
            WHERE M.CalendarDate >= @PlanDate
            AND M.DayOff2 = 0
            )W
        WHERE W.RowNumber = @IdoCount
    ELSE IF @StorePlaceKBN = 3
        SELECT @ResultDay = W.CalendarDate
        FROM(
            SELECT M.CalendarDate, ROW_NUMBER() OVER (ORDER BY M.CalendarDate) AS RowNumber
            FROM M_Calendar AS M
            WHERE M.CalendarDate >= @PlanDate
            AND M.DayOff3 = 0
            )W
        WHERE W.RowNumber = @IdoCount
    ELSE IF @StorePlaceKBN = 4
        SELECT @ResultDay = W.CalendarDate
        FROM(
            SELECT M.CalendarDate, ROW_NUMBER() OVER (ORDER BY M.CalendarDate) AS RowNumber
            FROM M_Calendar AS M
            WHERE M.CalendarDate >= @PlanDate
            AND M.DayOff4 = 0
            )W
        WHERE W.RowNumber = @IdoCount
    ELSE IF @StorePlaceKBN = 5
        SELECT @ResultDay = W.CalendarDate
        FROM(
            SELECT M.CalendarDate, ROW_NUMBER() OVER (ORDER BY M.CalendarDate) AS RowNumber
            FROM M_Calendar AS M
            WHERE M.CalendarDate >= @PlanDate
            AND M.DayOff5 = 0
            )W
        WHERE W.RowNumber = @IdoCount
    ELSE IF @StorePlaceKBN = 6
        SELECT @ResultDay = W.CalendarDate
        FROM(
            SELECT M.CalendarDate, ROW_NUMBER() OVER (ORDER BY M.CalendarDate) AS RowNumber
            FROM M_Calendar AS M
            WHERE M.CalendarDate >= @PlanDate
            AND M.DayOff6 = 0
            )W
        WHERE W.RowNumber = @IdoCount
    ELSE
        SET @ResultDay = @PlanDate;
    
    RETURN @ResultDay;
END



