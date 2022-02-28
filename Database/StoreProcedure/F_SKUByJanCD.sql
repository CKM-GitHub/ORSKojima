 BEGIN TRY 
 Drop Function dbo.[F_SKUByJanCD]
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
CREATE FUNCTION [dbo].[F_SKUByJanCD]
(	
	-- Add the parameters for the function here
	@JanCD as varchar(13)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	
	select msku.* from M_SKU msku
	inner join 
	(
		select  JanCD,MAX(AdminNO) as AdminNO
		from    dbo.M_SKU
		where JanCD=@JanCD
		group by JanCD
	) temp_Store on msku.JanCD = temp_Store.JanCD  and msku.AdminNO=temp_Store.AdminNO
)

