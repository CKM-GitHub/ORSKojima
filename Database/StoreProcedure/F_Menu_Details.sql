 BEGIN TRY 
 Drop Function dbo.[F_Menu_Details]
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
CREATE FUNCTION [dbo].[F_Menu_Details]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	select mm.* from M_MenuDetails mm
	inner join
	(
	-- Add the SELECT statement with parameter references here
	select  MenuID, MAX(ChangeDate) as ChangeDate
	from    dbo.M_MenuDetails
	where (@ChangeDate is null or ( ChangeDate <= @ChangeDate))
	group by dbo.M_MenuDetails.MenuID
	)temp_Menu on mm.MenuID = temp_Menu.MenuID and temp_Menu.ChangeDate = mm.ChangeDate
)


