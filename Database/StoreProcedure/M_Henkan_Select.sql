BEGIN TRY 
	Drop Procedure [dbo].[M_Henkan_Select] 
END TRY
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[M_Henkan_Select] 
	-- Add the parameters for the stored procedure here
	@TokuisakiCD nvarchar(5),
	@RCMItemName nvarchar(50),
	@RCMItemValue  nvarchar(50)
	
AS
BEGIN

	SET NOCOUNT ON;

   
	SELECT *

	From M_Henkan 
	
	Where TokuisakiCD = @TokuisakiCD
	AND  RCMItemName=@RCMItemName
	AND  RCMItemValue=@RCMItemValue

END


