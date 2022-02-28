 BEGIN TRY 
 Drop Procedure dbo.[_Item_JanOrderPrice2]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_Item_JanOrderPrice2]
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

	if @MainFlg =1 or @MainFlg = 2 or @MainFlg =4
	Begin
		Declare
	    @Upt as int =1,
	    @Ins as int = 1;

		Update mjo set
             Rate = tim.Rate
		    ,PriceWithoutTax = tim.OrderPriceWithoutTax
        from M_JanOrderPrice mjo 
        inner join M_SKU ms on ms.AdminNO = mjo.AdminNO and ms.ChangeDate = mjo.ChangeDate
        inner join @ItemTable tim on tim.ITemCD = ms.ITemCD and tim.ChangeDate = ms.ChangeDate 
        where mjo.VendorCD = '0000000000000'
        and mjo.StoreCD = '0000'
        and (tim.MainVendorCD is not null and tim.MainVendorCD <> '')


		insert into M_JANOrderPrice
		select  
            '0000000000000'
            ,'0000'
            ,ms.AdminNO
            ,tim.ChangeDate
            ,ms.SKUCD
            ,tim.Rate
            ,ms.OrderPriceWithoutTax
            ,null
            ,0
            ,0
            ,@Opt
            ,@Date
            ,@Opt
            ,@Date

        from M_SKU ms 
        inner join @ItemTable tim on tim.ITemCD = ms.ITemCD and tim.ChangeDate = ms.ChangeDate
        where not exists (select * from M_JanOrderPrice mjo 
                where mjo.AdminNO = ms.AdminNO and mjo.ChangeDate = ms.ChangeDate and mjo.VendorCD = '0000000000000' and mjo.StoreCD = '0000') 
        and (tim.MainVendorCD is not null and tim.MainVendorCD <> '')

	End

END