 BEGIN TRY 
 Drop Function dbo.[M_LoginChangedPass]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE  [dbo].[M_LoginChangedPass]
	-- Add the parameters for the stored procedure here
	@CD as varchar(10),
	@pass as varchar(10)
AS
BEGIN 
	SET NOCOUNT ON;

	 
	 update ms set ms.Password=@pass  from [User] ms where ms.Login_ID= @CD
END

