 BEGIN TRY 
 Drop Function dbo.[F_SKU]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create FUNCTION [dbo].[F_SKU]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	
	select msku.*, msku.SoldOutFlg  as _SoldOutflg , msku.NormalCost as _NormalCost ,  msku.OrderLot as  _orderlot , msku.ExhibitionSegmentCD as _ExhibitionSegmentCD from M_SKU msku
	inner join 
	(
		select  AdminNO,MAX(ChangeDate) as ChangeDate
		from    dbo.M_SKU
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by AdminNO
	) temp_Store on msku.AdminNO = temp_Store.AdminNO and msku.ChangeDate = temp_Store.ChangeDate
)

