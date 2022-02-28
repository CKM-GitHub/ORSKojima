 BEGIN TRY 
 Drop Function dbo.[F_ITemorderprice]
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
CREATE FUNCTION [dbo].[F_ITemorderprice] 
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
		SELECT mi.*
		FROM M_ITemorderprice as mi
			inner join(
			SELECT VendorCD,StoreCD,MakerITem,MAX(ChangeDate) as ChangeDate
			FROM M_ItemOrderPrice 
			WHERE (ChangeDate is Null or  (ChangeDate <= @ChangeDate))
			group by VendorCD,StoreCD,MakerITem
			)tm on mi.VendorCD=tm.VendorCD and mi.StoreCD=tm.StoreCD and mi.MakerITem =tm.MakerItem and mi.ChangeDate=tm.ChangeDate
		
)

