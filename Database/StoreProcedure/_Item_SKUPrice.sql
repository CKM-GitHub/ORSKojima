
 BEGIN TRY 
 Drop Procedure dbo.[_Item_SKUPrice]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_Item_SKUPrice]
	-- Add the parameters for the stored procedure here
      @ItemTable as T_ItemImport readonly
	 ,@Opt as varchar(20)
	 ,@Date as datetime
	 ,@MainFlg as tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if  @MainFlg =1 or @MainFlg=2 or @MainFlg =3 or @MainFlg =4
	Begin

		Declare
	    @Upt as int =1,
	    @Ins as int = 1;

		update msp set 
             msp.PriceWithTax = tim.PriceWithTax
            ,msp.PriceWithoutTax = tim.PriceOutTax
            ,msp.UpdateOperator = @Opt
            ,msp.UpdateDateTime = @Date
        from M_SKUPrice msp
        inner join M_SKU msk on msk.AdminNO = msp.AdminNO and msk.ChangeDate = msp.ChangeDate
        inner join @ItemTable tim on tim.ITemCD = msk.ITemCD and tim.ChangeDate = msk.ChangeDate


		insert into M_SKUPrice (
			TankaCD
            ,StoreCD
            ,AdminNO
            ,SKUCD
            ,ChangeDate
            ,TekiyouShuuryouDate
            ,PriceWithTax
            ,PriceWithoutTax
			,GeneralRate
            ,GeneralPriceWithTax
            ,GeneralPriceOutTax
            ,MemberRate
            ,MemberPriceWithTax
            ,MemberPriceOutTax
			,ClientRate
            ,ClientPriceWithTax
            ,ClientPriceOutTax
            ,SaleRate
            ,SalePriceWithTax
            ,SalePriceOutTax
			,WebRate
            ,WebPriceWithTax
            ,WebPriceOutTax
            ,Remarks
            ,DeleteFlg
            ,UsedFlg
			,InsertOperator
            ,InsertDateTime
            ,UpdateOperator
            ,UpdateDateTime
			)
		select
			'0000000000000' 
			,'0000' 
			,msk.AdminNO
			,msk.SKUCD
			,tim.ChangeDate
			,null
			,tim.PriceWithTax
			,tim.PriceOutTax
			,100
			,tim.PriceWithTax
			,tim.PriceOutTax
			,100
			,tim.PriceWithTax
			,tim.PriceOutTax
			,100
			,tim.PriceWithTax
			,tim.PriceOutTax
			,100
			,tim.PriceWithTax
			,tim.PriceOutTax
			,100
			,tim.PriceWithTax
			,tim.PriceOutTax
			,null
			,0
			,0
			,@Opt
			,@Date
			,@Opt
			,@Date

		from M_SKU msk 
		inner join @ItemTable tim on tim.ITemCD = msk.ITemCD and tim.ChangeDate = msk.ChangeDate
		where not exists(select * from M_SKUPrice msp where msp.AdminNO = msk.AdminNO and msp.ChangeDate = msk.ChangeDate) 

	End
END