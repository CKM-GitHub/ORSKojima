
 BEGIN TRY 
 Drop Procedure dbo.[_Item_ItemOrderPrice]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[_Item_ItemOrderPrice]
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

	if @MainFlg =1 or @MainFlg = 2 or @MainFlg =4
	Begin

	    Declare
	    @Upt as int = 1,
	    @Ins as int = 1;

	    DELETE mio
        from M_ItemOrderPrice mio
        inner join M_ITEM mi on mi.MakerItem = mio.MakerItem and mi.ChangeDate = mio.ChangeDate
        inner join @ItemTable tp on tp.ITemCD = mi.ITemCD and tp.ChangeDate = mi.ChangeDate

	    insert into M_ItemOrderPrice
        select distinct
             TP.MainVendorCD 
            ,'0000' as Store
            ,ms.MakerItem as MakerItem
            ,tp.ChangeDate as changedate
            ,tp.Rate as Rate
            ,tp.OrderPriceWithoutTax as OP
            ,0 as l
            ,0 as k
            ,@Opt   as IOPT
            ,@Date  as IDT
            ,@Opt   as UOPT
            ,@Date  as UDT
			 
        from @ItemTable tp
        inner join M_Item ms on ms.ItemCD = tp.ItemCD and ms.ChangeDate = tp.ChangeDate
        where (tp.MainVendorCD is not null and tp.MainVendorCD <> '')

	End
END
