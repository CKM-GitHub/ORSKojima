 BEGIN TRY 
 Drop Function dbo.[F_StoreAuthorizations]
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
CREATE FUNCTION [dbo].[F_StoreAuthorizations]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	select sautho.* from dbo.M_StoreAuthorizations sautho
	inner join
	(
	-- Add the SELECT statement with parameter references here
	select  StoreAuthorizationsCD, MAX(ChangeDate) as ChangeDate
	from    dbo.M_StoreAuthorizations
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	group by StoreAuthorizationsCD
	)temp_sautho on temp_sautho.StoreAuthorizationsCD = sautho.StoreAuthorizationsCD 
	and temp_sautho.ChangeDate = sautho.ChangeDate
)


