BEGIN TRY 
	Drop Procedure dbo.[M_Souko_SelectForTanaban]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[M_Souko_SelectForTanaban]
	-- Add the parameters for the stored procedure here
	@StoreCD as varchar(4)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--コンボ表示用Select  Union結合でTopを使用したいのでinner joinを使用
	select sok.*, 1 as ordernum
	from M_Souko sok
	inner join
	(
		select top 1 sok.SoukoCD, sok.ChangeDate
		from M_Souko sok
		inner join F_Souko(getdate()) fs 
		on fs.SoukoCD = sok.SoukoCD
		and fs.ChangeDate = sok.ChangeDate
		where sok.StoreCD = @StoreCD 
		and sok.DeleteFlg = 0
		and sok.SoukoType = 3
		order by sok.SoukoCD
	) Sub
	on Sub.SoukoCD = sok.SoukoCD
	and Sub.ChangeDate = sok.ChangeDate

	union

	--コンボlList用Select
	select sok.*,  2 as ordernum
	from F_Souko (getdate()) sok
	left join 
	(
		select top 1 sok.SoukoCD, sok.ChangeDate
		from M_Souko sok
		inner join F_Souko(getdate()) fs 
		on fs.SoukoCD = sok.SoukoCD
		and fs.ChangeDate = sok.ChangeDate
		where sok.StoreCD = 1 
		and sok.DeleteFlg = 0
		and sok.SoukoType = 3
		order by sok.SoukoCD

	) Sub
	on Sub.SoukoCD = sok.SoukoCD
	and sub.ChangeDate = sok.ChangeDate
	where sok.DeleteFlg = 0
	and sok.SoukoType in (3,4)
	and Sub.SoukoCD is null
	order by ordernum, sok.StoreCD, sok.SoukoCD


END
