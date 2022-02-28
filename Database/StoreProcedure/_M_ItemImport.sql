 BEGIN TRY 
 Drop Procedure dbo.[_M_ItemImport]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[_M_ItemImport]
    -- Add the parameters for the stored procedure here

    @xml as xml 
    ,@Opt as varchar(20)
    ,@PG as varchar(100)
    ,@PC  as varchar(20)
    ,@Mode as varchar(20)
    ,@KeyItem as varchar(200)
    ,@MainFlg as tinyint

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    DECLARE @Date as Datetime =SysDateTime() ;
    DECLARE @DocHandle int
    DECLARE @ItemTable AS T_ItemImport


    exec sp_xml_preparedocument @DocHandle output, @xml
    insert into @ItemTable
    select *, 0 as RevisionFlg, null as MostRecentChangeDate FROM OPENXML (@DocHandle, '/NewDataSet/test',2) with
    (
         ITEMCD    varchar(100)   
        ,改定日    varchar(100)
        ,承認日    varchar(100)
        ,削除    varchar(100)
        ,諸口区分    varchar(100)
        ,商品名    varchar(100)
        ,カナ名    varchar(100)
        ,略名    varchar(100)
        ,英語名    varchar(100)
        ,主要仕入先CD    varchar(100)
        ,主要仕入先名    varchar(100)
        ,ブランドCD    varchar(100)
        ,ブランド名    varchar(100)
        ,メーカー商品CD    varchar(100)
        ,展開サイズ数    varchar(100)
        ,展開カラー数    varchar(100)
        ,単位CD    varchar(100)
        ,単位名    varchar(100)
        ,競技CD    varchar(100)
        ,競技名    varchar(100)
        ,商品分類CD    varchar(100)
        ,分類名    varchar(100)
        ,セグメントCD    varchar(100)
        ,セグメント名    varchar(100)
        ,セット品区分    varchar(100)
        ,セット品区分名    varchar(100)
        ,プレゼント品区分    varchar(100)
        ,プレゼント品区分名    varchar(100)
        ,サンプル品区分    varchar(100)
        ,サンプル品区分名    varchar(100)
        ,値引商品区分    varchar(100)
        ,値引商品区分名    varchar(100)
        ,Webストア取扱区分    varchar(100)
        ,Webストア取扱区分名    varchar(100)
        ,実店舗取扱区分    varchar(100)
        ,実店舗取扱区分名    varchar(100)
        ,在庫管理対象区分    varchar(100)
        ,在庫管理対象区分名    varchar(100)
        ,架空商品区分    varchar(100)
        ,架空商品区分名    varchar(100)
        ,直送品区分    varchar(100)
        ,直送品区分名    varchar(100)
        ,予約品区分    varchar(100)
        ,予約品区分名    varchar(100)
        ,特記区分    varchar(100)
        ,特記区分名    varchar(100)
        ,送料区分    varchar(100)
        ,送料区分名    varchar(100)
        ,要加工品区分    varchar(100)
        ,要加工品区分名    varchar(100)
        ,要確認品区分    varchar(100)
        ,要確認品区分名    varchar(100)
        ,Web在庫連携区分    varchar(100)
        ,Web在庫連携区分名    varchar(100)
        ,販売停止品区分    varchar(100)
        ,販売停止品区分名    varchar(100)
        ,廃番品区分    varchar(100)
        ,廃番品区分名    varchar(100)
        ,完売品区分    varchar(100)
        ,完売品区分名    varchar(100)
        ,自社在庫連携対象    varchar(100)
        ,自社在庫連携対象名    varchar(100)
        ,メーカー在庫連携対象    varchar(100)
        ,メーカー在庫連携対象名    varchar(100)
        ,店舗在庫連携対象    varchar(100)
        ,店舗在庫連携対象名    varchar(100)
        ,Net発注不可区分    varchar(100)
        ,Net発注不可区分名    varchar(100)
        ,EDI発注可能区分    varchar(100)
        ,EDI発注可能区分名    varchar(100)
        ,自動発注対象区分    varchar(100)
        ,自動発注対象名    varchar(100)
        ,カタログ掲載有無    varchar(100)
        ,カタログ掲載有無名    varchar(100)
        ,小包梱包可能区分    varchar(100)
        ,小包梱包可能名    varchar(100)
        ,税率区分    varchar(100)
        ,税率区分名    varchar(100)
        ,原価計算方法    varchar(100)
        ,原価計算方法名    varchar(100)
        ,Sale対象外区分    varchar(100)
        ,Sale対象外区分名    varchar(100)
        ,標準原価    varchar(100)
        ,税込定価    varchar(100)
        ,税抜定価    varchar(100)
        ,発注税込価格    varchar(100)
        ,発注税抜価格    varchar(100)
        ,掛率    varchar(100)
        ,発売開始日    varchar(100)
        ,Web掲載開始日    varchar(100)
        ,発注注意区分    varchar(100)
        ,発注注意区分名    varchar(100)
        ,発注注意事項    varchar(100)
        ,管理用備考   varchar(200)
        ,表示用備考   varchar(200)
        ,棚番    varchar(100)
        ,年度    varchar(100)
        ,シーズン    varchar(100)
        ,カタログ番号    varchar(100)
        ,カタログページ    varchar(100)
        ,カタログ情報    varchar(1000)
        ,指示書番号    varchar(500)
        ,指示書発行日    varchar(100)
        ,商品情報アドレス varchar(200)
        ,発注ロット    varchar(100)
        ,ITEMタグ1    varchar(100)
        ,ITEMタグ2    varchar(100)
        ,ITEMタグ3    varchar(100)
        ,ITEMタグ4    varchar(100)
        ,ITEMタグ5    varchar(100)
        ,ITEMタグ6    varchar(100)
        ,ITEMタグ7    varchar(100)
        ,ITEMタグ8    varchar(100)
        ,ITEMタグ9    varchar(100)
        ,ITEMタグ10    varchar(100)
    )
    exec sp_xml_removedocument @DocHandle;

    --Remove duplicate data
    WITH cte AS (SELECT ROW_NUMBER() OVER (PARTITION BY ItemCD,ChangeDate ORDER BY ItemCD,ChangeDate ) row_num FROM @ItemTable)
    DELETE FROM cte WHERE row_num > 1;
    
    --Maintenance of values
    UPDATE @ItemTable set TaniCD = null where TaniCD = ''
    UPDATE @ItemTable set ColorCount = 1 where ColorCount = 0
    UPDATE @ItemTable set SizeCount = 1 where SizeCount = 0

    --In case of product revision
    UPDATE t set 
    t.RevisionFlg = 1,
    t.MostRecentChangeDate = mi.ChangeDate
    from @ItemTable t
    cross apply (select top 1 m.ChangeDate from M_ITEM m 
        where m.ITemCD = t.ITemCD and m.ChangeDate < t.ChangeDate order by m.ChangeDate desc) mi
    where not exists(select * from M_ITEM m where m.ITemCD = t.ITemCD and m.ChangeDate = t.ChangeDate)

    --「基本情報」取込時は下記初期値をセットする
    IF @MainFlg = 2
	BEGIN

    	    UPDATE Main
		    SET Main.SetKBN          = CASE WHEN Item.ItemCD IS NULL THEN Sku.SetKBN ELSE Item.SetKBN END                          -- セット品区分
		      , Main.PresentKBN      = CASE WHEN Item.ItemCD IS NULL THEN Sku.PresentKBN ELSE Item.PresentKBN END                  -- プレゼント品区分
		      , Main.SampleKBN       = CASE WHEN Item.ItemCD IS NULL THEN Sku.SampleKBN ELSE Item.SampleKBN END                    -- サンプル品区分
		      , main.DiscountKBN     = CASE WHEN Item.ItemCD IS NULL THEN Sku.DiscountKBN ELSE Item.DiscountKBN END                -- 値引商品区分
		      , main.WebFlg          = CASE WHEN Item.ItemCD IS NULL THEN Sku.WebFlg ELSE Item.WebFlg END	                       -- Webストア取扱区分
		      , Main.RealStoreFlg    = CASE WHEN Item.ItemCD IS NULL THEN Sku.RealStoreFlg ELSE Item.RealStoreFlg END              -- 実店舗取扱区分
		      , Main.ZaikoKBN        = CASE WHEN Item.ItemCD IS NULL THEN Sku.ZaikoKBN ELSE Item.ZaikoKBN END                      -- 在庫管理対象区分
		      , Main.VirtualFlg      = CASE WHEN Item.ItemCD IS NULL THEN Sku.VirtualFlg ELSE Item.VirtualFlg END                  -- 架空商品区分
		      , Main.DirectFlg       = CASE WHEN Item.ItemCD IS NULL THEN Sku.DirectFlg ELSE Item.DirectFlg END                    -- 直送品区分
		      , Main.ReserveCD       = CASE WHEN Item.ItemCD IS NULL THEN Sku.ReserveCD ELSE Item.ReserveCD END                    -- 予約品区分
		      , Main.NoticesCD       = CASE WHEN Item.ItemCD IS NULL THEN Sku.NoticesCD ELSE Item.NoticesCD END                    -- 特記区分
		      , Main.PostageCD       = CASE WHEN Item.ItemCD IS NULL THEN Sku.PostageCD ELSE Item.PostageCD END                    -- 送料区分
		      , Main.ManufactCD      = CASE WHEN Item.ItemCD IS NULL THEN Sku.ManufactCD ELSE Item.ManufactCD END                  -- 要加工品区分
		      , Main.ConfirmCD       = CASE WHEN Item.ItemCD IS NULL THEN Sku.ConfirmCD ELSE Item.ConfirmCD END                    -- 要確認品区分
		      , Main.StopFlg         = CASE WHEN Item.ItemCD IS NULL THEN Sku.StopFlg ELSE Item.StopFlg END                        -- 販売停止品区分
 		      , Main.DiscontinueFlg  = CASE WHEN Item.ItemCD IS NULL THEN Sku.DiscontinueFlg ELSE Item.DiscontinueFlg END          -- 廃盤品区分
		      , Main.SoldOutFlg      = CASE WHEN Item.ItemCD IS NULL THEN Sku.SoldOutFlg ELSE Item.SoldOutFlg END                  -- 完売品区分
		      , Main.WebStockFlg     = CASE WHEN Item.ItemCD IS NULL THEN Sku.WebStockFlg ELSE Item.WebStockFlg END                -- Web在庫連携区分
		      , Main.InventoryAddFlg = CASE WHEN Item.ItemCD IS NULL THEN Sku.InventoryAddFlg ELSE Item.InventoryAddFlg END        -- 自社在庫連携対象
		      , Main.MakerAddFlg     = CASE WHEN Item.ItemCD IS NULL THEN Sku.MakerAddFlg ELSE Item.MakerAddFlg END                -- メーカー在庫連携対象
		      , Main.StoreAddFlg     = CASE WHEN Item.ItemCD IS NULL THEN Sku.StoreAddFlg ELSE Item.StoreAddFlg END                -- 店舗在庫連携対象
		      , Main.NoNetOrderFlg   = CASE WHEN Item.ItemCD IS NULL THEN Sku.NoNetOrderFlg ELSE Item.NoNetOrderFlg END            -- Net発注不可区分
		      , Main.EDIOrderFlg     = CASE WHEN Item.ItemCD IS NULL THEN Sku.EDIOrderFlg ELSE Item.EDIOrderFlg END                -- EDI発注可能区分
		      , Main.AutoOrderFlg    = CASE WHEN Item.ItemCD IS NULL THEN Sku.AutoOrderFlg ELSE Item.AutoOrderFlg END              -- 自動発注対象
		      , Main.CatalogFlg      = CASE WHEN Item.ItemCD IS NULL THEN Sku.CatalogFlg ELSE Item.CatalogFlg END                  -- カタログ掲載有無
		      , Main.ParcelFlg       = CASE WHEN Item.ItemCD IS NULL THEN Sku.ParcelFlg ELSE Item.ParcelFlg END                    -- 小包梱包可能
		      , Main.TaxRateFLG      = CASE WHEN Item.ItemCD IS NULL THEN Sku.TaxRateFLG ELSE Item.TaxRateFLG END                  -- 税率区分
		      , Main.CostingKBN      = CASE WHEN Item.ItemCD IS NULL THEN Sku.CostingKBN ELSE Item.CostingKBN END                  -- 原価計算方法
		      , Main.SaleExcludedFlg = CASE WHEN Item.ItemCD IS NULL THEN Sku.SaleExcludedFlg ELSE Item.SaleExcludedFlg END        -- Sale対象外区分
              , Main.OrderLot        = CASE WHEN Item.ItemCD IS NULL THEN 1 ELSE Item.OrderLot END                                 -- 発注ロット
		    FROM @ItemTable Main
		    LEFT JOIN M_SKUInitial Sku ON Sku.MainKEY = 1
            LEFT JOIN M_ITEM Item ON Item.ItemCD = Main.ItemCD 
        
	END
    IF @MainFlg = 5
	BEGIN

	        -- カタログ
            CREATE TABLE ##tmpCatalog
			(
			    [ItemCD] [varchar](30) collate database_default null,
                [ChangeDate] [date] NOT null,
				[LastYearTerm] [varchar](6) collate database_default null,
				[LastSeason] [varchar](6) collate database_default null,
                [LastCatalogNO] [varchar](20) collate database_default null,
                [LastCatalogPage] [varchar](20) collate database_default null,
                [LastCatalogText] [varchar](1000) collate database_default null,
                [LastInstructionsNO] [varchar](1000) collate database_default null,
                [LastInstructionsDate] [date] null
			);

            --M_ITEM変更前の値を保持しておく
			INSERT INTO ##tmpCatalog
			SELECT item.ItemCD
			     , item.ChangeDate
				 , item.LastYearTerm
				 , item.LastSeason
				 , item.LastCatalogNO
				 , item.LastCatalogPage
				 , item.LastCatalogText
				 , item.LastInstructionsNO
				 , item.LastInstructionsDate
			FROM @ItemTable Main
			INNER JOIN M_ITEM item ON item.ITemCD = Main.ITemCD AND ITEM.ChangeDate = MAIN.ChangeDate
			;

	END
	IF @MainFlg = 6
	BEGIN

	        -- タグ
			CREATE TABLE ##tmpTag
			(
			    [ItemCD] [varchar](30) collate database_default null,
                [ChangeDate] [date] NOT null,
				[TagName01] [varchar](40) null,
				[TagName02] [varchar](40) null,
				[TagName03] [varchar](40) null,
				[TagName04] [varchar](40) null,
				[TagName05] [varchar](40) null,
				[TagName06] [varchar](40) null,
				[TagName07] [varchar](40) null,
				[TagName08] [varchar](40) null,
				[TagName09] [varchar](40) null,
				[TagName10] [varchar](40) null
			);

            --M_ITEM変更前の値を保持しておく
			INSERT INTO ##tmpTag
			SELECT Main.ITemCD
			     , Main.ChangeDate
			     , Item.TagName01
			     , Item.TagName02
				 , Item.TagName03
				 , Item.TagName04
				 , Item.TagName05
				 , Item.TagName06
				 , Item.TagName07
				 , Item.TagName08
				 , Item.TagName09
				 , Item.TagName10
			FROM @ItemTable Main
			INNER JOIN M_ITEM item ON item.ITemCD = Main.ITemCD AND item.ChangeDate = Main.ChangeDate
			;

	END

    --for debug
    --drop table test_M_ItemImport
    --select * into test_M_ItemImport from @ItemTable
    --return
    --==================================================
    if @MainFlg = 1             --- all
    Begin 
        exec dbo._Item_ITem
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_SKU
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_SKUTag
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_ItemPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_JanOrderPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_JanOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_ItemOrderPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_ItemOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_Site
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_SKUInfo
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_SKUPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;

    End
    else if @MainFlg = 2        --- basic
    Begin
        exec dbo._Item_ITem
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_SKU
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKUTag
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_ItemPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_JanOrderPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_JanOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_ItemOrderPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_ItemOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_Site
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUInfo
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_SKUPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
    End
    else if @MainFlg = 3        --- attribute
    Begin
        exec dbo._Item_ITem
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKU
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUTag
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_ItemPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_JanOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_JanOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_Site
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUInfo
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_SKUPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
    End 
    else if @MainFlg = 4        --- Price
    Begin
        exec dbo._Item_ITem
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKU
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUTag
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_ItemPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_JanOrderPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_JanOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_ItemOrderPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_ItemOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_Site
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUInfo
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_SKUPrice
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
    End 
    else if @MainFlg = 5        --- Catalog
    Begin
        exec dbo._Item_ITem
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        exec dbo._Item_SKU
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKUTag
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_JanOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_JanOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_Site
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_SKUInfo
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKUPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
    End 
    else if @MainFlg = 6        --- tag
    Begin
        exec dbo._Item_ITem
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKU
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_SKUTag
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_ItemPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_JanOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_JanOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_Site
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUInfo
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
    End 
    else if @MainFlg = 8        --- site
    Begin
        exec dbo._Item_ITem
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKU
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUTag
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_JanOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_JanOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_ItemOrderPrice2
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        exec dbo._Item_Site
             @ItemTable,
             @Opt,
             @Date,
             @MainFlg;
        --exec dbo._Item_SKUInfo
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
        --exec dbo._Item_SKUPrice
        --     @ItemTable,
        --     @Opt,
        --     @Date,
        --     @MainFlg;
    End

--------------------------------------------------------------------------------
    EXEC L_Log_Insert
                     @opt  
                    ,@PG        
                    ,@PC             
                    ,@Mode    
                    ,@KeyItem


END
