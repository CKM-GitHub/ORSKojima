 BEGIN TRY 
 Drop PROCEDURE dbo.[M_LoginStaffSelect]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[M_LoginStaffSelect] 
	@Login_ID varchar(10),
	@Password varchar(10)
AS
BEGIN 
	SET NOCOUNT ON; 
	select top 1 * from [User]
	where Login_ID = @Login_ID
	and [Password] = @Password 
END