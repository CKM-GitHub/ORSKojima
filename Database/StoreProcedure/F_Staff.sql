 BEGIN TRY 
 Drop Function dbo.[F_Staff]
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
CREATE FUNCTION [dbo].[F_Staff]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select ms.* from M_Staff ms
	inner join 
	(
	select  StaffCD,  MAX(ChangeDate) as ChangeDate
	from    dbo.M_Staff
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	group by StaffCD
	) temp_Store on ms.StaffCD = temp_Store.StaffCD and ms.ChangeDate = temp_Store.ChangeDate
)


