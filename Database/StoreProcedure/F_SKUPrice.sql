 BEGIN TRY 
 Drop Function dbo.[F_SKUPrice]
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
CREATE FUNCTION [dbo].[F_SKUPrice]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select msp.* from M_SKUPrice msp
	inner join 
	(
		select  TankaCD,StoreCD,AdminNO, MAX(ChangeDate) as ChangeDate
		from    dbo.M_SKUPrice
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by TankaCD,StoreCD,AdminNO
	) temp_Bank on msp.TankaCD = temp_Bank.TankaCD 
	and msp.StoreCD=temp_Bank.StoreCD
	and msp.AdminNO=temp_Bank.AdminNO
	and msp.ChangeDate = temp_Bank.ChangeDate
)


