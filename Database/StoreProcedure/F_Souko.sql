 BEGIN TRY 
 Drop Function dbo.[F_Souko]
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
CREATE FUNCTION [dbo].[F_Souko]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select ms.* from M_Souko ms
	inner join 
	(
		select  SoukoCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_Souko
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by SoukoCD
	) temp_Souko on ms.SoukoCD = temp_Souko.SoukoCD and ms.ChangeDate = temp_Souko.ChangeDate
)





