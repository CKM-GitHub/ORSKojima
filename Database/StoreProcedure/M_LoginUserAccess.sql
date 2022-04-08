BEGIN TRY 
 Drop PROCEDURE dbo.[M_LoginUserAccess]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[M_LoginUserAccess]
	@Login_ID as varchar(15)   ,
	 @Password as varchar(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists(select 1 from [User] where Login_ID=@Login_ID ) 
	begin
		select 'E101' as MessageID
		return;
	end
	
	select top 1 MS.* 
	,CONVERT(VARCHAR,GETDATE(),111) sysDate
	into #temp
	from [User] MS
	where MS.Login_ID = @Login_ID  
	 
	if not exists(select 1 from #temp where Password = @Password) 
	begin
		select 'E166' as MessageID
		drop table #temp
		return;
	end 
	select 'Allow' as MessageID,* from #temp

	drop table #temp
 
END
