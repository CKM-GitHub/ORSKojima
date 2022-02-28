 BEGIN TRY 
 Drop Function dbo.[F_SKUInfo]
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
CREATE FUNCTION [dbo].[F_SKUInfo]
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
	select mskuinfo.* from M_SKUInfo mskuinfo
	inner join 
	(
		select  AdminNO, SEQ,MAX(ChangeDate) as ChangeDate
		from    dbo.M_SKUInfo
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		and (@SEQ=0 or SEQ=@SEQ)
		group by AdminNO,SEQ
	) temp_Souko on mskuinfo.AdminNO = temp_Souko.AdminNO and mskuinfo.ChangeDate = temp_Souko.ChangeDate and mskuinfo.SEQ=temp_Souko.SEQ
)





