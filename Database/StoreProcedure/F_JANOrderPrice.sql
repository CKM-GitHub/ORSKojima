 BEGIN TRY 
 Drop Function dbo.[F_JANOrderPrice]
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
Create FUNCTION [dbo].[F_JANOrderPrice]
(
 @ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select mj.VendorCD, mj.StoreCD , mj.AdminNo, mj.ChangeDate, mj.SKUCD, mj.Rate, mj.PriceWithoutTax, mj.Remarks, Isnull( cast(mj.DeleteFlg as varchar(10)),null) as DeleteFlg ,mj.UsedFlg from M_JANOrderPrice mj
	inner join 
	(
		select  VendorCD,StoreCD,AdminNO,MAX(ChangeDate) as ChangeDate
		from    dbo.M_JANOrderPrice
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by VendorCD,StoreCD,AdminNO,ChangeDate
	) 
	temp_Jan on mj.VendorCD = temp_Jan.VendorCD and mj.StoreCD=temp_Jan.StoreCD  and mj.AdminNO=temp_Jan.AdminNO and mj.ChangeDate=temp_Jan.ChangeDate
)


--select * from M_JANOrderPrice
