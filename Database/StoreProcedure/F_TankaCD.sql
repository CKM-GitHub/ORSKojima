 BEGIN TRY 
 Drop Function dbo.[F_TankaCD]
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
Create FUNCTION [dbo].[F_TankaCD]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select mtk.* from M_TankaCD mtk
	inner join 
	(
		select  TankaCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_TankaCD
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by TankaCD
	) temp_Tanka on mtk.TankaCD = temp_Tanka.TankaCD and mtk.ChangeDate = temp_Tanka.ChangeDate
)





