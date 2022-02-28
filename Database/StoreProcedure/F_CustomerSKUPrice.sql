 BEGIN TRY 
 Drop Function dbo.[F_CustomerSKUPrice]
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
Create FUNCTION [dbo].[F_CustomerSKUPrice]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	
	select mc.* from M_CustomerSKUPrice mc
	inner join 
	(
		select  CustomerCD,AdminNO,MAX(TekiyouKaisiDate) as TekiyouKaisiDate
		from    dbo.M_CustomerSKUPrice
		where (@ChangeDate is null or (TekiyouKaisiDate <= @ChangeDate))
		group by CustomerCD,AdminNO
	) temp_sku on mc.CustomerCD = temp_sku.CustomerCD and mc.TekiyouKaisiDate = temp_sku.TekiyouKaisiDate and mc.AdminNO=temp_sku.AdminNO
)

