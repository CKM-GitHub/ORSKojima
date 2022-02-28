 BEGIN TRY 
 Drop Function dbo.[F_AuthorizationsDetails]
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
CREATE FUNCTION [dbo].[F_AuthorizationsDetails]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select ma.* from M_AuthorizationsDetails ma
	inner join(
	SELECT 
		AuthorizationsCD,
		MAX(ChangeDate) AS ChangeDate,
		ProgramID
	FROM dbo.M_AuthorizationsDetails
	WHERE ChangeDate <= @ChangeDate
	GROUP BY AuthorizationsCD,ProgramID) temp_Auth on ma.AuthorizationsCD = temp_Auth.AuthorizationsCD and ma.ProgramID = temp_Auth.ProgramID and ma.ChangeDate = temp_Auth.ChangeDate
)


