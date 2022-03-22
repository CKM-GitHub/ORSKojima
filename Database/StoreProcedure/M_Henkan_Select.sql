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
	@TokuisakiCD varchar(5),
	@RCMItemName varchar(50),
	@RCMItemValue  varchar(50)
	
AS
BEGIN

	SET NOCOUNT ON;

   
	SELECT *

	From M_Henkan 
	
	Where TokuisakiCD = @TokuisakiCD
	AND  RCMItemName=@RCMItemName
	AND  RCMItemValue=@RCMItemValue

END


