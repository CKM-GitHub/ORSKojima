 BEGIN TRY 
 Drop Function dbo.[F_VendorFTP]
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
CREATE FUNCTION [dbo].[F_VendorFTP]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select mv.* from M_VendorFTP mv
	inner join 
	(
	select  VendorCD,DataKBN, MAX(ChangeDate) as ChangeDate
	from   dbo.M_VendorFTP
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	group by VendorCD,DataKBN
	) temp_Store on mv.VendorCD = temp_Store.VendorCD and mv.ChangeDate = temp_Store.ChangeDate and mv.DataKBN=temp_Store.DataKBN
)



