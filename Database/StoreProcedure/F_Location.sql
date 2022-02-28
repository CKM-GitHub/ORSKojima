 BEGIN TRY 
 Drop Function dbo.[F_Location]
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
CREATE FUNCTION [dbo].[F_Location]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select ml.* from M_Location ml
	inner join 
	(
		select  TanaCD,SoukoCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_Location
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by SoukoCD,TanaCD
	) temp_Location on ml.SoukoCD = temp_Location.SoukoCD and ml.ChangeDate = temp_Location.ChangeDate and ml.TanaCD = temp_Location.TanaCD
)


