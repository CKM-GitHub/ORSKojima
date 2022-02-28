
BEGIN  TRY 
Drop Procedure dbo.[_changedPass]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  _changedPass
	-- Add the parameters for the stored procedure here
	@CD as varchar(10),
	@pass as varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 
	 update ms set ms.Password=@pass  from M_Staff ms inner join F_Staff(GETDATE()) fs on ms.StaffCD= fs.StaffCD and ms.ChangeDate =fs.ChangeDate where ms.StaffCD= @CD
END
GO
