 BEGIN TRY 
 Drop Function dbo.[F_Purchase]
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
CREATE FUNCTION [dbo].[F_Purchase]
(	
	-- Add the parameters for the function here
	@PurchaseDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT dp.*  from D_Purchase dp
	inner join
	(
		select PurchaseNO,MAX(PurchaseDate)as PurchaseDate  from dbo.D_Purchase
		where (@PurchaseDate is null or (PurchaseDate<=@PurchaseDate))
		group by PurchaseNO
	) temp_Purchase
	on dp.PurchaseNO=temp_Purchase.PurchaseNO and dp.PurchaseDate=temp_Purchase.PurchaseDate

)



