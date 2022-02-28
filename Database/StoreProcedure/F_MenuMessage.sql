 BEGIN TRY 
 Drop Function dbo.[F_MenuMessage]
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
CREATE FUNCTION [dbo].[F_MenuMessage]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select ms.* from D_MenuMessage ms
	inner join 
	(
	select  StoreCD, MAX(ChangeDate) as ChangeDate
	from    dbo.D_MenuMessage
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	group by StoreCD
	) temp_Store on ms.StoreCD = temp_Store.StoreCD and ms.ChangeDate = temp_Store.ChangeDate
)


