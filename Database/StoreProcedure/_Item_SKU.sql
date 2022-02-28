 BEGIN TRY 
 Drop Procedure dbo.[_Item_SKU]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[_Item_SKU]
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
    declare
    @Upt int = 1,
    @Ins int = 1,
    @Counter int,
    @SizeCount int,
    @ColorCount int,
    @ITemCD varchar(50),
    @ChangeDate date,
    @AdminNoMin int = 0,
    @AdminNoMax int = 0


    if @MainFlg =1 or @MainFlg =2
    Begin

        update msku set
             msku.VariousFLG                = tbl.VariousFLG
            ,msku.SKUName                   = tbl.ITemName            
            ,msku.SKUNameLong               = tbl.ITemName        
            ,msku.KanaName                  = tbl.KanaName            
            ,msku.SKUShortName              = tbl.ITEMShortName        
            ,msku.EnglishName               = tbl.EnglishName        
            --,msku.ITemCD
            --,msku.SizeNO
            --,msku.ColorNO
            --,msku.JanCD
            ,msku.SetKBN                    = tbl.SetKBN                
            ,msku.PresentKBN                = tbl.PresentKBN            
            ,msku.SampleKBN                 = tbl.SampleKBN            
            ,msku.DiscountKBN               = tbl.DiscountKBN        
            --,msku.SizeName
            --,msku.ColorName
            --,msku.SizeNameLong
            --,msku.ColorNameLong 
            ,msku.WebFlg                    = tbl.WebFlg                
            ,msku.RealStoreFlg              = tbl.RealStoreFlg        
            ,msku.MainVendorCD              = tbl.MainVendorCD        
            ,msku.MakerVendorCD             = tbl.MainVendorCD        
            ,msku.BrandCD                   = tbl.BrandCD            
            ,msku.MakerItem                 = tbl.MakerItem            
            ,msku.TaniCD                    = tbl.TaniCD                
            ,msku.SportsCD                  = tbl.SportsCD            
            ,msku.SegmentCD                 = tbl.SegmentCD            
            ,msku.ZaikoKBN                  = tbl.ZaikoKBN            
            ,msku.Rack                      = tbl.Rack                
            ,msku.VirtualFlg                = tbl.VirtualFlg            
            ,msku.DirectFlg                 = tbl.DirectFlg            
            ,msku.ReserveCD                 = tbl.ReserveCD            
            ,msku.NoticesCD                 = tbl.NoticesCD            
            ,msku.PostageCD                 = tbl.PostageCD            
            ,msku.ManufactCD                = tbl.ManufactCD            
            ,msku.ConfirmCD                 = tbl.ConfirmCD            
            ,msku.WebStockFlg               = tbl.WebStockFlg        
            ,msku.StopFlg                   = tbl.StopFlg            
            ,msku.DiscontinueFlg            = tbl.DiscontinueFlg        
            ,msku.SoldOutFlg                = tbl.SoldOutFlg            
            ,msku.InventoryAddFlg           = tbl.InventoryAddFlg    
            ,msku.MakerAddFlg               = tbl.MakerAddFlg        
            ,msku.StoreAddFlg               = tbl.StoreAddFlg        
            ,msku.NoNetOrderFlg             = tbl.NoNetOrderFlg        
            ,msku.EDIOrderFlg               = tbl.EDIOrderFlg        
            ,msku.AutoOrderFlg              = tbl.AutoOrderFlg        
            ,msku.CatalogFlg                = tbl.CatalogFlg            
            ,msku.ParcelFlg                 = tbl.ParcelFlg            
            ,msku.TaxRateFLG                = tbl.TaxRateFLG            
            ,msku.CostingKBN                = tbl.CostingKBN            
            ,msku.NormalCost                = tbl.NormalCost            
            ,msku.SaleExcludedFlg           = tbl.SaleExcludedFlg    
            ,msku.PriceWithTax              = tbl.PriceWithTax        
            ,msku.PriceOutTax               = tbl.PriceOutTax        
            ,msku.OrderPriceWithTax         = tbl.OrderPriceWithTax    
            ,msku.OrderPriceWithoutTax      = tbl.OrderPriceWithoutTax
            ,msku.Rate                      = tbl.Rate                
            ,msku.SaleStartDate             = tbl.SaleStartDate        
            ,msku.WebStartDate              = tbl.WebStartDate        
            ,msku.OrderAttentionCD          = tbl.OrderAttentionCD    
            ,msku.OrderAttentionNote        = tbl.OrderAttentionNote    
            ,msku.CommentInStore            = tbl.CommentInStore        
            ,msku.CommentOutStore           = tbl.CommentOutStore    
            ,msku.LastYearTerm              = tbl.LastYearTerm        
            ,msku.LastSeason                = tbl.LastSeason            
            ,msku.LastCatalogNO             = tbl.LastCatalogNO        
            ,msku.LastCatalogPage           = tbl.LastCatalogPage    
            --,msku.LastCatalogNOLong
            --,msku.LastCatalogPageLong
            ,msku.LastCatalogText           = tbl.LastCatalogText    
            ,msku.LastInstructionsNO        = tbl.LastInstructionsNO    
            ,msku.LastInstructionsDate      = tbl.LastInstructionsDate
            ,msku.WebAddress                = tbl.WebAddress            
            --,msku.SetAdminCD
            --,msku.SetITemCD
            --,msku.SetSKUCD
            --,msku.SetSU
            ,msku.ExhibitionSegmentCD       = tbl.ExhibitionSegmentCD
            ,msku.OrderLot                  = tbl.OrderLot            
            --,msku.ExhibitionCommonCD
            ,msku.ApprovalDate              = tbl.ApprovalDate        
            ,msku.DeleteFlg                 = tbl.DeleteFlg            
            --,msku.UsedFlg
            ,msku.SKSUpdateFlg              = 1        
            ,msku.SKSUpdateDateTime         = null
            --,msku.InsertOperator
            --,msku.InsertDateTime
            ,msku.UpdateOperator            = @Opt        
            ,msku.UpdateDateTime            = @Date        

        from M_SKU msku
        inner join @ItemTable tbl on msku.ITemCD = tbl.ITemCD and msku.ChangeDate = tbl.ChangeDate


        --In the case of M_ITEM revision, the value is copied from the most recent M_ITEM.
        insert into M_SKU
        (
             AdminNO
            ,ChangeDate
            ,SKUCD
            ,VariousFLG
            ,SKUName
            ,SKUNameLong
            ,KanaName
            ,SKUShortName
            ,EnglishName
            ,ITemCD
            ,SizeNO
            ,ColorNO
            ,JanCD
            ,SetKBN
            ,PresentKBN
            ,SampleKBN
            ,DiscountKBN
            ,SizeName
            ,ColorName
            ,SizeNameLong
            ,ColorNameLong
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
            ,WebStockFlg
            ,StopFlg
            ,DiscontinueFlg
            ,SoldOutFlg
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
            ,LastCatalogNOLong
            ,LastCatalogPageLong
            ,LastCatalogText
            ,LastInstructionsNO
            ,LastInstructionsDate
            ,WebAddress
            ,SetAdminCD
            ,SetItemCD
            ,SetSKUCD
            ,SetSU
            ,ExhibitionSegmentCD
            ,OrderLot
            ,ExhibitionCommonCD
            ,ApprovalDate
            ,DeleteFlg
            ,UsedFlg
            ,SKSUpdateFlg
            ,SKSUpdateDateTime
            ,InsertOperator
            ,InsertDateTime
            ,UpdateOperator
            ,UpdateDateTime
        )
        select
             sku.AdminNO
            ,tbl.ChangeDate
            ,sku.SKUCD
            ,tbl.VariousFLG
            ,tbl.ITemName
            ,tbl.ITemName
            ,tbl.KanaName
            ,tbl.ITEMShortName
            ,tbl.EnglishName
            ,tbl.ITemCD
            ,sku.SizeNO
            ,sku.ColorNO
            ,sku.JanCD
            ,tbl.SetKBN
            ,tbl.PresentKBN
            ,tbl.SampleKBN
            ,tbl.DiscountKBN
            ,sku.SizeName
            ,sku.ColorName
            ,sku.SizeNameLong
            ,sku.ColorNameLong
            ,tbl.WebFlg
            ,tbl.RealStoreFlg
            ,tbl.MainVendorCD
            ,tbl.MainVendorCD
            ,tbl.BrandCD
            ,tbl.MakerItem
            ,tbl.TaniCD
            ,tbl.SportsCD
            ,tbl.SegmentCD
            ,tbl.ZaikoKBN
            ,tbl.Rack
            ,tbl.VirtualFlg
            ,tbl.DirectFlg
            ,tbl.ReserveCD
            ,tbl.NoticesCD
            ,tbl.PostageCD
            ,tbl.ManufactCD
            ,tbl.ConfirmCD
            ,tbl.WebStockFlg
            ,tbl.StopFlg
            ,tbl.DiscontinueFlg
            ,tbl.SoldOutFlg
            ,tbl.InventoryAddFlg
            ,tbl.MakerAddFlg
            ,tbl.StoreAddFlg
            ,tbl.NoNetOrderFlg
            ,tbl.EDIOrderFlg
            ,tbl.AutoOrderFlg
            ,tbl.CatalogFlg
            ,tbl.ParcelFlg
            ,tbl.TaxRateFLG
            ,tbl.CostingKBN
            ,tbl.NormalCost
            ,tbl.SaleExcludedFlg
            ,tbl.PriceWithTax
            ,tbl.PriceOutTax
            ,tbl.OrderPriceWithTax
            ,tbl.OrderPriceWithoutTax
            ,tbl.Rate
            ,tbl.SaleStartDate
            ,tbl.WebStartDate
            ,tbl.OrderAttentionCD
            ,tbl.OrderAttentionNote
            ,tbl.CommentInStore
            ,tbl.CommentOutStore
            ,tbl.LastYearTerm
            ,tbl.LastSeason
            ,tbl.LastCatalogNO
            ,tbl.LastCatalogPage
            ,sku.LastCatalogNOLong
            ,sku.LastCatalogPageLong
            ,tbl.LastCatalogText
            ,tbl.LastInstructionsNO
            ,tbl.LastInstructionsDate
            ,tbl.WebAddress
            ,sku.SetAdminCD
            ,sku.SetItemCD
            ,sku.SetSKUCD
            ,sku.SetSU
            ,tbl.ExhibitionSegmentCD
            ,tbl.OrderLot
            ,sku.ExhibitionCommonCD
            ,tbl.ApprovalDate
            ,tbl.DeleteFlg
            ,0 as UsedFlg
            ,1 as SKSUpdateFlg
            ,null as SKSUpdateDateTime
            ,@Opt
            ,@Date
            ,@Opt
            ,@Date
        from @ItemTable tbl
        inner join M_SKU sku on sku.ITemCD = tbl.ITemCD and sku.ChangeDate = tbl.MostRecentChangeDate
        where not exists(select * from M_SKU ms where ms.ITemCD = tbl.ITemCD and ms.ChangeDate = tbl.ChangeDate)
        and tbl.RevisionFlg = 1;



        --For new ITEM
        Create table dbo.#tempSKU(
             SEQ                int identity
            ,ITemCD             varchar(200)                    
            ,ChangeDate         date                
            ,SKUCD              varchar(100)    
            ,SizeNO             int
            ,ColorNO            int
            ,AdminNO            int                        
            )

        --For expansion
        Create table dbo.#CountSetting (EmpRows int);                                
        SET @Counter = 0
        WHILE (@Counter <= 50)
        BEGIN
            SET @Counter  = @Counter  + 1
            insert into #CountSetting(Emprows) values (@Counter)
        END

        --Expand the color and size records.
        DECLARE CUR_NEW CURSOR FAST_FORWARD FOR
            SELECT ITemCD, ChangeDate, SizeCount, ColorCount
            FROM @ItemTable tbl
            WHERE NOT EXISTS (SELECT * FROM M_SKU sku WHERE sku.ITemCD = tbl.ITemCD AND sku.ChangeDate = tbl.ChangeDate)
            AND RevisionFlg = 0
            ORDER BY ITemCD, ChangeDate;
                                 
        OPEN CUR_NEW
        FETCH NEXT FROM CUR_NEW INTO @ITemCD, @ChangeDate, @SizeCount, @ColorCount

        WHILE @@FETCH_STATUS = 0
        BEGIN
            insert into #tempSKU( ITemCD, ChangeDate, SKUCD, SizeNO, ColorNO )
            select 
                @ITemCD,
                @ChangeDate,
                @ITemCD + right('0000' + Cast (SizeNO as varchar), 4) + right('0000' + Cast (ColorNO as varchar), 4) as SKUCD,
                SizeNO,
                ColorNO
            from
                (select EmpRows as SizeNO from #CountSetting where EmpRows <= @SizeCount) a
            cross join 
                (select EmpRows as ColorNO from #CountSetting where EmpRows <= @ColorCount) b
            order by SizeNO, ColorNO

            FETCH NEXT FROM CUR_NEW INTO @ITemCD, @ChangeDate, @SizeCount, @ColorCount
        END
        CLOSE CUR_NEW
        DEALLOCATE CUR_NEW

        --Numbering the AdminNO
        IF EXISTS(select * from #tempSKU)
        BEGIN
            update M_SKUCounter set 
                @AdminNoMin = AdminNO,
                @AdminNoMax = AdminNO = AdminNO + (select count(*) from #tempSKU)
            where MainKEY = 1
            
            update #tempSKU set AdminNO = @AdminNoMin + SEQ

            --just to be sure
            IF EXISTS(select * from #tempSKU where AdminNO > @AdminNoMax)
            BEGIN
                update M_SKUCounter set AdminNO = (select max(AdminNO) from #tempSKU) where MainKEY = 1
            END
        END

        --Insert New SKU
        insert into M_SKU
        (
             AdminNO
            ,ChangeDate
            ,SKUCD
            ,VariousFLG
            ,SKUName
            ,SKUNameLong
            ,KanaName
            ,SKUShortName
            ,EnglishName
            ,ITemCD
            ,SizeNO
            ,ColorNO
            ,JanCD
            ,SetKBN
            ,PresentKBN
            ,SampleKBN
            ,DiscountKBN
            ,SizeName
            ,ColorName
            ,SizeNameLong
            ,ColorNameLong
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
            ,WebStockFlg
            ,StopFlg
            ,DiscontinueFlg
            ,SoldOutFlg
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
            ,LastCatalogNOLong
            ,LastCatalogPageLong
            ,LastCatalogText
            ,LastInstructionsNO
            ,LastInstructionsDate
            ,WebAddress
            ,SetAdminCD
            ,SetItemCD
            ,SetSKUCD
            ,SetSU
            ,ExhibitionSegmentCD
            ,OrderLot
            ,ExhibitionCommonCD
            ,ApprovalDate
            ,DeleteFlg
            ,UsedFlg
            ,SKSUpdateFlg
            ,SKSUpdateDateTime
            ,InsertOperator
            ,InsertDateTime
            ,UpdateOperator
            ,UpdateDateTime
        )
        select
             tblSKU.AdminNO
            ,tbl.ChangeDate
            ,tblSKU.SKUCD
            ,tbl.VariousFLG
            ,tbl.ITemName
            ,tbl.ITemName
            ,tbl.KanaName
            ,tbl.ITEMShortName
            ,tbl.EnglishName
            ,tbl.ITemCD
            ,tblSKU.SizeNO
            ,tblSKU.ColorNO
            ,null as JanCD
            ,tbl.SetKBN
            ,tbl.PresentKBN
            ,tbl.SampleKBN
            ,tbl.DiscountKBN
            ,null as SizeName
            ,null as ColorName
            ,null as SizeNameLong
            ,null as ColorNameLong
            ,tbl.WebFlg
            ,tbl.RealStoreFlg
            ,tbl.MainVendorCD
            ,tbl.MainVendorCD
            ,tbl.BrandCD
            ,tbl.MakerItem
            ,tbl.TaniCD
            ,tbl.SportsCD
            ,tbl.SegmentCD
            ,tbl.ZaikoKBN
            ,tbl.Rack
            ,tbl.VirtualFlg
            ,tbl.DirectFlg
            ,tbl.ReserveCD
            ,tbl.NoticesCD
            ,tbl.PostageCD
            ,tbl.ManufactCD
            ,tbl.ConfirmCD
            ,tbl.WebStockFlg
            ,tbl.StopFlg
            ,tbl.DiscontinueFlg
            ,tbl.SoldOutFlg
            ,tbl.InventoryAddFlg
            ,tbl.MakerAddFlg
            ,tbl.StoreAddFlg
            ,tbl.NoNetOrderFlg
            ,tbl.EDIOrderFlg
            ,tbl.AutoOrderFlg
            ,tbl.CatalogFlg
            ,tbl.ParcelFlg
            ,tbl.TaxRateFLG
            ,tbl.CostingKBN
            ,tbl.NormalCost
            ,tbl.SaleExcludedFlg
            ,tbl.PriceWithTax
            ,tbl.PriceOutTax
            ,tbl.OrderPriceWithTax
            ,tbl.OrderPriceWithoutTax
            ,tbl.Rate
            ,tbl.SaleStartDate
            ,tbl.WebStartDate
            ,tbl.OrderAttentionCD
            ,tbl.OrderAttentionNote
            ,tbl.CommentInStore
            ,tbl.CommentOutStore
            ,tbl.LastYearTerm
            ,tbl.LastSeason
            ,tbl.LastCatalogNO
            ,tbl.LastCatalogPage
            ,null as LastCatalogNOLong
            ,null as LastCatalogPageLong
            ,tbl.LastCatalogText
            ,tbl.LastInstructionsNO
            ,tbl.LastInstructionsDate
            ,tbl.WebAddress
            ,'0' as SetAdminCD
            ,null as SetItemCD
            ,null as SetSKUCD
            ,0 as SetSU
            ,tbl.ExhibitionSegmentCD
            ,tbl.OrderLot
            ,null as ExhibitionCommonCD
            ,tbl.ApprovalDate
            ,tbl.DeleteFlg
            ,0 as UsedFlg
            ,1 as SKSUpdateFlg
            ,null as SKSUpdateDateTime
            ,@Opt
            ,@Date
            ,@Opt
            ,@Date
        from @ItemTable tbl
        inner join #tempSKU tblSKU on tblSKU.ITemCD = tbl.ITemCD and tblSKU.ChangeDate = tbl.ChangeDate
        where not exists(select * from M_SKU ms where ms.ITemCD = tbl.ITemCD and ms.ChangeDate = tbl.ChangeDate)
            
        drop table #tempSKU            
        drop table #CountSetting        
    End

    /*************************************************/
    IF @MainFlg = 5
	BEGIN

	--
	    UPDATE msku set
             msku.LastYearTerm              = CASE tmp.LastYearTerm WHEN msku.LastYearTerm THEN tbl.LastYearTerm
			                                                                               ELSE msku.LastYearTerm
											  END
            ,msku.LastSeason                = CASE tmp.LastSeason WHEN msku.LastSeason THEN tbl.LastSeason
			                                                                           ELSE msku.LastSeason
											  END           
            ,msku.LastCatalogNO             = CASE tmp.LastCatalogNO WHEN msku.LastCatalogNO THEN CASE WHEN tbl.LastCatalogNO = '' THEN NULL ELSE tbl.LastCatalogNO END
			                                                                                 ELSE msku.LastCatalogNO
							                  END      
            ,msku.LastCatalogPage           = CASE tmp.LastCatalogPage WHEN msku.LastCatalogPage THEN CASE WHEN tbl.LastCatalogPage = '' THEN NULL ELSE tbl.LastCatalogPage END
			                                                                                     ELSE msku.LastCatalogPage
											  END  
            ,msku.LastCatalogText           = CASE tmp.LastCatalogText WHEN msku.LastCatalogText THEN CASE WHEN tbl.LastCatalogText = '' THEN NULL ELSE tbl.LastCatalogText END
			                                                                                     ELSE msku.LastCatalogText
											  END  
            ,msku.LastInstructionsNO        = CASE tmp.LastInstructionsNO WHEN msku.LastInstructionsNO THEN CASE WHEN tbl.LastInstructionsNO = '' THEN NULL ELSE tbl.LastInstructionsNO END
			                                                                                           ELSE msku.LastInstructionsNO
											  END  
            ,msku.LastInstructionsDate      = CASE tmp.LastInstructionsDate WHEN msku.LastInstructionsDate THEN tbl.LastInstructionsDate
			                                                                                               ELSE msku.LastInstructionsDate
											  END
            ,msku.UpdateOperator            = @Opt        
            ,msku.UpdateDateTime            = @Date        

        FROM M_SKU msku
        INNER JOIN  @ItemTable tbl ON msku.ITemCD = tbl.ITemCD AND msku.ChangeDate = tbl.ChangeDate
		INNER JOIN ##tmpCatalog tmp ON tmp.ItemCD = msku.ITemCD AND tmp.ChangeDate = msku.ChangeDate

	END

END
