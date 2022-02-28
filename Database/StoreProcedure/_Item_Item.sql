
 BEGIN TRY 
 Drop Procedure dbo.[_Item_Item]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[_Item_Item]
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
	@Upt as int = 1,
	@Ins as int = 1;

	--In the case of M_ITEM revision, the value is copied from the most recent M_ITEM and then updated with the imported value.
	if (@MainFlg = 1 OR @MainFlg =2)
	Begin
        INSERT INTO M_ITEM (
            ItemCD
            ,ChangeDate
            ,VariousFLG
            ,ITemName
            ,KanaName
            ,ITEMShortName
            ,EnglishName
            ,SetKBN
            ,PresentKBN
            ,SampleKBN
            ,DiscountKBN
            ,SizeCount
            ,ColorCount
            ,SizeName
            ,ColorName
            ,WebFlg
            ,RealStoreFlg
            ,MainVendorCD
            ,MakerVendorCD
            ,BrandCD
            ,MakerItem
            ,TaniCD
            ,SportsCD
            ,SegmentCD
            ,ZaikoKBN
            ,Rack
            ,VirtualFlg
            ,DirectFlg
            ,ReserveCD
            ,NoticesCD
            ,PostageCD
            ,ManufactCD
            ,ConfirmCD
            ,StopFlg
            ,DiscontinueFlg
            ,SoldOutFlg
            ,WebStockFlg
            ,InventoryAddFlg
            ,MakerAddFlg
            ,StoreAddFlg
            ,NoNetOrderFlg
            ,EDIOrderFlg
            ,AutoOrderFlg
            ,CatalogFlg
            ,ParcelFlg
            ,TaxRateFLG
            ,CostingKBN
            ,NormalCost
            ,SaleExcludedFlg
            ,PriceWithTax
            ,PriceOutTax
            ,OrderPriceWithTax
            ,OrderPriceWithoutTax
            ,Rate
            ,SaleStartDate
            ,WebStartDate
            ,OrderAttentionCD
            ,OrderAttentionNote
            ,CommentInStore
            ,CommentOutStore
            ,LastYearTerm
            ,LastSeason
            ,LastCatalogNO
            ,LastCatalogPage
            ,LastCatalogText
            ,LastInstructionsNO
            ,LastInstructionsDate
            ,WebAddress
            ,ApprovalDate
            ,ApprovalDateTime
            ,TagName01
            ,TagName02
            ,TagName03
            ,TagName04
            ,TagName05
            ,TagName06
            ,TagName07
            ,TagName08
            ,TagName09
            ,TagName10
            ,ExhibitionSegmentCD
            ,OrderLot
            ,DeleteFlg
            ,UsedFlg
            ,SKSUpdateFlg
            ,SKSUpdateDateTime
            ,InsertOperator
            ,InsertDateTime
            ,UpdateOperator
            ,UpdateDateTime
        )
        SELECT
             t.ItemCD
            ,t.ChangeDate
            ,m.VariousFLG
            ,m.ITemName
            ,m.KanaName
            ,m.ITEMShortName
            ,m.EnglishName
            ,m.SetKBN
            ,m.PresentKBN
            ,m.SampleKBN
            ,m.DiscountKBN
            ,m.SizeCount
            ,m.ColorCount
            ,m.SizeName
            ,m.ColorName
            ,m.WebFlg
            ,m.RealStoreFlg
            ,m.MainVendorCD
            ,m.MakerVendorCD
            ,m.BrandCD
            ,m.MakerItem
            ,m.TaniCD
            ,m.SportsCD
            ,m.SegmentCD
            ,m.ZaikoKBN
            ,m.Rack
            ,m.VirtualFlg
            ,m.DirectFlg
            ,m.ReserveCD
            ,m.NoticesCD
            ,m.PostageCD
            ,m.ManufactCD
            ,m.ConfirmCD
            ,m.StopFlg
            ,m.DiscontinueFlg
            ,m.SoldOutFlg
            ,m.WebStockFlg
            ,m.InventoryAddFlg
            ,m.MakerAddFlg
            ,m.StoreAddFlg
            ,m.NoNetOrderFlg
            ,m.EDIOrderFlg
            ,m.AutoOrderFlg
            ,m.CatalogFlg
            ,m.ParcelFlg
            ,m.TaxRateFLG
            ,m.CostingKBN
            ,m.NormalCost
            ,m.SaleExcludedFlg
            ,m.PriceWithTax
            ,m.PriceOutTax
            ,m.OrderPriceWithTax
            ,m.OrderPriceWithoutTax
            ,m.Rate
            ,m.SaleStartDate
            ,m.WebStartDate
            ,m.OrderAttentionCD
            ,m.OrderAttentionNote
            ,m.CommentInStore
            ,m.CommentOutStore
            ,m.LastYearTerm
            ,m.LastSeason
            ,m.LastCatalogNO
            ,m.LastCatalogPage
            ,m.LastCatalogText
            ,m.LastInstructionsNO
            ,m.LastInstructionsDate
            ,m.WebAddress
            ,m.ApprovalDate
            ,m.ApprovalDateTime
            ,m.TagName01
            ,m.TagName02
            ,m.TagName03
            ,m.TagName04
            ,m.TagName05
            ,m.TagName06
            ,m.TagName07
            ,m.TagName08
            ,m.TagName09
            ,m.TagName10
            ,m.ExhibitionSegmentCD
            ,m.OrderLot
            ,m.DeleteFlg
            ,0 as UsedFlg
            ,1 as SKSUpdateFlg
            ,null as SKSUpdateDateTime
            ,@Opt
            ,@Date
            ,@Opt
            ,@Date
        FROM @ItemTable t
        inner join M_ITEM m on m.ITemCD = t.ITemCD and m.ChangeDate = t.MostRecentChangeDate
        where t.RevisionFlg = 1
    end


	--Merge [M_item] mi using [
	if (@MainFlg =1)
	Begin
		Merge [M_item] targ using ( select *  from	(select 
			ITemCD							
			,ChangeDate							
			,VariousFLG							
			,ITemName							
			,KanaName							
			,ITEMShortName							
			,EnglishName							
			,SetKBN							
			,PresentKBN							
			,SampleKBN							
			,DiscountKBN							
			,SizeCount							
			,ColorCount							
			,null as SizeName							
			,null as ColorName							
			,WebFlg							
			,RealStoreFlg							
			,MainVendorCD							
			,MainVendorCD as MakerVendorCD							
			,BrandCD							
			,MakerItem							
			,TaniCD							
			,SportsCD							
			,SegmentCD							
			,ZaikoKBN							
			,Rack							
			,VirtualFlg							
			,DirectFlg							
			,ReserveCD							
			,NoticesCD							
			,PostageCD							
			,ManufactCD							
			,ConfirmCD							
			,StopFlg							
			,DiscontinueFlg							
			,SoldOutFlg							
			,WebStockFlg							
			,InventoryAddFlg							
			,MakerAddFlg							
			,StoreAddFlg							
			,NoNetOrderFlg							
			,EDIOrderFlg							
			,AutoOrderFlg							
			,CatalogFlg							
			,ParcelFlg							
			,TaxRateFLG							
			,CostingKBN							
			,NormalCost							
			,SaleExcludedFlg							
			,PriceWithTax							
			,PriceOutTax							
			,OrderPriceWithTax							
			,OrderPriceWithoutTax							
			,Rate							
			,SaleStartDate							
			,WebStartDate							
			,OrderAttentionCD							
			,OrderAttentionNote							
			,CommentInStore							
			,CommentOutStore							
			,LastYearTerm							
			,LastSeason							
			,LastCatalogNO							
			,LastCatalogPage							
			,LastCatalogText							
			,LastInstructionsNO							
			,LastInstructionsDate							
			,WebAddress							
			,ApprovalDate							
			,(case when ApprovalDate is not null then @Date else null end )	as ApprovalDateTime		
			,TagName01							
			,TagName02							
			,TagName03							
			,TagName04							
			,TagName05							
			,TagName06							
			,TagName07							
			,TagName08							
			,TagName09							
			,TagName10							
			,ExhibitionSegmentCD							
			,OrderLot							
			,DeleteFlg							
			,0 as UsedFlg							
			,1 as SKSUpdateFlg							
			,null as SKSUpdateDateTime							
			,@Opt as InsertOperator							
			,@Date as InsertDateTime							
			,@Opt as UpdateOperator							
			,@Date as UpdateDateTime							
				
			from @ItemTable ) a ) src  	on targ.ItemCD = src.ItemCD and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			 targ.VariousFLG									 =src.VariousFLG							
			,targ.ITemName									 =src.ITemName							
			,targ.KanaName									 =src.KanaName							
			,targ.ITEMShortName								 =src.ITEMShortName							
			,targ.EnglishName								 =src.EnglishName							
			,targ.SetKBN									 =src.SetKBN							
			,targ.PresentKBN								 =src.PresentKBN							
			,targ.SampleKBN									 =src.SampleKBN							
			,targ.DiscountKBN								 =src.DiscountKBN							
			--,targ.SizeCount								 =src.SizeCount							
			--,targ.ColorCount								 =src.ColorCount							
			,targ.SizeName									 =src.SizeName							
			,targ.ColorName									 =src.ColorName							
			,targ.WebFlg									 =src.WebFlg							
			,targ.RealStoreFlg								 =src.RealStoreFlg							
			,targ.MainVendorCD								 =src.MainVendorCD							
			,targ.MakerVendorCD								 =src.MakerVendorCD						
			,targ.BrandCD									 =src.BrandCD							
			,targ.MakerItem									 =src.MakerItem							
			,targ.TaniCD									 =src.TaniCD							
			,targ.SportsCD									 =src.SportsCD							
			,targ.SegmentCD									 =src.SegmentCD							
			,targ.ZaikoKBN									 =src.ZaikoKBN							
			,targ.Rack										 =src.Rack							
			,targ.VirtualFlg								 =src.VirtualFlg							
			,targ.DirectFlg									 =src.DirectFlg							
			,targ.ReserveCD									 =src.ReserveCD							
			,targ.NoticesCD									 =src.NoticesCD							
			,targ.PostageCD									 =src.PostageCD							
			,targ.ManufactCD								 =src.ManufactCD							
			,targ.ConfirmCD									 =src.ConfirmCD							
			,targ.StopFlg									 =src.StopFlg							
			,targ.DiscontinueFlg							 =src.DiscontinueFlg							
			,targ.SoldOutFlg								 =src.SoldOutFlg							
			,targ.WebStockFlg								 =src.WebStockFlg							
			,targ.InventoryAddFlg							 =src.InventoryAddFlg							
			,targ.MakerAddFlg								 =src.MakerAddFlg							
			,targ.StoreAddFlg								 =src.StoreAddFlg							
			,targ.NoNetOrderFlg								 =src.NoNetOrderFlg							
			,targ.EDIOrderFlg								 =src.EDIOrderFlg							
			,targ.AutoOrderFlg								 =src.AutoOrderFlg							
			,targ.CatalogFlg								 =src.CatalogFlg							
			,targ.ParcelFlg									 =src.ParcelFlg							
			,targ.TaxRateFLG								 =src.TaxRateFLG							
			,targ.CostingKBN								 =src.CostingKBN							
			,targ.NormalCost								 =src.NormalCost							
			,targ.SaleExcludedFlg							 =src.SaleExcludedFlg							
			,targ.PriceWithTax								 =src.PriceWithTax							
			,targ.PriceOutTax								 =src.PriceOutTax							
			,targ.OrderPriceWithTax							 =src.OrderPriceWithTax							
			,targ.OrderPriceWithoutTax						 =src.OrderPriceWithoutTax							
			,targ.Rate										 =src.Rate							
			,targ.SaleStartDate								 =src.SaleStartDate							
			,targ.WebStartDate								 =src.WebStartDate							
			,targ.OrderAttentionCD							 =src.OrderAttentionCD							
			,targ.OrderAttentionNote						 =src.OrderAttentionNote							
			,targ.CommentInStore							 =src.CommentInStore							
			,targ.CommentOutStore							 =src.CommentOutStore							
			,targ.LastYearTerm								 =src.LastYearTerm							
			,targ.LastSeason								 =src.LastSeason							
			,targ.LastCatalogNO								 =src.LastCatalogNO							
			,targ.LastCatalogPage							 =src.LastCatalogPage							
			,targ.LastCatalogText							 =src.LastCatalogText							
			,targ.LastInstructionsNO						 =src.LastInstructionsNO							
			,targ.LastInstructionsDate						 =src.LastInstructionsDate							
			,targ.WebAddress								 =src.WebAddress							
			,targ.ApprovalDate								 =src.ApprovalDate							
			,targ.ApprovalDateTime							 =(case when src.ApprovalDate is not null then @Date else null end )
			,targ.TagName01									 =src.TagName01							
			,targ.TagName02									 =src.TagName02							
			,targ.TagName03									 =src.TagName03							
			,targ.TagName04									 =src.TagName04							
			,targ.TagName05									 =src.TagName05							
			,targ.TagName06									 =src.TagName06							
			,targ.TagName07									 =src.TagName07							
			,targ.TagName08									 =src.TagName08							
			,targ.TagName09									 =src.TagName09							
			,targ.TagName10									 =src.TagName10							
			,targ.ExhibitionSegmentCD						 =src.ExhibitionSegmentCD							
			,targ.OrderLot									 =src.OrderLot							
			,targ.DeleteFlg									 =src.DeleteFlg							
			--,targ.UsedFlg									 =src.UsedFlg							
			--,targ.SKSUpdateFlg							 =src.SKSUpdateFlg
            --,targ.SKSUpdateDateTime						 =src.SKSUpdateDateTime
            --,targ.InsertOperator							 =src.InsertOperator							
			--,targ.InsertDateTime							 =src.InsertDateTime							
			,targ.UpdateOperator							 =src.UpdateOperator							
			,targ.UpdateDateTime							 =src.UpdateDateTime		
			

			when not matched by target and @Ins = 1 then insert
			(
			ItemCD
			,ChangeDate
			,VariousFLG				
			,ITemName					
			,KanaName					
			,ITEMShortName				
			,EnglishName				
			,SetKBN					
			,PresentKBN				
			,SampleKBN					
			,DiscountKBN				
			,SizeCount					
			,ColorCount				
			,SizeName					
			,ColorName					
			,WebFlg					
			,RealStoreFlg				
			,MainVendorCD				
			,MakerVendorCD				
			,BrandCD					
			,MakerItem					
			,TaniCD					
			,SportsCD					
			,SegmentCD					
			,ZaikoKBN					
			,Rack						
			,VirtualFlg				
			,DirectFlg					
			,ReserveCD					
			,NoticesCD					
			,PostageCD					
			,ManufactCD				
			,ConfirmCD					
			,StopFlg					
			,DiscontinueFlg			
			,SoldOutFlg				
			,WebStockFlg				
			,InventoryAddFlg			
			,MakerAddFlg				
			,StoreAddFlg				
			,NoNetOrderFlg				
			,EDIOrderFlg				
			,AutoOrderFlg				
			,CatalogFlg				
			,ParcelFlg					
			,TaxRateFLG				
			,CostingKBN				
			,NormalCost				
			,SaleExcludedFlg			
			,PriceWithTax				
			,PriceOutTax				
			,OrderPriceWithTax			
			,OrderPriceWithoutTax		
			,Rate						
			,SaleStartDate				
			,WebStartDate				
			,OrderAttentionCD			
			,OrderAttentionNote		
			,CommentInStore			
			,CommentOutStore			
			,LastYearTerm				
			,LastSeason				
			,LastCatalogNO				
			,LastCatalogPage			
			,LastCatalogText			
			,LastInstructionsNO		
			,LastInstructionsDate		
			,WebAddress				
			,ApprovalDate				
			,ApprovalDateTime			
			,TagName01					
			,TagName02					
			,TagName03					
			,TagName04					
			,TagName05					
			,TagName06					
			,TagName07					
			,TagName08					
			,TagName09					
			,TagName10					
			,ExhibitionSegmentCD		
			,OrderLot					
			,DeleteFlg					
			,UsedFlg					
			,SKSUpdateFlg				
			,SKSUpdateDateTime			
			,InsertOperator			
			,InsertDateTime			
			,UpdateOperator			
			,UpdateDateTime			
			)
			values
			(
			ItemCD
			,src.ChangeDate
			,src.VariousFLG				
			,src.ITemName					
			,src.KanaName					
			,src.ITEMShortName				
			,src.EnglishName				
			,src.SetKBN					
			,src.PresentKBN				
			,src.SampleKBN					
			,src.DiscountKBN				
			,src.SizeCount					
			,src.ColorCount				
			,src.SizeName					
			,src.ColorName					
			,src.WebFlg					
			,src.RealStoreFlg				
			,src.MainVendorCD				
			,src.MakerVendorCD				
			,src.BrandCD					
			,src.MakerItem					
			,src.TaniCD					
			,src.SportsCD					
			,src.SegmentCD					
			,src.ZaikoKBN					
			,src.Rack						
			,src.VirtualFlg				
			,src.DirectFlg					
			,src.ReserveCD					
			,src.NoticesCD					
			,src.PostageCD					
			,src.ManufactCD				
			,src.ConfirmCD					
			,src.StopFlg					
			,src.DiscontinueFlg			
			,src.SoldOutFlg				
			,src.WebStockFlg				
			,src.InventoryAddFlg			
			,src.MakerAddFlg				
			,src.StoreAddFlg				
			,src.NoNetOrderFlg				
			,src.EDIOrderFlg				
			,src.AutoOrderFlg				
			,src.CatalogFlg				
			,src.ParcelFlg					
			,src.TaxRateFLG				
			,src.CostingKBN				
			,src.NormalCost				
			,src.SaleExcludedFlg			
			,src.PriceWithTax				
			,src.PriceOutTax				
			,src.OrderPriceWithTax			
			,src.OrderPriceWithoutTax		
			,src.Rate						
			,src.SaleStartDate				
			,src.WebStartDate				
			,src.OrderAttentionCD			
			,src.OrderAttentionNote		
			,src.CommentInStore			
			,src.CommentOutStore			
			,src.LastYearTerm				
			,src.LastSeason				
			,src.LastCatalogNO				
			,src.LastCatalogPage			
			,src.LastCatalogText			
			,src.LastInstructionsNO		
			,src.LastInstructionsDate		
			,src.WebAddress				
			,src.ApprovalDate				
			,src.ApprovalDateTime			
			,src.TagName01					
			,src.TagName02					
			,src.TagName03					
			,src.TagName04					
			,src.TagName05					
			,src.TagName06					
			,src.TagName07					
			,src.TagName08					
			,src.TagName09					
			,src.TagName10					
			,src.ExhibitionSegmentCD		
			,src.OrderLot					
			,src.DeleteFlg					
			,src.UsedFlg					
			,src.SKSUpdateFlg				
			,src.SKSUpdateDateTime			
			,src.InsertOperator			
			,src.InsertDateTime			
			,src.UpdateOperator			
			,src.UpdateDateTime			
			);
    End
	if (@MainFlg =2)
	Begin
		Merge [M_item] targ using ( select *  from	(select 
			ITemCD							
			,ChangeDate							
			,VariousFLG							
			,ITemName							
			,KanaName							
			,ITEMShortName							
			,EnglishName							
			,SetKBN							
		    ,PresentKBN							
			,SampleKBN							
			,DiscountKBN							
			,SizeCount							
			,ColorCount							
			--,null as SizeName							
			--,null as ColorName							
			,WebFlg							
			,RealStoreFlg							
			,MainVendorCD							
			,MainVendorCD as MakerVendorCD							
			,BrandCD							
			,MakerItem							
			,TaniCD							
			,SportsCD							
			,SegmentCD							
			,ZaikoKBN							
			,Rack							
			,VirtualFlg							
			,DirectFlg							
			,ReserveCD							
			,NoticesCD							
			,PostageCD							
			,ManufactCD							
			,ConfirmCD							
			,StopFlg							
			,DiscontinueFlg							
			,SoldOutFlg							
			,WebStockFlg							
			,InventoryAddFlg							
			,MakerAddFlg							
			,StoreAddFlg							
			,NoNetOrderFlg							
			,EDIOrderFlg							
			,AutoOrderFlg							
			,CatalogFlg							
			,ParcelFlg							
			,TaxRateFLG							
			,CostingKBN							
			,NormalCost							
			,SaleExcludedFlg							
			,PriceWithTax							
			,PriceOutTax							
			,OrderPriceWithTax							
			,OrderPriceWithoutTax							
			,Rate							
			,SaleStartDate							
			,WebStartDate							
			,OrderAttentionCD							
			,OrderAttentionNote							
			,CommentInStore							
			,CommentOutStore							
			--,LastYearTerm							
			--,LastSeason							
			--,LastCatalogNO							
			--,LastCatalogPage							
			--,LastCatalogText							
			--,LastInstructionsNO							
			--,LastInstructionsDate							
			--,WebAddress							
			,ApprovalDate							
			,(case when ApprovalDate is not null then @Date else null end )	as ApprovalDateTime		
			--,TagName01							
			--,TagName02							
			--,TagName03							
			--,TagName04							
			--,TagName05							
			--,TagName06							
			--,TagName07							
			--,TagName08							
			--,TagName09							
			--,TagName10							
			,ExhibitionSegmentCD							
			,OrderLot							
			,DeleteFlg							
			,0 as UsedFlg							
			,1 as SKSUpdateFlg							
			,null as SKSUpdateDateTime							
			,@Opt as InsertOperator							
			,@Date as InsertDateTime							
			,@Opt as UpdateOperator							
			,@Date as UpdateDateTime							
				
			from @ItemTable ) a ) src  	
			on  targ.ItemCD = src.ItemCD 
			and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			 targ.VariousFLG								 =src.VariousFLG							
			,targ.ITemName									 =src.ITemName							
			,targ.KanaName									 =src.KanaName							
			,targ.ITEMShortName								 =src.ITEMShortName							
			,targ.EnglishName								 =src.EnglishName							
			,targ.SetKBN									 =src.SetKBN							
			,targ.PresentKBN								 =src.PresentKBN							
			,targ.SampleKBN									 =src.SampleKBN							
			,targ.DiscountKBN								 =src.DiscountKBN							
			--,targ.SizeCount									 =src.SizeCount							
			--,targ.ColorCount								 =src.ColorCount							
			--,targ.SizeName									 =src.SizeName							
			--,targ.ColorName									 =src.ColorName							
			,targ.WebFlg									 =src.WebFlg							
			,targ.RealStoreFlg								 =src.RealStoreFlg							
			,targ.MainVendorCD								 =src.MainVendorCD							
			,targ.MakerVendorCD								 =src.MakerVendorCD						
			,targ.BrandCD									 =src.BrandCD							
			,targ.MakerItem									 =src.MakerItem							
			,targ.TaniCD									 =src.TaniCD							
			,targ.SportsCD									 =src.SportsCD							
			,targ.SegmentCD									 =src.SegmentCD							
			,targ.ZaikoKBN									 =src.ZaikoKBN							
			,targ.Rack										 =src.Rack							
			,targ.VirtualFlg								 =src.VirtualFlg							
			,targ.DirectFlg									 =src.DirectFlg							
			,targ.ReserveCD									 =src.ReserveCD							
			,targ.NoticesCD									 =src.NoticesCD							
			,targ.PostageCD									 =src.PostageCD							
			,targ.ManufactCD								 =src.ManufactCD							
			,targ.ConfirmCD									 =src.ConfirmCD							
			,targ.StopFlg									 =src.StopFlg							
			,targ.DiscontinueFlg							 =src.DiscontinueFlg							
			,targ.SoldOutFlg								 =src.SoldOutFlg							
			,targ.WebStockFlg								 =src.WebStockFlg							
			,targ.InventoryAddFlg							 =src.InventoryAddFlg							
			,targ.MakerAddFlg								 =src.MakerAddFlg							
			,targ.StoreAddFlg								 =src.StoreAddFlg							
			,targ.NoNetOrderFlg								 =src.NoNetOrderFlg							
			,targ.EDIOrderFlg								 =src.EDIOrderFlg							
			,targ.AutoOrderFlg								 =src.AutoOrderFlg							
			,targ.CatalogFlg								 =src.CatalogFlg							
			,targ.ParcelFlg									 =src.ParcelFlg							
			,targ.TaxRateFLG								 =src.TaxRateFLG							
			,targ.CostingKBN								 =src.CostingKBN							
			,targ.NormalCost								 =src.NormalCost							
			,targ.SaleExcludedFlg							 =src.SaleExcludedFlg							
			,targ.PriceWithTax								 =src.PriceWithTax							
			,targ.PriceOutTax								 =src.PriceOutTax							
			,targ.OrderPriceWithTax							 =src.OrderPriceWithTax							
			,targ.OrderPriceWithoutTax						 =src.OrderPriceWithoutTax							
			,targ.Rate										 =src.Rate							
			,targ.SaleStartDate								 =src.SaleStartDate							
			,targ.WebStartDate								 =src.WebStartDate							
			,targ.OrderAttentionCD							 =src.OrderAttentionCD							
			,targ.OrderAttentionNote						 =src.OrderAttentionNote							
			,targ.CommentInStore							 =src.CommentInStore							
			,targ.CommentOutStore							 =src.CommentOutStore							
			--,targ.LastYearTerm								 =src.LastYearTerm							
			--,targ.LastSeason								 =src.LastSeason							
			--,targ.LastCatalogNO								 =src.LastCatalogNO							
			--,targ.LastCatalogPage							 =src.LastCatalogPage							
			--,targ.LastCatalogText							 =src.LastCatalogText							
			--,targ.LastInstructionsNO						 =src.LastInstructionsNO							
			--,targ.LastInstructionsDate						 =src.LastInstructionsDate							
			--,targ.WebAddress								 =src.WebAddress							
			,targ.ApprovalDate								 =src.ApprovalDate							
			,targ.ApprovalDateTime							 =(case when src.ApprovalDate is not null then @Date else null end )		
			--,targ.TagName01									 =src.TagName01							
			--,targ.TagName02									 =src.TagName02							
			--,targ.TagName03									 =src.TagName03							
			--,targ.TagName04									 =src.TagName04							
			--,targ.TagName05									 =src.TagName05							
			--,targ.TagName06									 =src.TagName06							
			--,targ.TagName07									 =src.TagName07							
			--,targ.TagName08									 =src.TagName08							
			--,targ.TagName09									 =src.TagName09							
			--,targ.TagName10									 =src.TagName10							
			,targ.ExhibitionSegmentCD						 =src.ExhibitionSegmentCD							
			,targ.OrderLot									 =src.OrderLot							
			,targ.DeleteFlg									 =src.DeleteFlg							
			--,targ.UsedFlg									 =src.UsedFlg							
			--,targ.SKSUpdateFlg							 =src.SKSUpdateFlg							
			--,targ.SKSUpdateDateTime						 =src.SKSUpdateDateTime							
			--,targ.InsertOperator							 =src.InsertOperator							
			--,targ.InsertDateTime							 =src.InsertDateTime							
			,targ.UpdateOperator							 =src.UpdateOperator							
			,targ.UpdateDateTime							 =src.UpdateDateTime		
			

			when not matched by target and @Ins = 1 then insert
			(
			ItemCD
			,ChangeDate
			,VariousFLG				
			,ITemName					
			,KanaName					
			,ITEMShortName				
			,EnglishName				
			,SetKBN					
			,PresentKBN				
			,SampleKBN					
			,DiscountKBN				
			,SizeCount					
			,ColorCount				
			--,SizeName					
			--,ColorName					
			,WebFlg					
			,RealStoreFlg				
			,MainVendorCD				
			,MakerVendorCD				
			,BrandCD					
			,MakerItem					
			,TaniCD					
			,SportsCD					
			,SegmentCD					
			,ZaikoKBN					
			,Rack						
			,VirtualFlg				
			,DirectFlg					
			,ReserveCD					
			,NoticesCD					
			,PostageCD					
			,ManufactCD				
			,ConfirmCD					
			,StopFlg					
			,DiscontinueFlg			
			,SoldOutFlg				
			,WebStockFlg				
			,InventoryAddFlg			
			,MakerAddFlg				
			,StoreAddFlg				
			,NoNetOrderFlg				
			,EDIOrderFlg				
			,AutoOrderFlg				
			,CatalogFlg				
			,ParcelFlg					
			,TaxRateFLG				
			,CostingKBN				
			,NormalCost				
			,SaleExcludedFlg			
			,PriceWithTax				
			,PriceOutTax				
			,OrderPriceWithTax			
			,OrderPriceWithoutTax		
			,Rate						
			,SaleStartDate				
			,WebStartDate				
			,OrderAttentionCD			
			,OrderAttentionNote		
			,CommentInStore			
			,CommentOutStore			
			--,LastYearTerm				
			--,LastSeason				
			--,LastCatalogNO				
			--,LastCatalogPage			
			--,LastCatalogText			
			--,LastInstructionsNO		
			--,LastInstructionsDate		
			--,WebAddress				
			,ApprovalDate				
			,ApprovalDateTime			
			--,TagName01					
			--,TagName02					
			--,TagName03					
			--,TagName04					
			--,TagName05					
			--,TagName06					
			--,TagName07					
			--,TagName08					
			--,TagName09					
			--,TagName10					
			,ExhibitionSegmentCD		
			,OrderLot					
			,DeleteFlg					
			,UsedFlg					
			,SKSUpdateFlg				
			,SKSUpdateDateTime			
			,InsertOperator			
			,InsertDateTime			
			,UpdateOperator			
			,UpdateDateTime			
			)
			values
			(
			ItemCD
			,src.ChangeDate
			,src.VariousFLG				
			,src.ITemName					
			,src.KanaName					
			,src.ITEMShortName				
			,src.EnglishName				
			,src.SetKBN					
			,src.PresentKBN				
			,src.SampleKBN					
			,src.DiscountKBN				
			,src.SizeCount					
			,src.ColorCount				
			--,src.SizeName					
			--,src.ColorName					
			,src.WebFlg					
			,src.RealStoreFlg				
			,src.MainVendorCD				
			,src.MakerVendorCD				
			,src.BrandCD					
			,src.MakerItem					
			,src.TaniCD					
			,src.SportsCD					
			,src.SegmentCD					
			,src.ZaikoKBN					
			,src.Rack						
			,src.VirtualFlg				
			,src.DirectFlg					
			,src.ReserveCD					
			,src.NoticesCD					
			,src.PostageCD					
			,src.ManufactCD				
			,src.ConfirmCD					
			,src.StopFlg					
			,src.DiscontinueFlg			
			,src.SoldOutFlg				
			,src.WebStockFlg				
			,src.InventoryAddFlg			
			,src.MakerAddFlg				
			,src.StoreAddFlg				
			,src.NoNetOrderFlg				
			,src.EDIOrderFlg				
			,src.AutoOrderFlg				
			,src.CatalogFlg				
			,src.ParcelFlg					
			,src.TaxRateFLG				
			,src.CostingKBN				
			,src.NormalCost				
			,src.SaleExcludedFlg			
			,src.PriceWithTax				
			,src.PriceOutTax				
			,src.OrderPriceWithTax			
			,src.OrderPriceWithoutTax		
			,src.Rate						
			,src.SaleStartDate				
			,src.WebStartDate				
			,src.OrderAttentionCD			
			,src.OrderAttentionNote		
			,src.CommentInStore			
			,src.CommentOutStore			
			--,src.LastYearTerm				
			--,src.LastSeason				
			--,src.LastCatalogNO				
			--,src.LastCatalogPage			
			--,src.LastCatalogText			
			--,src.LastInstructionsNO		
			--,src.LastInstructionsDate		
			--,src.WebAddress				
			,src.ApprovalDate				
			,src.ApprovalDateTime			
			--,src.TagName01					
			--,src.TagName02					
			--,src.TagName03					
			--,src.TagName04					
			--,src.TagName05					
			--,src.TagName06					
			--,src.TagName07					
			--,src.TagName08					
			--,src.TagName09					
			--,src.TagName10					
			,src.ExhibitionSegmentCD		
			,src.OrderLot					
			,src.DeleteFlg					
			,src.UsedFlg					
			,src.SKSUpdateFlg				
			,src.SKSUpdateDateTime			
			,src.InsertOperator			
			,src.InsertDateTime			
			,src.UpdateOperator			
			,src.UpdateDateTime			
			);
	End
    if (@MainFlg =3)
    Begin
        set @Ins =0;
		Merge [M_item] targ using ( select *  from	(select 
			ITemCD							
			,ChangeDate							
			,VariousFLG							
			,ITemName							
			,KanaName							
			,ITEMShortName							
			,EnglishName							
			,SetKBN							
			,PresentKBN							
			,SampleKBN							
			,DiscountKBN							
			,SizeCount							
			,ColorCount							
			,null as SizeName							
			,null as ColorName							
			,WebFlg							
			,RealStoreFlg							
			,MainVendorCD							
			,MainVendorCD as MakerVendorCD							
			,BrandCD							
			,MakerItem							
			,TaniCD							
			,SportsCD							
			,SegmentCD							
			,ZaikoKBN							
			,Rack							
			,VirtualFlg							
			,DirectFlg							
			,ReserveCD							
			,NoticesCD							
			,PostageCD							
			,ManufactCD							
			,ConfirmCD							
			,StopFlg							
			,DiscontinueFlg							
			,SoldOutFlg							
			,WebStockFlg							
			,InventoryAddFlg							
			,MakerAddFlg							
			,StoreAddFlg							
			,NoNetOrderFlg							
			,EDIOrderFlg							
			,AutoOrderFlg							
			,CatalogFlg							
			,ParcelFlg							
			,TaxRateFLG							
			,CostingKBN							
			,NormalCost							
			,SaleExcludedFlg							
			,PriceWithTax							
			,PriceOutTax							
			,OrderPriceWithTax							
			,OrderPriceWithoutTax							
			,Rate							
			,SaleStartDate							
			,WebStartDate							
			,OrderAttentionCD							
			,OrderAttentionNote							
			,CommentInStore							
			,CommentOutStore							
			,LastYearTerm							
			,LastSeason							
			,LastCatalogNO							
			,LastCatalogPage							
			,LastCatalogText							
			,LastInstructionsNO							
			,LastInstructionsDate							
			,WebAddress							
			,ApprovalDate							
			,(case when ApprovalDate is not null then @Date else null end )	as ApprovalDateTime		
			,TagName01							
			,TagName02							
			,TagName03							
			,TagName04							
			,TagName05							
			,TagName06							
			,TagName07							
			,TagName08							
			,TagName09							
			,TagName10							
			,ExhibitionSegmentCD							
			,OrderLot							
			,DeleteFlg							
			,0 as UsedFlg							
			,1 as SKSUpdateFlg							
			,null as SKSUpdateDateTime							
			,@Opt as InsertOperator							
			,@Date as InsertDateTime							
			,@Opt as UpdateOperator							
			,@Date as UpdateDateTime							
				
			from @ItemTable ) a ) src  	on targ.ItemCD = src.ItemCD and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			-- targ.VariousFLG									 =src.VariousFLG							
			--,targ.ITemName									 =src.ITemName							
			--,targ.KanaName									 =src.KanaName							
			--,targ.ITEMShortName								 =src.ITEMShortName							
			--,targ.EnglishName								 =src.EnglishName							
			 targ.SetKBN									 =src.SetKBN							
			,targ.PresentKBN								 =src.PresentKBN							
			,targ.SampleKBN									 =src.SampleKBN							
			,targ.DiscountKBN								 =src.DiscountKBN							
			--,targ.SizeCount									 =src.SizeCount							
			--,targ.ColorCount								 =src.ColorCount							
			--,targ.SizeName									 =src.SizeName							
			--,targ.ColorName									 =src.ColorName							
			,targ.WebFlg									 =src.WebFlg							
			,targ.RealStoreFlg								 =src.RealStoreFlg							
			--,targ.MainVendorCD								 =src.MainVendorCD							
			--,targ.MakerVendorCD								 =src.MakerVendorCD						
			--,targ.BrandCD									 =src.BrandCD							
			--,targ.MakerItem									 =src.MakerItem							
			--,targ.TaniCD									 =src.TaniCD							
			--,targ.SportsCD									 =src.SportsCD							
			--,targ.SegmentCD									 =src.SegmentCD							
			,targ.ZaikoKBN									 =src.ZaikoKBN							
			--,targ.Rack										 =src.Rack							
			,targ.VirtualFlg								 =src.VirtualFlg							
			,targ.DirectFlg									 =src.DirectFlg							
			,targ.ReserveCD									 =src.ReserveCD							
			,targ.NoticesCD									 =src.NoticesCD							
			,targ.PostageCD									 =src.PostageCD							
			,targ.ManufactCD								 =src.ManufactCD							
			,targ.ConfirmCD									 =src.ConfirmCD							
			,targ.StopFlg									 =src.StopFlg							
			,targ.DiscontinueFlg							 =src.DiscontinueFlg							
			,targ.SoldOutFlg								 =src.SoldOutFlg							
			,targ.WebStockFlg								 =src.WebStockFlg							
			,targ.InventoryAddFlg							 =src.InventoryAddFlg							
			,targ.MakerAddFlg								 =src.MakerAddFlg							
			,targ.StoreAddFlg								 =src.StoreAddFlg							
			,targ.NoNetOrderFlg								 =src.NoNetOrderFlg							
			,targ.EDIOrderFlg								 =src.EDIOrderFlg							
			,targ.AutoOrderFlg								 =src.AutoOrderFlg							
			,targ.CatalogFlg								 =src.CatalogFlg							
			,targ.ParcelFlg									 =src.ParcelFlg							
			--,targ.TaxRateFLG								 =src.TaxRateFLG							
			--,targ.CostingKBN								 =src.CostingKBN							
			--,targ.NormalCost								 =src.NormalCost							
			,targ.SaleExcludedFlg							 =src.SaleExcludedFlg							
			,targ.PriceWithTax								 =src.PriceWithTax							
			,targ.PriceOutTax								 =src.PriceOutTax							
			,targ.OrderPriceWithTax							 =src.OrderPriceWithTax							
			,targ.OrderPriceWithoutTax						 =src.OrderPriceWithoutTax							
			,targ.Rate										 =src.Rate							
			--,targ.SaleStartDate								 =src.SaleStartDate							
			--,targ.WebStartDate								 =src.WebStartDate							
			--,targ.OrderAttentionCD							 =src.OrderAttentionCD							
			--,targ.OrderAttentionNote						 =src.OrderAttentionNote							
			--,targ.CommentInStore							 =src.CommentInStore							
			--,targ.CommentOutStore							 =src.CommentOutStore							
			--,targ.LastYearTerm								 =src.LastYearTerm							
			--,targ.LastSeason								 =src.LastSeason							
			--,targ.LastCatalogNO								 =src.LastCatalogNO							
			--,targ.LastCatalogPage							 =src.LastCatalogPage							
			--,targ.LastCatalogText							 =src.LastCatalogText							
			--,targ.LastInstructionsNO						 =src.LastInstructionsNO							
			--,targ.LastInstructionsDate						 =src.LastInstructionsDate							
			--,targ.WebAddress								 =src.WebAddress							
			,targ.ApprovalDate								 =src.ApprovalDate							
			,targ.ApprovalDateTime							 =(case when src.ApprovalDate is not null then @Date else null end )		
			--,targ.TagName01									 =src.TagName01							
			--,targ.TagName02									 =src.TagName02							
			--,targ.TagName03									 =src.TagName03							
			--,targ.TagName04									 =src.TagName04							
			--,targ.TagName05									 =src.TagName05							
			--,targ.TagName06									 =src.TagName06							
			--,targ.TagName07									 =src.TagName07							
			--,targ.TagName08									 =src.TagName08							
			--,targ.TagName09									 =src.TagName09							
			--,targ.TagName10									 =src.TagName10							
			--,targ.ExhibitionSegmentCD						 =src.ExhibitionSegmentCD							
			--,targ.OrderLot									 =src.OrderLot							
			,targ.DeleteFlg									 =src.DeleteFlg							
			--,targ.UsedFlg									 =src.UsedFlg							
			--,targ.SKSUpdateFlg								 =src.SKSUpdateFlg							
			--,targ.SKSUpdateDateTime							 =src.SKSUpdateDateTime							
			--,targ.InsertOperator							 =src.InsertOperator							
			--,targ.InsertDateTime							 =src.InsertDateTime							
			,targ.UpdateOperator							 =src.UpdateOperator							
			,targ.UpdateDateTime							 =src.UpdateDateTime		
			

			when not matched by target and @Ins = 1 then insert
			(
			ItemCD
			,ChangeDate
			,VariousFLG				
			,ITemName					
			,KanaName					
			,ITEMShortName				
			,EnglishName				
			,SetKBN					
			,PresentKBN				
			,SampleKBN					
			,DiscountKBN				
			,SizeCount					
			,ColorCount				
			,SizeName					
			,ColorName					
			,WebFlg					
			,RealStoreFlg				
			,MainVendorCD				
			,MakerVendorCD				
			,BrandCD					
			,MakerItem					
			,TaniCD					
			,SportsCD					
			,SegmentCD					
			,ZaikoKBN					
			,Rack						
			,VirtualFlg				
			,DirectFlg					
			,ReserveCD					
			,NoticesCD					
			,PostageCD					
			,ManufactCD				
			,ConfirmCD					
			,StopFlg					
			,DiscontinueFlg			
			,SoldOutFlg				
			,WebStockFlg				
			,InventoryAddFlg			
			,MakerAddFlg				
			,StoreAddFlg				
			,NoNetOrderFlg				
			,EDIOrderFlg				
			,AutoOrderFlg				
			,CatalogFlg				
			,ParcelFlg					
			,TaxRateFLG				
			,CostingKBN				
			,NormalCost				
			,SaleExcludedFlg			
			,PriceWithTax				
			,PriceOutTax				
			,OrderPriceWithTax			
			,OrderPriceWithoutTax		
			,Rate						
			,SaleStartDate				
			,WebStartDate				
			,OrderAttentionCD			
			,OrderAttentionNote		
			,CommentInStore			
			,CommentOutStore			
			,LastYearTerm				
			,LastSeason				
			,LastCatalogNO				
			,LastCatalogPage			
			,LastCatalogText			
			,LastInstructionsNO		
			,LastInstructionsDate		
			,WebAddress				
			,ApprovalDate				
			,ApprovalDateTime			
			,TagName01					
			,TagName02					
			,TagName03					
			,TagName04					
			,TagName05					
			,TagName06					
			,TagName07					
			,TagName08					
			,TagName09					
			,TagName10					
			,ExhibitionSegmentCD		
			,OrderLot					
			,DeleteFlg					
			,UsedFlg					
			,SKSUpdateFlg				
			,SKSUpdateDateTime			
			,InsertOperator			
			,InsertDateTime			
			,UpdateOperator			
			,UpdateDateTime			
			)
			values
			(
			ItemCD
			,src.ChangeDate
			,src.VariousFLG				
			,src.ITemName					
			,src.KanaName					
			,src.ITEMShortName				
			,src.EnglishName				
			,src.SetKBN					
			,src.PresentKBN				
			,src.SampleKBN					
			,src.DiscountKBN				
			,src.SizeCount					
			,src.ColorCount				
			,src.SizeName					
			,src.ColorName					
			,src.WebFlg					
			,src.RealStoreFlg				
			,src.MainVendorCD				
			,src.MakerVendorCD				
			,src.BrandCD					
			,src.MakerItem					
			,src.TaniCD					
			,src.SportsCD					
			,src.SegmentCD					
			,src.ZaikoKBN					
			,src.Rack						
			,src.VirtualFlg				
			,src.DirectFlg					
			,src.ReserveCD					
			,src.NoticesCD					
			,src.PostageCD					
			,src.ManufactCD				
			,src.ConfirmCD					
			,src.StopFlg					
			,src.DiscontinueFlg			
			,src.SoldOutFlg				
			,src.WebStockFlg				
			,src.InventoryAddFlg			
			,src.MakerAddFlg				
			,src.StoreAddFlg				
			,src.NoNetOrderFlg				
			,src.EDIOrderFlg				
			,src.AutoOrderFlg				
			,src.CatalogFlg				
			,src.ParcelFlg					
			,src.TaxRateFLG				
			,src.CostingKBN				
			,src.NormalCost				
			,src.SaleExcludedFlg			
			,src.PriceWithTax				
			,src.PriceOutTax				
			,src.OrderPriceWithTax			
			,src.OrderPriceWithoutTax		
			,src.Rate						
			,src.SaleStartDate				
			,src.WebStartDate				
			,src.OrderAttentionCD			
			,src.OrderAttentionNote		
			,src.CommentInStore			
			,src.CommentOutStore			
			,src.LastYearTerm				
			,src.LastSeason				
			,src.LastCatalogNO				
			,src.LastCatalogPage			
			,src.LastCatalogText			
			,src.LastInstructionsNO		
			,src.LastInstructionsDate		
			,src.WebAddress				
			,src.ApprovalDate				
			,src.ApprovalDateTime			
			,src.TagName01					
			,src.TagName02					
			,src.TagName03					
			,src.TagName04					
			,src.TagName05					
			,src.TagName06					
			,src.TagName07					
			,src.TagName08					
			,src.TagName09					
			,src.TagName10					
			,src.ExhibitionSegmentCD		
			,src.OrderLot					
			,src.DeleteFlg					
			,src.UsedFlg					
			,src.SKSUpdateFlg				
			,src.SKSUpdateDateTime			
			,src.InsertOperator			
			,src.InsertDateTime			
			,src.UpdateOperator			
			,src.UpdateDateTime			
			);
    End
	if (@MainFlg =4)
	Begin
	    set @Ins =0;
		Merge [M_item] targ using ( select *  from	(select 
			ITemCD							
			,ChangeDate							
			,VariousFLG							
			,ITemName							
			,KanaName							
			,ITEMShortName							
			,EnglishName							
			,SetKBN							
			,PresentKBN							
			,SampleKBN							
			,DiscountKBN							
			,SizeCount							
			,ColorCount							
			,null as SizeName							
			,null as ColorName							
			,WebFlg							
			,RealStoreFlg							
			,MainVendorCD							
			,MainVendorCD as MakerVendorCD							
			,BrandCD							
			,MakerItem							
			,TaniCD							
			,SportsCD							
			,SegmentCD							
			,ZaikoKBN							
			,Rack							
			,VirtualFlg							
			,DirectFlg							
			,ReserveCD							
			,NoticesCD							
			,PostageCD							
			,ManufactCD							
			,ConfirmCD							
			,StopFlg							
			,DiscontinueFlg							
			,SoldOutFlg							
			,WebStockFlg							
			,InventoryAddFlg							
			,MakerAddFlg							
			,StoreAddFlg							
			,NoNetOrderFlg							
			,EDIOrderFlg							
			,AutoOrderFlg							
			,CatalogFlg							
			,ParcelFlg							
			,TaxRateFLG							
			,CostingKBN							
			,NormalCost							
			,SaleExcludedFlg							
			,PriceWithTax							
			,PriceOutTax							
			,OrderPriceWithTax							
			,OrderPriceWithoutTax							
			,Rate							
			,SaleStartDate							
			,WebStartDate							
			,OrderAttentionCD							
			,OrderAttentionNote							
			,CommentInStore							
			,CommentOutStore							
			,LastYearTerm							
			,LastSeason							
			,LastCatalogNO							
			,LastCatalogPage							
			,LastCatalogText							
			,LastInstructionsNO							
			,LastInstructionsDate							
			,WebAddress							
			,ApprovalDate							
			,(case when ApprovalDate is not null then @Date else null end )	as ApprovalDateTime		
			,TagName01							
			,TagName02							
			,TagName03							
			,TagName04							
			,TagName05							
			,TagName06							
			,TagName07							
			,TagName08							
			,TagName09							
			,TagName10							
			,ExhibitionSegmentCD							
			,OrderLot							
			,DeleteFlg							
			,0 as UsedFlg							
			,1 as SKSUpdateFlg							
			,null as SKSUpdateDateTime							
			,@Opt as InsertOperator							
			,@Date as InsertDateTime							
			,@Opt as UpdateOperator							
			,@Date as UpdateDateTime							
				
			from @ItemTable ) a ) src  	on targ.ItemCD = src.ItemCD and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			-- targ.VariousFLG									 =src.VariousFLG							
			--,targ.ITemName									 =src.ITemName							
			--,targ.KanaName									 =src.KanaName							
			--,targ.ITEMShortName								 =src.ITEMShortName							
			--,targ.EnglishName								 =src.EnglishName							
			--,targ.SetKBN									 =src.SetKBN							
			--,targ.PresentKBN								 =src.PresentKBN							
			--,targ.SampleKBN									 =src.SampleKBN							
			--,targ.DiscountKBN								 =src.DiscountKBN							
			--,targ.SizeCount									 =src.SizeCount							
			--,targ.ColorCount								 =src.ColorCount							
			--,targ.SizeName									 =src.SizeName							
			--,targ.ColorName									 =src.ColorName							
			--,targ.WebFlg									 =src.WebFlg							
			--,targ.RealStoreFlg								 =src.RealStoreFlg							
			--,targ.MainVendorCD								 =src.MainVendorCD							
			--,targ.MakerVendorCD								 =src.MakerVendorCD						
			--,targ.BrandCD									 =src.BrandCD							
			--,targ.MakerItem									 =src.MakerItem							
			--,targ.TaniCD									 =src.TaniCD							
			--,targ.SportsCD									 =src.SportsCD							
			--,targ.SegmentCD									 =src.SegmentCD							
			--,targ.ZaikoKBN									 =src.ZaikoKBN							
			--,targ.Rack										 =src.Rack							
			--,targ.VirtualFlg								 =src.VirtualFlg							
			--,targ.DirectFlg									 =src.DirectFlg							
			--,targ.ReserveCD									 =src.ReserveCD							
			--,targ.NoticesCD									 =src.NoticesCD							
			--,targ.PostageCD									 =src.PostageCD							
			--,targ.ManufactCD								 =src.ManufactCD							
			--,targ.ConfirmCD									 =src.ConfirmCD							
			--,targ.StopFlg									 =src.StopFlg							
			--,targ.DiscontinueFlg							 =src.DiscontinueFlg							
			--,targ.SoldOutFlg								 =src.SoldOutFlg							
			--,targ.WebStockFlg								 =src.WebStockFlg							
			--,targ.InventoryAddFlg							 =src.InventoryAddFlg							
			--,targ.MakerAddFlg								 =src.MakerAddFlg							
			--,targ.StoreAddFlg								 =src.StoreAddFlg							
			--,targ.NoNetOrderFlg								 =src.NoNetOrderFlg							
			--,targ.EDIOrderFlg								 =src.EDIOrderFlg							
			--,targ.AutoOrderFlg								 =src.AutoOrderFlg							
			--,targ.CatalogFlg								 =src.CatalogFlg							
			--,targ.ParcelFlg									 =src.ParcelFlg							
			targ.TaxRateFLG								 =src.TaxRateFLG							
			,targ.CostingKBN								 =src.CostingKBN							
			,targ.NormalCost								 =src.NormalCost							
			,targ.SaleExcludedFlg							 =src.SaleExcludedFlg							
			,targ.PriceWithTax								 =src.PriceWithTax							
			,targ.PriceOutTax								 =src.PriceOutTax							
			,targ.OrderPriceWithTax							 =src.OrderPriceWithTax							
			,targ.OrderPriceWithoutTax						 =src.OrderPriceWithoutTax							
			,targ.Rate										 =src.Rate							
			--,targ.SaleStartDate								 =src.SaleStartDate							
			--,targ.WebStartDate								 =src.WebStartDate							
			--,targ.OrderAttentionCD							 =src.OrderAttentionCD							
			--,targ.OrderAttentionNote						 =src.OrderAttentionNote							
			--,targ.CommentInStore							 =src.CommentInStore							
			--,targ.CommentOutStore							 =src.CommentOutStore							
			--,targ.LastYearTerm								 =src.LastYearTerm							
			--,targ.LastSeason								 =src.LastSeason							
			--,targ.LastCatalogNO								 =src.LastCatalogNO							
			--,targ.LastCatalogPage							 =src.LastCatalogPage							
			--,targ.LastCatalogText							 =src.LastCatalogText							
			--,targ.LastInstructionsNO						 =src.LastInstructionsNO							
			--,targ.LastInstructionsDate						 =src.LastInstructionsDate							
			--,targ.WebAddress								 =src.WebAddress							
			,targ.ApprovalDate								 =src.ApprovalDate							
			,targ.ApprovalDateTime							 =(case when src.ApprovalDate is not null then @Date else null end )	
			--,targ.TagName01									 =src.TagName01							
			--,targ.TagName02									 =src.TagName02							
			--,targ.TagName03									 =src.TagName03							
			--,targ.TagName04									 =src.TagName04							
			--,targ.TagName05									 =src.TagName05							
			--,targ.TagName06									 =src.TagName06							
			--,targ.TagName07									 =src.TagName07							
			--,targ.TagName08									 =src.TagName08							
			--,targ.TagName09									 =src.TagName09							
			--,targ.TagName10									 =src.TagName10							
			--,targ.ExhibitionSegmentCD						 =src.ExhibitionSegmentCD							
			--,targ.OrderLot									 =src.OrderLot							
			,targ.DeleteFlg									 =src.DeleteFlg							
			--,targ.UsedFlg									 =src.UsedFlg							
			--,targ.SKSUpdateFlg								 =src.SKSUpdateFlg							
			--,targ.SKSUpdateDateTime							 =src.SKSUpdateDateTime							
			--,targ.InsertOperator							 =src.InsertOperator							
			--,targ.InsertDateTime							 =src.InsertDateTime							
			,targ.UpdateOperator							 =src.UpdateOperator							
			,targ.UpdateDateTime							 =src.UpdateDateTime		
			

			when not matched by target and @Ins = 1 then insert
			(
			ItemCD
			,ChangeDate
			,VariousFLG				
			,ITemName					
			,KanaName					
			,ITEMShortName				
			,EnglishName				
			,SetKBN					
			,PresentKBN				
			,SampleKBN					
			,DiscountKBN				
			,SizeCount					
			,ColorCount				
			,SizeName					
			,ColorName					
			,WebFlg					
			,RealStoreFlg				
			,MainVendorCD				
			,MakerVendorCD				
			,BrandCD					
			,MakerItem					
			,TaniCD					
			,SportsCD					
			,SegmentCD					
			,ZaikoKBN					
			,Rack						
			,VirtualFlg				
			,DirectFlg					
			,ReserveCD					
			,NoticesCD					
			,PostageCD					
			,ManufactCD				
			,ConfirmCD					
			,StopFlg					
			,DiscontinueFlg			
			,SoldOutFlg				
			,WebStockFlg				
			,InventoryAddFlg			
			,MakerAddFlg				
			,StoreAddFlg				
			,NoNetOrderFlg				
			,EDIOrderFlg				
			,AutoOrderFlg				
			,CatalogFlg				
			,ParcelFlg					
			,TaxRateFLG				
			,CostingKBN				
			,NormalCost				
			,SaleExcludedFlg			
			,PriceWithTax				
			,PriceOutTax				
			,OrderPriceWithTax			
			,OrderPriceWithoutTax		
			,Rate						
			,SaleStartDate				
			,WebStartDate				
			,OrderAttentionCD			
			,OrderAttentionNote		
			,CommentInStore			
			,CommentOutStore			
			,LastYearTerm				
			,LastSeason				
			,LastCatalogNO				
			,LastCatalogPage			
			,LastCatalogText			
			,LastInstructionsNO		
			,LastInstructionsDate		
			,WebAddress				
			,ApprovalDate				
			,ApprovalDateTime			
			,TagName01					
			,TagName02					
			,TagName03					
			,TagName04					
			,TagName05					
			,TagName06					
			,TagName07					
			,TagName08					
			,TagName09					
			,TagName10					
			,ExhibitionSegmentCD		
			,OrderLot					
			,DeleteFlg					
			,UsedFlg					
			,SKSUpdateFlg				
			,SKSUpdateDateTime			
			,InsertOperator			
			,InsertDateTime			
			,UpdateOperator			
			,UpdateDateTime			
			)
			values
			(
			ItemCD
			,src.ChangeDate
			,src.VariousFLG				
			,src.ITemName					
			,src.KanaName					
			,src.ITEMShortName				
			,src.EnglishName				
			,src.SetKBN					
			,src.PresentKBN				
			,src.SampleKBN					
			,src.DiscountKBN				
			,src.SizeCount					
			,src.ColorCount				
			,src.SizeName					
			,src.ColorName					
			,src.WebFlg					
			,src.RealStoreFlg				
			,src.MainVendorCD				
			,src.MakerVendorCD				
			,src.BrandCD					
			,src.MakerItem					
			,src.TaniCD					
			,src.SportsCD					
			,src.SegmentCD					
			,src.ZaikoKBN					
			,src.Rack						
			,src.VirtualFlg				
			,src.DirectFlg					
			,src.ReserveCD					
			,src.NoticesCD					
			,src.PostageCD					
			,src.ManufactCD				
			,src.ConfirmCD					
			,src.StopFlg					
			,src.DiscontinueFlg			
			,src.SoldOutFlg				
			,src.WebStockFlg				
			,src.InventoryAddFlg			
			,src.MakerAddFlg				
			,src.StoreAddFlg				
			,src.NoNetOrderFlg				
			,src.EDIOrderFlg				
			,src.AutoOrderFlg				
			,src.CatalogFlg				
			,src.ParcelFlg					
			,src.TaxRateFLG				
			,src.CostingKBN				
			,src.NormalCost				
			,src.SaleExcludedFlg			
			,src.PriceWithTax				
			,src.PriceOutTax				
			,src.OrderPriceWithTax			
			,src.OrderPriceWithoutTax		
			,src.Rate						
			,src.SaleStartDate				
			,src.WebStartDate				
			,src.OrderAttentionCD			
			,src.OrderAttentionNote		
			,src.CommentInStore			
			,src.CommentOutStore			
			,src.LastYearTerm				
			,src.LastSeason				
			,src.LastCatalogNO				
			,src.LastCatalogPage			
			,src.LastCatalogText			
			,src.LastInstructionsNO		
			,src.LastInstructionsDate		
			,src.WebAddress				
			,src.ApprovalDate				
			,src.ApprovalDateTime			
			,src.TagName01					
			,src.TagName02					
			,src.TagName03					
			,src.TagName04					
			,src.TagName05					
			,src.TagName06					
			,src.TagName07					
			,src.TagName08					
			,src.TagName09					
			,src.TagName10					
			,src.ExhibitionSegmentCD		
			,src.OrderLot					
			,src.DeleteFlg					
			,src.UsedFlg					
			,src.SKSUpdateFlg				
			,src.SKSUpdateDateTime			
			,src.InsertOperator			
			,src.InsertDateTime			
			,src.UpdateOperator			
			,src.UpdateDateTime			
			);
    End
	if (@MainFlg =5)
	Begin
    	set @Ins =0;
		Merge [M_item] targ using ( select *  from	(select 
			ITemCD							
			,ChangeDate							
			,VariousFLG							
			,ITemName							
			,KanaName							
			,ITEMShortName							
			,EnglishName							
			,SetKBN							
			,PresentKBN							
			,SampleKBN							
			,DiscountKBN							
			,SizeCount							
			,ColorCount							
			,null as SizeName							
			,null as ColorName							
			,WebFlg							
			,RealStoreFlg							
			,MainVendorCD							
			,MainVendorCD as MakerVendorCD							
			,BrandCD							
			,MakerItem							
			,TaniCD							
			,SportsCD							
			,SegmentCD							
			,ZaikoKBN							
			,Rack							
			,VirtualFlg							
			,DirectFlg							
			,ReserveCD							
			,NoticesCD							
			,PostageCD							
			,ManufactCD							
			,ConfirmCD							
			,StopFlg							
			,DiscontinueFlg							
			,SoldOutFlg							
			,WebStockFlg							
			,InventoryAddFlg							
			,MakerAddFlg							
			,StoreAddFlg							
			,NoNetOrderFlg							
			,EDIOrderFlg							
			,AutoOrderFlg							
			,CatalogFlg							
			,ParcelFlg							
			,TaxRateFLG							
			,CostingKBN							
			,NormalCost							
			,SaleExcludedFlg							
			,PriceWithTax							
			,PriceOutTax							
			,OrderPriceWithTax							
			,OrderPriceWithoutTax							
			,Rate							
			,SaleStartDate							
			,WebStartDate							
			,OrderAttentionCD							
			,OrderAttentionNote							
			,CommentInStore							
			,CommentOutStore							
			,LastYearTerm							
			,LastSeason							
			,LastCatalogNO							
			,LastCatalogPage							
			,LastCatalogText							
			,LastInstructionsNO							
			,LastInstructionsDate							
			,WebAddress							
			,ApprovalDate							
			,(case when ApprovalDate is not null then @Date else null end )	as ApprovalDateTime		
			,TagName01							
			,TagName02							
			,TagName03							
			,TagName04							
			,TagName05							
			,TagName06							
			,TagName07							
			,TagName08							
			,TagName09							
			,TagName10							
			,ExhibitionSegmentCD							
			,OrderLot							
			,DeleteFlg							
			,0 as UsedFlg							
			,1 as SKSUpdateFlg							
			,null as SKSUpdateDateTime							
			,@Opt as InsertOperator							
			,@Date as InsertDateTime							
			,@Opt as UpdateOperator							
			,@Date as UpdateDateTime							
				
			from @ItemTable ) a ) src  	on targ.ItemCD = src.ItemCD and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			-- targ.VariousFLG									 =src.VariousFLG							
			--,targ.ITemName									 =src.ITemName							
			--,targ.KanaName									 =src.KanaName							
			--,targ.ITEMShortName								 =src.ITEMShortName							
			--,targ.EnglishName								 =src.EnglishName							
			--,targ.SetKBN									 =src.SetKBN							
			--,targ.PresentKBN								 =src.PresentKBN							
			--,targ.SampleKBN									 =src.SampleKBN							
			--,targ.DiscountKBN								 =src.DiscountKBN							
			--,targ.SizeCount									 =src.SizeCount							
			--,targ.ColorCount								 =src.ColorCount							
			--,targ.SizeName									 =src.SizeName							
			--,targ.ColorName									 =src.ColorName							
			--,targ.WebFlg									 =src.WebFlg							
			--,targ.RealStoreFlg								 =src.RealStoreFlg							
			--,targ.MainVendorCD								 =src.MainVendorCD							
			--,targ.MakerVendorCD								 =src.MakerVendorCD						
			--,targ.BrandCD									 =src.BrandCD							
			--,targ.MakerItem									 =src.MakerItem							
			--,targ.TaniCD									 =src.TaniCD							
			--,targ.SportsCD									 =src.SportsCD							
			--,targ.SegmentCD									 =src.SegmentCD							
			--,targ.ZaikoKBN									 =src.ZaikoKBN							
			--,targ.Rack										 =src.Rack							
			--,targ.VirtualFlg								 =src.VirtualFlg							
			--,targ.DirectFlg									 =src.DirectFlg							
			--,targ.ReserveCD									 =src.ReserveCD							
			--,targ.NoticesCD									 =src.NoticesCD							
			--,targ.PostageCD									 =src.PostageCD							
			--,targ.ManufactCD								 =src.ManufactCD							
			--,targ.ConfirmCD									 =src.ConfirmCD							
			--,targ.StopFlg									 =src.StopFlg							
			--,targ.DiscontinueFlg							 =src.DiscontinueFlg							
			--,targ.SoldOutFlg								 =src.SoldOutFlg							
			--,targ.WebStockFlg								 =src.WebStockFlg							
			--,targ.InventoryAddFlg							 =src.InventoryAddFlg							
			--,targ.MakerAddFlg								 =src.MakerAddFlg							
			--,targ.StoreAddFlg								 =src.StoreAddFlg							
			--,targ.NoNetOrderFlg								 =src.NoNetOrderFlg							
			--,targ.EDIOrderFlg								 =src.EDIOrderFlg							
			--,targ.AutoOrderFlg								 =src.AutoOrderFlg							
			--,targ.CatalogFlg								 =src.CatalogFlg							
			--,targ.ParcelFlg									 =src.ParcelFlg							
			--,targ.TaxRateFLG								 =src.TaxRateFLG							
			--,targ.CostingKBN								 =src.CostingKBN							
			--,targ.NormalCost								 =src.NormalCost							
			--,targ.SaleExcludedFlg							 =src.SaleExcludedFlg							
			--,targ.PriceWithTax								 =src.PriceWithTax							
			--,targ.PriceOutTax								 =src.PriceOutTax							
			--,targ.OrderPriceWithTax							 =src.OrderPriceWithTax							
			--,targ.OrderPriceWithoutTax						 =src.OrderPriceWithoutTax							
			--,targ.Rate										 =src.Rate							
			--,targ.SaleStartDate								 =src.SaleStartDate							
			--,targ.WebStartDate								 =src.WebStartDate							
			--,targ.OrderAttentionCD							 =src.OrderAttentionCD							
			--,targ.OrderAttentionNote						 =src.OrderAttentionNote							
			--,targ.CommentInStore							 =src.CommentInStore							
			--,targ.CommentOutStore							 =src.CommentOutStore							
			 targ.LastYearTerm								 =src.LastYearTerm							
			,targ.LastSeason								 =src.LastSeason							
			,targ.LastCatalogNO								 =src.LastCatalogNO							
			,targ.LastCatalogPage							 =src.LastCatalogPage							
			,targ.LastCatalogText							 =src.LastCatalogText							
			,targ.LastInstructionsNO						 =src.LastInstructionsNO							
			,targ.LastInstructionsDate						 =src.LastInstructionsDate							
			--,targ.WebAddress								 =src.WebAddress							
			,targ.ApprovalDate								 =src.ApprovalDate							
			,targ.ApprovalDateTime							 =(case when src.ApprovalDate is not null then @Date else null end )		
			--,targ.TagName01									 =src.TagName01							
			--,targ.TagName02									 =src.TagName02							
			--,targ.TagName03									 =src.TagName03							
			--,targ.TagName04									 =src.TagName04							
			--,targ.TagName05									 =src.TagName05							
			--,targ.TagName06									 =src.TagName06							
			--,targ.TagName07									 =src.TagName07							
			--,targ.TagName08									 =src.TagName08							
			--,targ.TagName09									 =src.TagName09							
			--,targ.TagName10									 =src.TagName10							
			--,targ.ExhibitionSegmentCD						 =src.ExhibitionSegmentCD							
			--,targ.OrderLot									 =src.OrderLot							
			,targ.DeleteFlg									 =src.DeleteFlg							
			--,targ.UsedFlg									 =src.UsedFlg							
			--,targ.SKSUpdateFlg								 =src.SKSUpdateFlg							
			--,targ.SKSUpdateDateTime							 =src.SKSUpdateDateTime							
			--,targ.InsertOperator							 =src.InsertOperator							
			--,targ.InsertDateTime							 =src.InsertDateTime							
			,targ.UpdateOperator							 =src.UpdateOperator							
			,targ.UpdateDateTime							 =src.UpdateDateTime		
			

			when not matched by target and @Ins = 1 then insert
			(
			ItemCD
			,ChangeDate
			,VariousFLG				
			,ITemName					
			,KanaName					
			,ITEMShortName				
			,EnglishName				
			,SetKBN					
			,PresentKBN				
			,SampleKBN					
			,DiscountKBN				
			,SizeCount					
			,ColorCount				
			,SizeName					
			,ColorName					
			,WebFlg					
			,RealStoreFlg				
			,MainVendorCD				
			,MakerVendorCD				
			,BrandCD					
			,MakerItem					
			,TaniCD					
			,SportsCD					
			,SegmentCD					
			,ZaikoKBN					
			,Rack						
			,VirtualFlg				
			,DirectFlg					
			,ReserveCD					
			,NoticesCD					
			,PostageCD					
			,ManufactCD				
			,ConfirmCD					
			,StopFlg					
			,DiscontinueFlg			
			,SoldOutFlg				
			,WebStockFlg				
			,InventoryAddFlg			
			,MakerAddFlg				
			,StoreAddFlg				
			,NoNetOrderFlg				
			,EDIOrderFlg				
			,AutoOrderFlg				
			,CatalogFlg				
			,ParcelFlg					
			,TaxRateFLG				
			,CostingKBN				
			,NormalCost				
			,SaleExcludedFlg			
			,PriceWithTax				
			,PriceOutTax				
			,OrderPriceWithTax			
			,OrderPriceWithoutTax		
			,Rate						
			,SaleStartDate				
			,WebStartDate				
			,OrderAttentionCD			
			,OrderAttentionNote		
			,CommentInStore			
			,CommentOutStore			
			,LastYearTerm				
			,LastSeason				
			,LastCatalogNO				
			,LastCatalogPage			
			,LastCatalogText			
			,LastInstructionsNO		
			,LastInstructionsDate		
			,WebAddress				
			,ApprovalDate				
			,ApprovalDateTime			
			,TagName01					
			,TagName02					
			,TagName03					
			,TagName04					
			,TagName05					
			,TagName06					
			,TagName07					
			,TagName08					
			,TagName09					
			,TagName10					
			,ExhibitionSegmentCD		
			,OrderLot					
			,DeleteFlg					
			,UsedFlg					
			,SKSUpdateFlg				
			,SKSUpdateDateTime			
			,InsertOperator			
			,InsertDateTime			
			,UpdateOperator			
			,UpdateDateTime			
			)
			values
			(
			ItemCD
			,src.ChangeDate
			,src.VariousFLG				
			,src.ITemName					
			,src.KanaName					
			,src.ITEMShortName				
			,src.EnglishName				
			,src.SetKBN					
			,src.PresentKBN				
			,src.SampleKBN					
			,src.DiscountKBN				
			,src.SizeCount					
			,src.ColorCount				
			,src.SizeName					
			,src.ColorName					
			,src.WebFlg					
			,src.RealStoreFlg				
			,src.MainVendorCD				
			,src.MakerVendorCD				
			,src.BrandCD					
			,src.MakerItem					
			,src.TaniCD					
			,src.SportsCD					
			,src.SegmentCD					
			,src.ZaikoKBN					
			,src.Rack						
			,src.VirtualFlg				
			,src.DirectFlg					
			,src.ReserveCD					
			,src.NoticesCD					
			,src.PostageCD					
			,src.ManufactCD				
			,src.ConfirmCD					
			,src.StopFlg					
			,src.DiscontinueFlg			
			,src.SoldOutFlg				
			,src.WebStockFlg				
			,src.InventoryAddFlg			
			,src.MakerAddFlg				
			,src.StoreAddFlg				
			,src.NoNetOrderFlg				
			,src.EDIOrderFlg				
			,src.AutoOrderFlg				
			,src.CatalogFlg				
			,src.ParcelFlg					
			,src.TaxRateFLG				
			,src.CostingKBN				
			,src.NormalCost				
			,src.SaleExcludedFlg			
			,src.PriceWithTax				
			,src.PriceOutTax				
			,src.OrderPriceWithTax			
			,src.OrderPriceWithoutTax		
			,src.Rate						
			,src.SaleStartDate				
			,src.WebStartDate				
			,src.OrderAttentionCD			
			,src.OrderAttentionNote		
			,src.CommentInStore			
			,src.CommentOutStore			
			,src.LastYearTerm				
			,src.LastSeason				
			,src.LastCatalogNO				
			,src.LastCatalogPage			
			,src.LastCatalogText			
			,src.LastInstructionsNO		
			,src.LastInstructionsDate		
			,src.WebAddress				
			,src.ApprovalDate				
			,src.ApprovalDateTime			
			,src.TagName01					
			,src.TagName02					
			,src.TagName03					
			,src.TagName04					
			,src.TagName05					
			,src.TagName06					
			,src.TagName07					
			,src.TagName08					
			,src.TagName09					
			,src.TagName10					
			,src.ExhibitionSegmentCD		
			,src.OrderLot					
			,src.DeleteFlg					
			,src.UsedFlg					
			,src.SKSUpdateFlg				
			,src.SKSUpdateDateTime			
			,src.InsertOperator			
			,src.InsertDateTime			
			,src.UpdateOperator			
			,src.UpdateDateTime			
			);
	End
	if (@MainFlg = 6)
	Begin
	    set @Ins =0;
		Merge [M_item] targ using ( select *  from	(select 
			ITemCD							
			,ChangeDate							
			,VariousFLG							
			,ITemName							
			,KanaName							
			,ITEMShortName							
			,EnglishName							
			,SetKBN							
			,PresentKBN							
			,SampleKBN							
			,DiscountKBN							
			,SizeCount							
			,ColorCount							
			,null as SizeName							
			,null as ColorName							
			,WebFlg							
			,RealStoreFlg							
			,MainVendorCD							
			,MainVendorCD as MakerVendorCD							
			,BrandCD							
			,MakerItem							
			,TaniCD							
			,SportsCD							
			,SegmentCD							
			,ZaikoKBN							
			,Rack							
			,VirtualFlg							
			,DirectFlg							
			,ReserveCD							
			,NoticesCD							
			,PostageCD							
			,ManufactCD							
			,ConfirmCD							
			,StopFlg							
			,DiscontinueFlg							
			,SoldOutFlg							
			,WebStockFlg							
			,InventoryAddFlg							
			,MakerAddFlg							
			,StoreAddFlg							
			,NoNetOrderFlg							
			,EDIOrderFlg							
			,AutoOrderFlg							
			,CatalogFlg							
			,ParcelFlg							
			,TaxRateFLG							
			,CostingKBN							
			,NormalCost							
			,SaleExcludedFlg							
			,PriceWithTax							
			,PriceOutTax							
			,OrderPriceWithTax							
			,OrderPriceWithoutTax							
			,Rate							
			,SaleStartDate							
			,WebStartDate							
			,OrderAttentionCD							
			,OrderAttentionNote							
			,CommentInStore							
			,CommentOutStore							
			,LastYearTerm							
			,LastSeason							
			,LastCatalogNO							
			,LastCatalogPage							
			,LastCatalogText							
			,LastInstructionsNO							
			,LastInstructionsDate							
			,WebAddress							
			,ApprovalDate							
			,(case when ApprovalDate is not null then @Date else null end )	as ApprovalDateTime		
			,TagName01							
			,TagName02							
			,TagName03							
			,TagName04							
			,TagName05							
			,TagName06							
			,TagName07							
			,TagName08							
			,TagName09							
			,TagName10							
			,ExhibitionSegmentCD							
			,OrderLot							
			,DeleteFlg							
			,0 as UsedFlg							
			,1 as SKSUpdateFlg							
			,null as SKSUpdateDateTime							
			,@Opt as InsertOperator							
			,@Date as InsertDateTime							
			,@Opt as UpdateOperator							
			,@Date as UpdateDateTime							
				
			from @ItemTable ) a ) src  	on targ.ItemCD = src.ItemCD and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			-- targ.VariousFLG									 =src.VariousFLG							
			--,targ.ITemName									 =src.ITemName							
			--,targ.KanaName									 =src.KanaName							
			--,targ.ITEMShortName								 =src.ITEMShortName							
			--,targ.EnglishName								 =src.EnglishName							
			--,targ.SetKBN									 =src.SetKBN							
			--,targ.PresentKBN								 =src.PresentKBN							
			--,targ.SampleKBN									 =src.SampleKBN							
			--,targ.DiscountKBN								 =src.DiscountKBN							
			--,targ.SizeCount									 =src.SizeCount							
			--,targ.ColorCount								 =src.ColorCount							
			--,targ.SizeName									 =src.SizeName							
			--,targ.ColorName									 =src.ColorName							
			--,targ.WebFlg									 =src.WebFlg							
			--,targ.RealStoreFlg								 =src.RealStoreFlg							
			--,targ.MainVendorCD								 =src.MainVendorCD							
			--,targ.MakerVendorCD								 =src.MakerVendorCD						
			--,targ.BrandCD									 =src.BrandCD							
			--,targ.MakerItem									 =src.MakerItem							
			--,targ.TaniCD									 =src.TaniCD							
			--,targ.SportsCD									 =src.SportsCD							
			--,targ.SegmentCD									 =src.SegmentCD							
			--,targ.ZaikoKBN									 =src.ZaikoKBN							
			--,targ.Rack										 =src.Rack							
			--,targ.VirtualFlg								 =src.VirtualFlg							
			--,targ.DirectFlg									 =src.DirectFlg							
			--,targ.ReserveCD									 =src.ReserveCD							
			--,targ.NoticesCD									 =src.NoticesCD							
			--,targ.PostageCD									 =src.PostageCD							
			--,targ.ManufactCD								 =src.ManufactCD							
			--,targ.ConfirmCD									 =src.ConfirmCD							
			--,targ.StopFlg									 =src.StopFlg							
			--,targ.DiscontinueFlg							 =src.DiscontinueFlg							
			--,targ.SoldOutFlg								 =src.SoldOutFlg							
			--,targ.WebStockFlg								 =src.WebStockFlg							
			--,targ.InventoryAddFlg							 =src.InventoryAddFlg							
			--,targ.MakerAddFlg								 =src.MakerAddFlg							
			--,targ.StoreAddFlg								 =src.StoreAddFlg							
			--,targ.NoNetOrderFlg								 =src.NoNetOrderFlg							
			--,targ.EDIOrderFlg								 =src.EDIOrderFlg							
			--,targ.AutoOrderFlg								 =src.AutoOrderFlg							
			--,targ.CatalogFlg								 =src.CatalogFlg							
			--,targ.ParcelFlg									 =src.ParcelFlg							
			--,targ.TaxRateFLG								 =src.TaxRateFLG							
			--,targ.CostingKBN								 =src.CostingKBN							
			--,targ.NormalCost								 =src.NormalCost							
			--,targ.SaleExcludedFlg							 =src.SaleExcludedFlg							
			--,targ.PriceWithTax								 =src.PriceWithTax							
			--,targ.PriceOutTax								 =src.PriceOutTax							
			--,targ.OrderPriceWithTax							 =src.OrderPriceWithTax							
			--,targ.OrderPriceWithoutTax						 =src.OrderPriceWithoutTax							
			--,targ.Rate										 =src.Rate							
			--,targ.SaleStartDate								 =src.SaleStartDate							
			--,targ.WebStartDate								 =src.WebStartDate							
			--,targ.OrderAttentionCD							 =src.OrderAttentionCD							
			--,targ.OrderAttentionNote						 =src.OrderAttentionNote							
			--,targ.CommentInStore							 =src.CommentInStore							
			--,targ.CommentOutStore							 =src.CommentOutStore							
			--,targ.LastYearTerm								 =src.LastYearTerm							
			--,targ.LastSeason								 =src.LastSeason							
			--,targ.LastCatalogNO								 =src.LastCatalogNO							
			--,targ.LastCatalogPage							 =src.LastCatalogPage							
			--,targ.LastCatalogText							 =src.LastCatalogText							
			--,targ.LastInstructionsNO						 =src.LastInstructionsNO							
			--,targ.LastInstructionsDate						 =src.LastInstructionsDate							
			--,targ.WebAddress								 =src.WebAddress							
			targ.ApprovalDate								 =src.ApprovalDate							
			,targ.ApprovalDateTime							 =(case when src.ApprovalDate is not null then @Date else null end )	
			,targ.TagName01									 =src.TagName01							
			,targ.TagName02									 =src.TagName02							
			,targ.TagName03									 =src.TagName03							
			,targ.TagName04									 =src.TagName04							
			,targ.TagName05									 =src.TagName05							
			,targ.TagName06									 =src.TagName06							
			,targ.TagName07									 =src.TagName07							
			,targ.TagName08									 =src.TagName08							
			,targ.TagName09									 =src.TagName09							
			,targ.TagName10									 =src.TagName10							
			--,targ.ExhibitionSegmentCD						 =src.ExhibitionSegmentCD							
			--,targ.OrderLot									 =src.OrderLot							
			,targ.DeleteFlg									 =src.DeleteFlg							
			--,targ.UsedFlg									 =src.UsedFlg							
			--,targ.SKSUpdateFlg								 =src.SKSUpdateFlg							
			--,targ.SKSUpdateDateTime							 =src.SKSUpdateDateTime							
			--,targ.InsertOperator							 =src.InsertOperator							
			--,targ.InsertDateTime							 =src.InsertDateTime							
			,targ.UpdateOperator							 =src.UpdateOperator							
			,targ.UpdateDateTime							 =src.UpdateDateTime		
			

			when not matched by target and @Ins = 1 then insert
			(
			ItemCD
			,ChangeDate
			,VariousFLG				
			,ITemName					
			,KanaName					
			,ITEMShortName				
			,EnglishName				
			,SetKBN					
			,PresentKBN				
			,SampleKBN					
			,DiscountKBN				
			,SizeCount					
			,ColorCount				
			,SizeName					
			,ColorName					
			,WebFlg					
			,RealStoreFlg				
			,MainVendorCD				
			,MakerVendorCD				
			,BrandCD					
			,MakerItem					
			,TaniCD					
			,SportsCD					
			,SegmentCD					
			,ZaikoKBN					
			,Rack						
			,VirtualFlg				
			,DirectFlg					
			,ReserveCD					
			,NoticesCD					
			,PostageCD					
			,ManufactCD				
			,ConfirmCD					
			,StopFlg					
			,DiscontinueFlg			
			,SoldOutFlg				
			,WebStockFlg				
			,InventoryAddFlg			
			,MakerAddFlg				
			,StoreAddFlg				
			,NoNetOrderFlg				
			,EDIOrderFlg				
			,AutoOrderFlg				
			,CatalogFlg				
			,ParcelFlg					
			,TaxRateFLG				
			,CostingKBN				
			,NormalCost				
			,SaleExcludedFlg			
			,PriceWithTax				
			,PriceOutTax				
			,OrderPriceWithTax			
			,OrderPriceWithoutTax		
			,Rate						
			,SaleStartDate				
			,WebStartDate				
			,OrderAttentionCD			
			,OrderAttentionNote		
			,CommentInStore			
			,CommentOutStore			
			,LastYearTerm				
			,LastSeason				
			,LastCatalogNO				
			,LastCatalogPage			
			,LastCatalogText			
			,LastInstructionsNO		
			,LastInstructionsDate		
			,WebAddress				
			,ApprovalDate				
			,ApprovalDateTime			
			,TagName01					
			,TagName02					
			,TagName03					
			,TagName04					
			,TagName05					
			,TagName06					
			,TagName07					
			,TagName08					
			,TagName09					
			,TagName10					
			,ExhibitionSegmentCD		
			,OrderLot					
			,DeleteFlg					
			,UsedFlg					
			,SKSUpdateFlg				
			,SKSUpdateDateTime			
			,InsertOperator			
			,InsertDateTime			
			,UpdateOperator			
			,UpdateDateTime			
			)
			values
			(
			ItemCD
			,src.ChangeDate
			,src.VariousFLG				
			,src.ITemName					
			,src.KanaName					
			,src.ITEMShortName				
			,src.EnglishName				
			,src.SetKBN					
			,src.PresentKBN				
			,src.SampleKBN					
			,src.DiscountKBN				
			,src.SizeCount					
			,src.ColorCount				
			,src.SizeName					
			,src.ColorName					
			,src.WebFlg					
			,src.RealStoreFlg				
			,src.MainVendorCD				
			,src.MakerVendorCD				
			,src.BrandCD					
			,src.MakerItem					
			,src.TaniCD					
			,src.SportsCD					
			,src.SegmentCD					
			,src.ZaikoKBN					
			,src.Rack						
			,src.VirtualFlg				
			,src.DirectFlg					
			,src.ReserveCD					
			,src.NoticesCD					
			,src.PostageCD					
			,src.ManufactCD				
			,src.ConfirmCD					
			,src.StopFlg					
			,src.DiscontinueFlg			
			,src.SoldOutFlg				
			,src.WebStockFlg				
			,src.InventoryAddFlg			
			,src.MakerAddFlg				
			,src.StoreAddFlg				
			,src.NoNetOrderFlg				
			,src.EDIOrderFlg				
			,src.AutoOrderFlg				
			,src.CatalogFlg				
			,src.ParcelFlg					
			,src.TaxRateFLG				
			,src.CostingKBN				
			,src.NormalCost				
			,src.SaleExcludedFlg			
			,src.PriceWithTax				
			,src.PriceOutTax				
			,src.OrderPriceWithTax			
			,src.OrderPriceWithoutTax		
			,src.Rate						
			,src.SaleStartDate				
			,src.WebStartDate				
			,src.OrderAttentionCD			
			,src.OrderAttentionNote		
			,src.CommentInStore			
			,src.CommentOutStore			
			,src.LastYearTerm				
			,src.LastSeason				
			,src.LastCatalogNO				
			,src.LastCatalogPage			
			,src.LastCatalogText			
			,src.LastInstructionsNO		
			,src.LastInstructionsDate		
			,src.WebAddress				
			,src.ApprovalDate				
			,src.ApprovalDateTime			
			,src.TagName01					
			,src.TagName02					
			,src.TagName03					
			,src.TagName04					
			,src.TagName05					
			,src.TagName06					
			,src.TagName07					
			,src.TagName08					
			,src.TagName09					
			,src.TagName10					
			,src.ExhibitionSegmentCD		
			,src.OrderLot					
			,src.DeleteFlg					
			,src.UsedFlg					
			,src.SKSUpdateFlg				
			,src.SKSUpdateDateTime			
			,src.InsertOperator			
			,src.InsertDateTime			
			,src.UpdateOperator			
			,src.UpdateDateTime			
			);
    End
    if (@MainFlg =8)
    Begin
        set @Ins =0;
		Merge [M_item] targ using ( select *  from	(select 
			ITemCD							
			,ChangeDate							
			,VariousFLG							
			,ITemName							
			,KanaName							
			,ITEMShortName							
			,EnglishName							
			,SetKBN							
			,PresentKBN							
			,SampleKBN							
			,DiscountKBN							
			,SizeCount							
			,ColorCount							
			,null as SizeName							
			,null as ColorName							
			,WebFlg							
			,RealStoreFlg							
			,MainVendorCD							
			,MainVendorCD as MakerVendorCD							
			,BrandCD							
			,MakerItem							
			,TaniCD							
			,SportsCD							
			,SegmentCD							
			,ZaikoKBN							
			,Rack							
			,VirtualFlg							
			,DirectFlg							
			,ReserveCD							
			,NoticesCD							
			,PostageCD							
			,ManufactCD							
			,ConfirmCD							
			,StopFlg							
			,DiscontinueFlg							
			,SoldOutFlg							
			,WebStockFlg							
			,InventoryAddFlg							
			,MakerAddFlg							
			,StoreAddFlg							
			,NoNetOrderFlg							
			,EDIOrderFlg							
			,AutoOrderFlg							
			,CatalogFlg							
			,ParcelFlg							
			,TaxRateFLG							
			,CostingKBN							
			,NormalCost							
			,SaleExcludedFlg							
			,PriceWithTax							
			,PriceOutTax							
			,OrderPriceWithTax							
			,OrderPriceWithoutTax							
			,Rate							
			,SaleStartDate							
			,WebStartDate							
			,OrderAttentionCD							
			,OrderAttentionNote							
			,CommentInStore							
			,CommentOutStore							
			,LastYearTerm							
			,LastSeason							
			,LastCatalogNO							
			,LastCatalogPage							
			,LastCatalogText							
			,LastInstructionsNO							
			,LastInstructionsDate							
			,WebAddress							
			,ApprovalDate							
			,(case when ApprovalDate is not null then @Date else null end ) as ApprovalDateTime		
			,TagName01							
			,TagName02							
			,TagName03							
			,TagName04							
			,TagName05							
			,TagName06							
			,TagName07							
			,TagName08							
			,TagName09							
			,TagName10							
			,ExhibitionSegmentCD							
			,OrderLot							
			,DeleteFlg							
			,0 as UsedFlg							
			,1 as SKSUpdateFlg							
			,null as SKSUpdateDateTime							
			,@Opt as InsertOperator							
			,@Date as InsertDateTime							
			,@Opt as UpdateOperator							
			,@Date as UpdateDateTime							
				
			from @ItemTable ) a ) src  	on targ.ItemCD = src.ItemCD and targ.ChangeDate = src.ChangeDate
			when matched  and @Upt =1 then
			Update set
			-- targ.VariousFLG									 =src.VariousFLG							
			--,targ.ITemName									 =src.ITemName							
			--,targ.KanaName									 =src.KanaName							
			--,targ.ITEMShortName								 =src.ITEMShortName							
			--,targ.EnglishName								 =src.EnglishName							
			--,targ.SetKBN									 =src.SetKBN							
			--,targ.PresentKBN								 =src.PresentKBN							
			--,targ.SampleKBN									 =src.SampleKBN							
			--,targ.DiscountKBN								 =src.DiscountKBN							
			--,targ.SizeCount									 =src.SizeCount							
			--,targ.ColorCount								 =src.ColorCount							
			--,targ.SizeName									 =src.SizeName							
			--,targ.ColorName									 =src.ColorName							
			--,targ.WebFlg									 =src.WebFlg							
			--,targ.RealStoreFlg								 =src.RealStoreFlg							
			--,targ.MainVendorCD								 =src.MainVendorCD							
			--,targ.MakerVendorCD								 =src.MakerVendorCD						
			--,targ.BrandCD									 =src.BrandCD							
			--,targ.MakerItem									 =src.MakerItem							
			--,targ.TaniCD									 =src.TaniCD							
			--,targ.SportsCD									 =src.SportsCD							
			--,targ.SegmentCD									 =src.SegmentCD							
			--,targ.ZaikoKBN									 =src.ZaikoKBN							
			--,targ.Rack										 =src.Rack							
			--,targ.VirtualFlg								 =src.VirtualFlg							
			--,targ.DirectFlg									 =src.DirectFlg							
			--,targ.ReserveCD									 =src.ReserveCD							
			--,targ.NoticesCD									 =src.NoticesCD							
			--,targ.PostageCD									 =src.PostageCD							
			--,targ.ManufactCD								 =src.ManufactCD							
			--,targ.ConfirmCD									 =src.ConfirmCD							
			--,targ.StopFlg									 =src.StopFlg							
			--,targ.DiscontinueFlg							 =src.DiscontinueFlg							
			--,targ.SoldOutFlg								 =src.SoldOutFlg							
			--,targ.WebStockFlg								 =src.WebStockFlg							
			--,targ.InventoryAddFlg							 =src.InventoryAddFlg							
			--,targ.MakerAddFlg								 =src.MakerAddFlg							
			--,targ.StoreAddFlg								 =src.StoreAddFlg							
			--,targ.NoNetOrderFlg								 =src.NoNetOrderFlg							
			--,targ.EDIOrderFlg								 =src.EDIOrderFlg							
			--,targ.AutoOrderFlg								 =src.AutoOrderFlg							
			--,targ.CatalogFlg								 =src.CatalogFlg							
			--,targ.ParcelFlg									 =src.ParcelFlg							
			--,targ.TaxRateFLG								 =src.TaxRateFLG							
			--,targ.CostingKBN								 =src.CostingKBN							
			--,targ.NormalCost								 =src.NormalCost							
			--,targ.SaleExcludedFlg							 =src.SaleExcludedFlg							
			--,targ.PriceWithTax								 =src.PriceWithTax							
			--,targ.PriceOutTax								 =src.PriceOutTax							
			--,targ.OrderPriceWithTax							 =src.OrderPriceWithTax							
			--,targ.OrderPriceWithoutTax						 =src.OrderPriceWithoutTax							
			--,targ.Rate										 =src.Rate							
			--,targ.SaleStartDate								 =src.SaleStartDate							
			--,targ.WebStartDate								 =src.WebStartDate							
			--,targ.OrderAttentionCD							 =src.OrderAttentionCD							
			--,targ.OrderAttentionNote						 =src.OrderAttentionNote							
			--,targ.CommentInStore							 =src.CommentInStore							
			--,targ.CommentOutStore							 =src.CommentOutStore							
			--,targ.LastYearTerm								 =src.LastYearTerm							
			--,targ.LastSeason								 =src.LastSeason							
			--,targ.LastCatalogNO								 =src.LastCatalogNO							
			--,targ.LastCatalogPage							 =src.LastCatalogPage							
			--,targ.LastCatalogText							 =src.LastCatalogText							
			--,targ.LastInstructionsNO						 =src.LastInstructionsNO							
			--,targ.LastInstructionsDate						 =src.LastInstructionsDate							
			--,targ.WebAddress								 =src.WebAddress							
			targ.ApprovalDate								 =src.ApprovalDate							
			,targ.ApprovalDateTime							 =(case when src.ApprovalDate is not null then @Date else null end )	
			--,targ.TagName01									 =src.TagName01							
			--,targ.TagName02									 =src.TagName02							
			--,targ.TagName03									 =src.TagName03							
			--,targ.TagName04									 =src.TagName04							
			--,targ.TagName05									 =src.TagName05							
			--,targ.TagName06									 =src.TagName06							
			--,targ.TagName07									 =src.TagName07							
			--,targ.TagName08									 =src.TagName08							
			--,targ.TagName09									 =src.TagName09							
			--,targ.TagName10									 =src.TagName10							
			--,targ.ExhibitionSegmentCD						 =src.ExhibitionSegmentCD							
			--,targ.OrderLot									 =src.OrderLot							
			,targ.DeleteFlg									 =src.DeleteFlg							
			--,targ.UsedFlg									 =src.UsedFlg							
			--,targ.SKSUpdateFlg								 =src.SKSUpdateFlg							
			--,targ.SKSUpdateDateTime							 =src.SKSUpdateDateTime							
			--,targ.InsertOperator							 =src.InsertOperator							
			--,targ.InsertDateTime							 =src.InsertDateTime							
			,targ.UpdateOperator							 =src.UpdateOperator							
			,targ.UpdateDateTime							 =src.UpdateDateTime		
			

			when not matched by target and @Ins = 1 then insert
			(
			ItemCD
			,ChangeDate
			,VariousFLG				
			,ITemName					
			,KanaName					
			,ITEMShortName				
			,EnglishName				
			,SetKBN					
			,PresentKBN				
			,SampleKBN					
			,DiscountKBN				
			,SizeCount					
			,ColorCount				
			,SizeName					
			,ColorName					
			,WebFlg					
			,RealStoreFlg				
			,MainVendorCD				
			,MakerVendorCD				
			,BrandCD					
			,MakerItem					
			,TaniCD					
			,SportsCD					
			,SegmentCD					
			,ZaikoKBN					
			,Rack						
			,VirtualFlg				
			,DirectFlg					
			,ReserveCD					
			,NoticesCD					
			,PostageCD					
			,ManufactCD				
			,ConfirmCD					
			,StopFlg					
			,DiscontinueFlg			
			,SoldOutFlg				
			,WebStockFlg				
			,InventoryAddFlg			
			,MakerAddFlg				
			,StoreAddFlg				
			,NoNetOrderFlg				
			,EDIOrderFlg				
			,AutoOrderFlg				
			,CatalogFlg				
			,ParcelFlg					
			,TaxRateFLG				
			,CostingKBN				
			,NormalCost				
			,SaleExcludedFlg			
			,PriceWithTax				
			,PriceOutTax				
			,OrderPriceWithTax			
			,OrderPriceWithoutTax		
			,Rate						
			,SaleStartDate				
			,WebStartDate				
			,OrderAttentionCD			
			,OrderAttentionNote		
			,CommentInStore			
			,CommentOutStore			
			,LastYearTerm				
			,LastSeason				
			,LastCatalogNO				
			,LastCatalogPage			
			,LastCatalogText			
			,LastInstructionsNO		
			,LastInstructionsDate		
			,WebAddress				
			,ApprovalDate				
			,ApprovalDateTime			
			,TagName01					
			,TagName02					
			,TagName03					
			,TagName04					
			,TagName05					
			,TagName06					
			,TagName07					
			,TagName08					
			,TagName09					
			,TagName10					
			,ExhibitionSegmentCD		
			,OrderLot					
			,DeleteFlg					
			,UsedFlg					
			,SKSUpdateFlg				
			,SKSUpdateDateTime			
			,InsertOperator			
			,InsertDateTime			
			,UpdateOperator			
			,UpdateDateTime			
			)
			values
			(
			ItemCD
			,src.ChangeDate
			,src.VariousFLG				
			,src.ITemName					
			,src.KanaName					
			,src.ITEMShortName				
			,src.EnglishName				
			,src.SetKBN					
			,src.PresentKBN				
			,src.SampleKBN					
			,src.DiscountKBN				
			,src.SizeCount					
			,src.ColorCount				
			,src.SizeName					
			,src.ColorName					
			,src.WebFlg					
			,src.RealStoreFlg				
			,src.MainVendorCD				
			,src.MakerVendorCD				
			,src.BrandCD					
			,src.MakerItem					
			,src.TaniCD					
			,src.SportsCD					
			,src.SegmentCD					
			,src.ZaikoKBN					
			,src.Rack						
			,src.VirtualFlg				
			,src.DirectFlg					
			,src.ReserveCD					
			,src.NoticesCD					
			,src.PostageCD					
			,src.ManufactCD				
			,src.ConfirmCD					
			,src.StopFlg					
			,src.DiscontinueFlg			
			,src.SoldOutFlg				
			,src.WebStockFlg				
			,src.InventoryAddFlg			
			,src.MakerAddFlg				
			,src.StoreAddFlg				
			,src.NoNetOrderFlg				
			,src.EDIOrderFlg				
			,src.AutoOrderFlg				
			,src.CatalogFlg				
			,src.ParcelFlg					
			,src.TaxRateFLG				
			,src.CostingKBN				
			,src.NormalCost				
			,src.SaleExcludedFlg			
			,src.PriceWithTax				
			,src.PriceOutTax				
			,src.OrderPriceWithTax			
			,src.OrderPriceWithoutTax		
			,src.Rate						
			,src.SaleStartDate				
			,src.WebStartDate				
			,src.OrderAttentionCD			
			,src.OrderAttentionNote		
			,src.CommentInStore			
			,src.CommentOutStore			
			,src.LastYearTerm				
			,src.LastSeason				
			,src.LastCatalogNO				
			,src.LastCatalogPage			
			,src.LastCatalogText			
			,src.LastInstructionsNO		
			,src.LastInstructionsDate		
			,src.WebAddress				
			,src.ApprovalDate				
			,src.ApprovalDateTime			
			,src.TagName01					
			,src.TagName02					
			,src.TagName03					
			,src.TagName04					
			,src.TagName05					
			,src.TagName06					
			,src.TagName07					
			,src.TagName08					
			,src.TagName09					
			,src.TagName10					
			,src.ExhibitionSegmentCD		
			,src.OrderLot					
			,src.DeleteFlg					
			,src.UsedFlg					
			,src.SKSUpdateFlg				
			,src.SKSUpdateDateTime			
			,src.InsertOperator			
			,src.InsertDateTime			
			,src.UpdateOperator			
			,src.UpdateDateTime			
			);

    End
END

