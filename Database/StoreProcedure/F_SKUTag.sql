 BEGIN TRY 
 Drop Function dbo.[F_SKUTag]
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
CREATE FUNCTION [dbo].[F_SKUTag]
(	
	-- Add the parameters for the function here
	@ChangeDate as date,
	@SEQ int=0
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	
	select mskut.* from M_SKUTag mskut
	inner join 
	(
		select  AdminNO, SEQ,MAX(ChangeDate) as ChangeDate
		from    dbo.M_SKUTag
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		and (@SEQ=0 or SEQ=@SEQ)
		group by AdminNO,SEQ
	) temp_Sku on mskut.AdminNO = temp_Sku.AdminNO and mskut.ChangeDate = temp_Sku.ChangeDate and mskut.SEQ=temp_Sku.SEQ
)





