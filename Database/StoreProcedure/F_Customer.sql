 BEGIN TRY 
 Drop Function dbo.[F_Customer]
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
CREATE FUNCTION [dbo].[F_Customer]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	
	select mc.* from M_Customer mc
	inner join 
	(
		select  CustomerCD,MAX(ChangeDate) as ChangeDate
		from    dbo.M_Customer
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by CustomerCD
	) temp_Store on mc.CustomerCD = temp_Store.CustomerCD and mc.ChangeDate = temp_Store.ChangeDate
)

