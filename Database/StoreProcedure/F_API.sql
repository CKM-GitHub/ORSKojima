 BEGIN TRY 
 Drop Function dbo.[F_API]
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
Create FUNCTION [dbo].[F_API]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here  select * from D_cost
	select mv.* from M_API mv
	inner join 
	(
	select  APIKey, MAX(ChangeDate) as ChangeDate
	from   dbo.M_API
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	group by APIKey
	) temp_Store on mv.APIKey = temp_Store.APIKey and mv.ChangeDate = temp_Store.ChangeDate
)



