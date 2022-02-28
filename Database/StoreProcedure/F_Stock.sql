 BEGIN TRY 
 Drop Function dbo.[F_Stock]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[F_Stock]
(	
	-- Add the parameters for the function here
	@ArrivalDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select ds.* from D_Stock ds
	inner join 
	(
		select  StockNO, MAX(ArrivalDate) as ArrivalDate
		from    dbo.D_Stock
		where (@ArrivalDate is null or (ArrivalDate <= @ArrivalDate))
		group by StockNO
	) temp_Stock on ds.StockNO = temp_Stock.StockNO and ds.ArrivalDate = temp_Stock.ArrivalDate
)


