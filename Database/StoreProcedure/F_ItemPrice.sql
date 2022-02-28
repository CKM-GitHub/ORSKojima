 BEGIN TRY 
 Drop Function dbo.[F_ItemPrice]
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
CREATE FUNCTION [dbo].[F_ItemPrice]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
		select mi.* from M_ItemPrice mi
	inner join 
	(
		select  ITemCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_ItemPrice
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by ITemCD
	) temp_item on mi.ITemCD = temp_item.ITemCD and mi.ChangeDate = temp_item.ChangeDate
)





