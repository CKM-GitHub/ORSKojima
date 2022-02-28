
 BEGIN TRY 
 Drop Procedure dbo.[_Item_ItemOrderPrice2]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_Item_ItemOrderPrice2]
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
	if @MainFlg=1 or @MainFlg=2 or @MainFlg=4
	Begin
		Declare
        @Upt as int =1,
        @Ins as int = 1;

		update mio set
             mio.Rate   = tim.Rate
            ,mio.PriceWithoutTax = tim.OrderPriceWithoutTax
            ,mio.UpdateOperator  = @Opt 
            ,mio.UpdateDateTime = @Date
		from M_ItemOrderPrice mio
		inner join M_ITEM mi on mi.MakerItem = mio.MakerItem and mi.ChangeDate = mio.ChangeDate
		inner join @ItemTable tim on tim.ITemCD = mi.ITemCD and tim.ChangeDate = mi.ChangeDate
		where mio.VendorCD = '0000000000000'
		and mio.StoreCD = '0000'
		and (tim.MainVendorCD is not null and tim.MainVendorCD <> '')


		insert into M_ItemOrderPrice
		select
            '0000000000000' as mainvendor
            ,'0000' as store
            ,mi.MakerItem
            ,tp.ChangeDate
            ,tp.Rate
            ,tp.OrderPriceWithoutTax
            ,0 as a
            ,0 as b
            ,@Opt as iopt
            ,@Date as idt
            ,@Opt as uopt
            ,@Date as udt
		from M_ITEM mi
		inner join @ItemTable tp on tp.ITemCD = mi.ITemCD and tp.ChangeDate = mi.ChangeDate 
        where not exists (select * from M_ItemOrderPrice mio
            where mio.MakerItem = mi.MakerItem and mio.ChangeDate = mi.ChangeDate and mio.VendorCD = '0000000000000' and mio.StoreCD = '0000' )
        and (tp.MainVendorCD is not null and tp.MainVendorCD <> '')

	End
END