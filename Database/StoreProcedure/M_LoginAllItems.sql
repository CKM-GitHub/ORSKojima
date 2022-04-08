BEGIN TRY 
 Drop PROCEDURE dbo.[M_LoginAllItems]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[M_LoginAllItems]
	@Login_ID as varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select programEXE    from M_Program 
END
