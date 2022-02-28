 BEGIN TRY 
 Drop Function dbo.[F_Bank]
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
CREATE FUNCTION [dbo].[F_Bank]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select mb.* from M_Bank mb
	inner join 
	(
		select  BankCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_Bank
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by BankCD
	) temp_Bank on mb.BankCD = temp_Bank.BankCD and mb.ChangeDate = temp_Bank.ChangeDate
)


