BEGIN TRY 
 Drop PROCEDURE dbo.[M_LoginUserInitSelect]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[M_LoginUserInitSelect]
	-- Add the parameters for the stored procedure here
	@Login_ID varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1 MS.* 
	,CONVERT(VARCHAR,GETDATE(),111) sysDate
	from [User] MS
	where MS.Login_ID = @Login_ID  
END


