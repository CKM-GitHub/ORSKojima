 BEGIN TRY 
 Drop Function dbo.[F_Arrival]
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
CREATE FUNCTION [dbo].[F_Arrival]
(	
	-- Add the parameters for the function here
	@ArrivalDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT da.*  from D_Arrival da
	inner join
	(
		select ArrivalNO,MAX(ArrivalDate)as ArrivalDate  from dbo.D_Arrival
		where (@ArrivalDate is null or (ArrivalDate<=@ArrivalDate))
		group by ArrivalNO
	) temp_Arrival
	on da.ArrivalNO=temp_Arrival.ArrivalNO and da.ArrivalDate=temp_Arrival.ArrivalDate
)


