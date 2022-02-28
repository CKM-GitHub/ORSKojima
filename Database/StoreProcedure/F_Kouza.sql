 BEGIN TRY 
 Drop Function dbo.[F_Kouza]
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
CREATE FUNCTION [dbo].[F_Kouza]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here

	--select  KouzaCD, MAX(ChangeDate) as ChangeDate
	--from    dbo.M_Kouza
	--where ChangeDate <= @ChangeDate
	--group by KouzaCD

	select mk.* from M_Kouza mk
	inner join 
	(
		select  KouzaCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_Kouza
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by KouzaCD
	) temp_Kouza on mk.KouzaCD = temp_Kouza.KouzaCD and mk.ChangeDate = temp_Kouza.ChangeDate

)


