 BEGIN TRY 
 Drop Function dbo.[F_Cost]
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
CREATE FUNCTION [dbo].[F_Cost]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here  select * from D_cost
	select mv.* from D_Cost mv
	inner join 
	(
	select  CostNo, MAX(RecordedDate) as ChangeDate
	from   dbo.D_Cost
	where (@ChangeDate is null or (RecordedDate <= @ChangeDate))
	group by CostNO
	) temp_Store on mv.CostNO = temp_Store.CostNO and mv.RecordedDate = temp_Store.ChangeDate
)



