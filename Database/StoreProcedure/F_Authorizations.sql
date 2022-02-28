 BEGIN TRY 
 Drop Function dbo.[F_Authorizations]
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
CREATE FUNCTION [dbo].[F_Authorizations]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	select autho.* from dbo.M_Authorizations autho
	inner join
	(
	-- Add the SELECT statement with parameter references here
	select  AuthorizationsCD, MAX(ChangeDate) as ChangeDate
	from    dbo.M_Authorizations
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	group by AuthorizationsCD
	)temp_autho on temp_autho.AuthorizationsCD = autho.AuthorizationsCD 
	and temp_autho.ChangeDate = autho.ChangeDate
)


