
 BEGIN TRY 
 Drop Procedure dbo.[_Item_ItemPrice]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_Item_ItemPrice]
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

	Declare
    @Upt as int =1,
	@Ins as int = 1;

	if @MainFlg = 1 or @MainFlg  =2 or @MainFlg =3 or @MainFlg =4
	Begin
        --Merge [M_item] mi using [
        Merge [M_ItemPrice] targ using ( select *  from	(select 
                 ITemCD							
                ,ChangeDate							
                ,PriceWithTax 							
                ,PriceOutTax	as PriceWithoutTax						
                ,100 as GeneralRate							
                ,PriceWithTax	as	GeneralPriceWithTax					
                ,PriceOutTax	as 	GeneralPriceOutTax					
                ,100 as MemberRate						
                ,PriceWithTax	as 	MemberPriceWithTax					
                ,PriceOutTax	as MemberPriceOutTax						
                ,100 as ClientRate							
                ,PriceWithTax	as 	ClientPriceWithTax					
                ,PriceOutTax	as 	ClientPriceOutTax					
                ,100 as WebRate						
                ,PriceWithTax	as 	WebPriceWithTax					
                ,PriceOutTax	as WebPriceOutTax						
                ,100 as SaleRate							
                ,PriceWithTax	as SalePriceWithTax						
                ,PriceOutTax	as SalePriceOutTax						
                ,null as Remarks							
                ,0		as DeleteFlg					
                ,0		as UsedFlg					
                ,@Opt	as InsertOpt					
                ,@date	as Insertdt					
                ,@Opt	as updateOpt					
                ,@date	as Updatedt	

			from @ItemTable t
            where exists(select * from M_ITEM m where m.ITemCD = t.ITemCD and m.ChangeDate = t.ChangeDate)
            ) a ) src  	on targ.ItemCD = src.ItemCD and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			     targ.PriceWithTax									=src.PriceWithTax		
			    ,targ.PriceWithoutTax								=src.PriceWithoutTax		
			    ,targ.UpdateOperator								=src.Updateopt		
			    ,targ.UpdateDateTime								=src.Updatedt			

			when not matched by target and @Ins = 1 then insert
			(
				ITemCD				
				,ChangeDate			
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
			values
			(
			 	src.ITemCD			
				,src.ChangeDate		
				,src.PriceWithTax	
				,src.PriceWithoutTax	
				,src.GeneralRate	
				,src.PriceWithTax	
				,src.PriceWithoutTax	
				,src.MemberRate		
				,src.PriceWithTax	
				,src.PriceWithoutTax
				,src.ClientRate		
				,src.PriceWithTax	
				,src.PriceWithoutTax
				,src.SaleRate	
				,src.PriceWithTax
				,src.PriceWithoutTax	
				,src.WebRate		
				,src.PriceWithTax	
				,src.PriceWithoutTax	
				,src.Remarks		
				,src.DeleteFlg	
				,src.UsedFlg		
				,src.InsertOpt		
				,src.Insertdt		
				,src.Updateopt		
				,src.Updatedt				
			);


	End
END
