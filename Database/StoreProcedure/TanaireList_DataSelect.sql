 BEGIN TRY 
 Drop Procedure dbo.[TanaireList_DataSelect]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TanaireList_DataSelect]
	-- Add the parameters for the stored procedure here
	@SoukoCD varchar(6),
	@SKUCD varchar(30),
	@ArrivalStartDate  varchar(10),
	@ArrivalEndDate  varchar(10),
	@RegisterFlg nvarchar(10),
	@LocationFlg nvarchar(10),
	@Option varchar(2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Declare	@query nvarchar(max)
	
	
	if(@Option='2')
	begin
	
	if @ArrivalStartDate IS null
		set @ArrivalStartDate=''

		set @query='

		SELECT ds.RackNO,
		ds.SKUCD,
		case when ds.RackNO is null 
			then
			 case when ds.RackNO is null then '''' else ds.RackNO end
			else ''''
		end as ''RackNo1'',
		msku.Rack,
		msku.SKUName,
		ds.StockSu,
		ds.JanCD,
		msku.ColorName,
		msku.SizeName,
		CONVERT(VARCHAR(10), ds.ArrivalDate , 111) as ArrivalDate,
		ds.ReserveSu,
		ds.StockSu-ds.ReserveSu as DiffSu
		from  F_Stock(CONVERT(VARCHAR(10), getdate() , 120)) ds
		Left Outer Join F_SKU(CONVERT(VARCHAR(10), getdate() , 120)) as msku on ds.JanCD=msku.JanCD and ds.SKUCD=msku.SKUCD and msku.AdminNO<=ds.AdminNO
		--left outer join F_Stock(CONVERT(VARCHAR(10), getdate() , 120)) as fs on fs.SoukoCD=ds.SoukoCD and fs.SKUCD=ds.SKUCD and fs.StockSu>0
		Left Outer Join D_ArrivalPlan as dar on dar.ArrivalPlanNO = ds.ArrivalPlanNO and dar.DeleteDateTime is null
		where ds.DeleteDateTime is null
		and msku.DeleteFlg=0
		and ds.StockSu>0
		and ds.SoukoCD= '''+ @SoukoCD
		+''' and ('''+ @ArrivalStartDate +''' is null or ds.ArrivalDate>= ''' +@ArrivalStartDate+''') 
		and (ds.ArrivalDate<= '''+ @ArrivalEndDate +''')'

		if(@RegisterFlg='未登録')
			set @query+=' and ds.RackNO is null '
		if(@RegisterFlg='登録済')
			set @query+=' and ds.RackNO is not null '
		if(@RegisterFlg='両方')
			set @query+='';

		if(@LocationFlg='あり')
			set @query+=' and ds.RackNO is not null '
		if(@LocationFlg='なし')
			set @query+=' and ds.RackNO is null '
		if(@LocationFlg='両方')
			set @query+='';

		set @query += ' and isnull(dar.DirectFLG, 0) <> 1 '

		--set @query += ' order by ds.SKUCD asc '
		set @query += ' order by ds.RackNO, ds.SKUCD, ds.StockSu asc '

		Exec(@query)
	end

	Else
	begin
		select ds.RackNO,
		ds.SKUCD,
		'' as RackNo1,
		'test' as Rack,
		msku.SKUName,
		ds.StockSu,
		ds.JanCD,
		msku.ColorName,
		msku.SizeName,
		CONVERT(VARCHAR(10), ds.ArrivalDate , 111) as ArrivalDate,
		ds.ReserveSu,
		ds.StockSu-ds.ReserveSu as DiffSu
		from D_Stock as ds 
		left outer join F_SKU(CONVERT(VARCHAR(10), getdate() , 120)) as msku on ds.SKUCD=msku.SKUCD and msku.AdminNO=ds.AdminNO
		Left Outer Join D_ArrivalPlan as dar on dar.ArrivalPlanNO = ds.ArrivalPlanNO and dar.DeleteDateTime is null
		where ds.SoukoCD=@SoukoCD
		and ds.SKUCD=@SKUCD
		and (@ArrivalStartDate is null or ds.ArrivalDate>=@ArrivalStartDate )
		and (@ArrivalEndDate is null or ds.ArrivalDate<=@ArrivalEndDate)
		and isnull(dar.DirectFLG, 0) <> 1 
		--order by ds.SKUCD,ds.ArrivalDate,ds.RackNO
		order by ds.RackNO, ds.SKUCD,ds.StockSu asc
	end

END
