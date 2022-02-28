 BEGIN TRY 
 Drop Function dbo.[F_Sales]
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
CREATE FUNCTION [dbo].[F_Sales]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	select ds.* from D_Sales ds
	inner join 
	(
		select  StoreCD, MAX(SalesDate) as ChangeDate
		from    dbo.D_Sales
		where (@ChangeDate is null or (SalesDate <= @ChangeDate))
		group by StoreCD
	) temp_Store on ds.StoreCD = temp_Store.StoreCD and ds.SalesDate = temp_Store.ChangeDate
)


