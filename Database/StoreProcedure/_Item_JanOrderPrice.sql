
 BEGIN TRY 
 Drop Procedure dbo.[_Item_JanOrderPrice]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[_Item_JanOrderPrice] 
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


	if @MainFlg =1  or @MainFlg = 2 or @MainFlg =4
	Begin

	    Declare
	    @Upt as int = 1,
	    @Ins as int = 1;

		Delete jop
        from M_JANOrderPrice jop
        inner join M_SKU sku on sku.AdminNO = jop.AdminNO and sku.ChangeDate = jop.ChangeDate
        inner join @ItemTable tp on tp.ITemCD = sku.ITemCD and tp.ChangeDate = sku.ChangeDate


		insert into M_JANOrderPrice
		select  
             tp.MainVendorCD
			,'0000'
			,ms.AdminNO
			,tp.ChangeDate
		    ,ms.SKUCD
            ,tp.Rate
            ,ms.OrderPriceWithoutTax
            ,null
            ,0
            ,0
            ,@Opt
            ,@Date
            ,@Opt
            ,@Date

        from M_SKU ms
        inner join @ItemTable tp on tp.ITemCD = ms.ITemCD and tp.ChangeDate = ms.ChangeDate
	    where (tp.MainVendorCD is not null and tp.MainVendorCD <> '')

  End
END
