 BEGIN TRY 
 Drop Function dbo.[F_StorePoint]
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
CREATE FUNCTION [dbo].[F_StorePoint]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select mb.* from M_StorePoint mb
	inner join 
	(
		select  StoreCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_StorePoint
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by StoreCD
	) temp_Bank on mb.StoreCD = temp_Bank.StoreCD and mb.ChangeDate = temp_Bank.ChangeDate
)


