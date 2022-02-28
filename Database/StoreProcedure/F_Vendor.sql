 BEGIN TRY 
 Drop Function dbo.[F_Vendor]
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
CREATE FUNCTION [dbo].[F_Vendor]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select mv.* from M_Vendor mv
	inner join 
	(
	select  VendorCD,MAX(ChangeDate) as ChangeDate
	from   dbo.M_Vendor
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	group by VendorCD
	) temp_Store on mv.VendorCD = temp_Store.VendorCD and mv.ChangeDate = temp_Store.ChangeDate
)



