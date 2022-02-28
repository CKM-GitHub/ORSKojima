 BEGIN TRY 
 Drop Procedure [dbo].[MasterTorikomi_SKU_Insert_Update]
END try
BEGIN CATCH END CATCH 
SET ANSI_nullS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MasterTorikomi_SKU_Insert_Update]
    -- Add the parameters for the stored procedure here
    @xml as Xml,
    @type as int,
    @OperatorCD as varchar(10),
    @ProgramID as varchar(100),
    @PC as varchar(30),
    @KeyItem as varchar(100)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @SysDatetime    datetime = getdate();
    declare @LastAdminNO    int = 0
    declare @LastJanCD      bigint = 0        -- 仮JAN
	declare @LastJanCDJ     bigint = 0        -- 自社JAN
	declare @LastJanCDD     bigint = 0        -- 削除JAN


    if @type =1    --【All】
    Begin
        Create table [#tmpSKU1](
                [AdminNO] [varchar](50) collate database_default NOT null,
                [ChangeDate] [date] NOT null,
                [SKUCD] [varchar](40) collate database_default null,
                [VariousFLG] [tinyint] null,
                [SKUName] [varchar](100) collate database_default null,
                [KanaName] [varchar](50) collate database_default null,
                [SKUShortName] [varchar](40) collate database_default null,
                [EnglishName] [varchar](80) collate database_default null,
                [ITEMCD] [varchar](30) collate database_default null,
                [SizeNO] [int] null,
                [ColorNO] [int] null,
                [JanCD] [varchar](13) collate database_default null,
                [SetKBN] [tinyint] null,
                [PresentKBN] [tinyint] null,
                [SampleKBN] [tinyint] null,
                [DiscountKBN] [tinyint] null,
                [SizeName] [varchar](32) collate database_default null,
                [ColorName] [varchar](32) collate database_default null,
                [WebFlg] [tinyint] null,
                [RealStoreFlg] [tinyint] null,
                [MainVendorCD] [varchar](13) collate database_default null,
                [BrandCD] [varchar](6) collate database_default null,
                [MakerItem] [varchar](50) collate database_default null,
                [TaniCD] [varchar](2) collate database_default null,
                [SportsCD] [varchar](6) collate database_default null,
                [SegmentCD] [varchar](6) collate database_default null,
                [ZaikoKBN] [tinyint] null,
                [Rack] [varchar](10) collate database_default null,
                [VirtualFlg] [tinyint] null,
                [DirectFlg] [tinyint] null,
                [ReserveCD] [varchar](3) collate database_default null,
                [NoticesCD] [varchar](3) collate database_default null,
                [PostageCD] [varchar](3) collate database_default null,
                [ManufactCD] [varchar](3) collate database_default null,
                [ConfirmCD] [varchar](3) collate database_default null,
                [WebStockFlg] [tinyint] null,
                [StopFlg] [tinyint] null,
                [DiscontinueFlg] [tinyint] null,
                [SoldOutFlg] [tinyint] null,
                [InventoryAddFlg] [tinyint] null,
                [MakerAddFlg] [tinyint] null,
                [StoreAddFlg] [tinyint] null,
                [NoNetOrderFlg] [tinyint] null,
                [EDIOrderFlg] [tinyint] null,
                [AutoOrderFlg] [tinyint] null,
                [CatalogFlg] [tinyint] null,
                [ParcelFlg] [tinyint] null,
                [TaxRateFLG] [tinyint] null,
                [CostingKBN] [tinyint] null,
                [SaleExcludedFlg] [tinyint] null,
                [NormalCost] [money] NOT null,
                [PriceWithTax] [money] null,
                [PriceOutTax] [money] null,
                [OrderPriceWithTax] [money] null,
                [OrderPriceWithoutTax] [money] null,
                [Rate] [decimal](5, 2) null,
                [SaleStartDate] [date] null,
                [WebStartDate] [date] null,
                [OrderAttentionCD] [varchar](3) collate database_default null,
                [OrderAttentionNote] [varchar](100) collate database_default null,
                [CommentInStore] [varchar](300) collate database_default null,
                [CommentOutStore] [varchar](300) collate database_default null,
                [LastYearTerm] [varchar](6) collate database_default null,
                [LastSeason] [varchar](6) collate database_default null,
                [LastCatalogNO] [varchar](20) collate database_default null,
                [LastCatalogPage] [varchar](20) collate database_default null,
                [LastCatalogNOLong] [varchar](2000) collate database_default null,
                [LastCatalogPageLong] [varchar](2000) collate database_default null,
                [LastCatalogText] [varchar](1000) collate database_default null,
                [LastInstructionsNO] [varchar](1000) collate database_default null,
                [LastInstructionsDate] [date] null,
                [WebAddress] [varchar](200) collate database_default null,
                [SetAdminCD] [int] null,
                [SetItemCD] [varchar](30) collate database_default null,
                [SetSKUCD] [varchar](30) collate database_default null,
                [SetSU] [int] null,
                [ExhibitionSegmentCD] [varchar](5) collate database_default null,
                [OrderLot] [int] null,
                [ExhibitionCommonCD] [varchar](30) collate database_default null,
                [ApprovalDate] [date] null,
                [DeleteFlg] [tinyint] null,
                [TagName1] [varchar](40) collate database_default null,
                [TagName2] [varchar](40) collate database_default null,
                [TagName3] [varchar](40) collate database_default null,
                [TagName4] [varchar](40) collate database_default null,
                [TagName5] [varchar](40) collate database_default null,
                [TagName6] [varchar](40) collate database_default null,
                [TagName7] [varchar](40) collate database_default null,
                [TagName8] [varchar](40) collate database_default null,
                [TagName9] [varchar](40) collate database_default null,
                [TagName10] [varchar](40) collate database_default null
                )
        declare @DocHandle1 int

        exec sp_xml_preparedocument @DocHandle1 output, @xml
        INSERT Into #tmpSKU1
        select *  FROM OPENXML (@DocHandle1, '/NewDataSet/test',2)
                with
                (
                AdminNO varchar(50),
                改定日 date,
                SKUCD varchar(40),
                諸口区分 tinyint,
                商品名 varchar(100),
                カナ名 varchar(50),
                略名 varchar(40),
                英語名 varchar(80),
                ITEMCD varchar(30),
                サイズ枝番 int,
                カラー枝番 int,
                JANCD varchar(13),
                セット品区分 tinyint,
                プレゼント品区分 tinyint,
                サンプル品区分 tinyint,
                値引商品区分 tinyint,
                サイズ名 varchar(32),
                カラー名 varchar(32),
                Webストア取扱区分 tinyint,
                実店舗取扱区分 tinyint,
                主要仕入先CD varchar(13),
                ブランドCD varchar(6),
                メーカー商品CD varchar(50),
                単位CD varchar(2),
                競技CD varchar(6),
                商品分類CD varchar(6),
                在庫管理対象区分 tinyint,
                棚番 varchar(10),
                架空商品区分 tinyint,
                直送品区分 tinyint,
                予約品区分 varchar(3),
                特記区分 varchar(3),
                送料区分 varchar(3),
                要加工品区分 varchar(3),
                要確認品区分 varchar(3),
                Web在庫連携区分 tinyint,
                販売停止品区分 tinyint,
                廃番品区分 tinyint,
                完売品区分 tinyint,
                自社在庫連携対象 tinyint,
                メーカー在庫連携対象 tinyint,
                店舗在庫連携対象 tinyint,
                Net発注不可区分 tinyint,
                EDI発注可能区分 tinyint,
                自動発注対象区分 tinyint,
                カタログ掲載有無区分 tinyint,
                小包梱包可能区分 tinyint,
                税率区分 tinyint,
                原価計算方法 tinyint,
                Sale対象外区分 tinyint,
                標準原価 money ,
                税込定価 money,
                税抜定価 money,
                発注税込価格 money,
                発注税抜価格 money,
                掛率 decimal(5, 2),
                発売開始日 date,
                Web掲載開始日 date,
                発注注意区分 varchar(3),
                発注注意事項 varchar(100),
                管理用備考 varchar(300),
                表示用備考 varchar(300),
                年度 varchar(6),
                シーズン varchar(6),
                カタログ番号 varchar(20),
                カタログページ varchar(20),
                カタログ番号Long varchar(2000),
                カタログページLong varchar(2000),
                カタログ情報 varchar(1000),
                指示書番号 varchar(1000),
                指示書発行日 date,
                商品情報アドレス varchar(200),
                SetAdminCD int,
                SetItemCD varchar(30),
                SetSKUCD varchar(30),
                構成数 int,
                ExhibitionSegmentCD varchar(5),
                発注ロット int,
                ExhibitionCommonCD varchar(30),
                承認日 date,
                削除 tinyint,
                タグ1  varchar(40),
                タグ2  varchar(40),
                タグ3  varchar(40),
                タグ4 varchar(40),
                タグ5  varchar(40),
                タグ6  varchar(40),
                タグ7  varchar(40),
                タグ8 varchar(40),
                タグ9 varchar(40),
                タグ10 varchar(40)
                )
        exec sp_xml_removedocument @DocHandle1;
                
        Create table [#tmpSKU1_N](
                [LastAdminNO][int] Not null,
                [LastJanCD][varchar](13) collate database_default null,
                [AdminNO] [varchar](50) collate database_default NOT null,
                [ChangeDate] [date] NOT null,
                [SKUCD] [varchar](40) collate database_default null,
                [VariousFLG] [tinyint] null,
                [SKUName] [varchar](100) collate database_default null,
                [KanaName] [varchar](50) collate database_default null,
                [SKUShortName] [varchar](40) collate database_default null,
                [EnglishName] [varchar](80) collate database_default null,
                [ITEMCD] [varchar](30) collate database_default null,
                [SizeNO] [int] null,
                [ColorNO] [int] null,
                [JanCD] [varchar](13) collate database_default null,
                [SetKBN] [tinyint] null,
                [PresentKBN] [tinyint] null,
                [SampleKBN] [tinyint] null,
                [DiscountKBN] [tinyint] null,
                [SizeName] [varchar](32) collate database_default null,
                [ColorName] [varchar](32) collate database_default null,
                [WebFlg] [tinyint] null,
                [RealStoreFlg] [tinyint] null,
                [MainVendorCD] [varchar](13) collate database_default null,
                [BrandCD] [varchar](6) collate database_default null,
                [MakerItem] [varchar](50) collate database_default null,
                [TaniCD] [varchar](2) collate database_default null,
                [SportsCD] [varchar](6) collate database_default null,
                [SegmentCD] [varchar](6) collate database_default null,
                [ZaikoKBN] [tinyint] null,
                [Rack] [varchar](10) collate database_default null,
                [VirtualFlg] [tinyint] null,
                [DirectFlg] [tinyint] null,
                [ReserveCD] [varchar](3) collate database_default null,
                [NoticesCD] [varchar](3) collate database_default null,
                [PostageCD] [varchar](3) collate database_default null,
                [ManufactCD] [varchar](3) collate database_default null,
                [ConfirmCD] [varchar](3) collate database_default null,
                [WebStockFlg] [tinyint] null,
                [StopFlg] [tinyint] null,
                [DiscontinueFlg] [tinyint] null,
                [SoldOutFlg] [tinyint] null,
                [InventoryAddFlg] [tinyint] null,
                [MakerAddFlg] [tinyint] null,
                [StoreAddFlg] [tinyint] null,
                [NoNetOrderFlg] [tinyint] null,
                [EDIOrderFlg] [tinyint] null,
                [AutoOrderFlg] [tinyint] null,
                [CatalogFlg] [tinyint] null,
                [ParcelFlg] [tinyint] null,
                [TaxRateFLG] [tinyint] null,
                [CostingKBN] [tinyint] null,
                [SaleExcludedFlg] [tinyint] null,
                [NormalCost] [money] NOT null,
                [PriceWithTax] [money] null,
                [PriceOutTax] [money] null,
                [OrderPriceWithTax] [money] null,
                [OrderPriceWithoutTax] [money] null,
                [Rate] [decimal](5, 2) null,
                [SaleStartDate] [date] null,
                [WebStartDate] [date] null,
                [OrderAttentionCD] [varchar](3) collate database_default null,
                [OrderAttentionNote] [varchar](100) collate database_default null,
                [CommentInStore] [varchar](300) collate database_default null,
                [CommentOutStore] [varchar](300) collate database_default null,
                [LastYearTerm] [varchar](6) collate database_default null,
                [LastSeason] [varchar](6) collate database_default null,
                [LastCatalogNO] [varchar](20) collate database_default null,
                [LastCatalogPage] [varchar](20) collate database_default null,
                [LastCatalogNOLong] [varchar](2000) collate database_default null,
                [LastCatalogPageLong] [varchar](2000) collate database_default null,
                [LastCatalogText] [varchar](1000) collate database_default null,
                [LastInstructionsNO] [varchar](1000) collate database_default null,
                [LastInstructionsDate] [date] null,
                [WebAddress] [varchar](200) collate database_default null,
                [SetAdminCD] [int] null,
                [SetItemCD] [varchar](30) collate database_default null,
                [SetSKUCD] [varchar](30) collate database_default null,
                [SetSU] [int] null,
                [ExhibitionSegmentCD] [varchar](5) collate database_default null,
                [OrderLot] [int] null,
                [ExhibitionCommonCD] [varchar](30) collate database_default null,
                [ApprovalDate] [date] null,
                [DeleteFlg] [tinyint] null,
                [TagName1] [varchar](40) collate database_default null,
                [TagName2] [varchar](40) collate database_default null,
                [TagName3] [varchar](40) collate database_default null,
                [TagName4] [varchar](40) collate database_default null,
                [TagName5] [varchar](40) collate database_default null,
                [TagName6] [varchar](40) collate database_default null,
                [TagName7] [varchar](40) collate database_default null,
                [TagName8] [varchar](40) collate database_default null,
                [TagName9] [varchar](40) collate database_default null,
                [TagName10] [varchar](40) collate database_default null,
                [AdminCounter] int,
                [JancdCounter] int
                )


        ----------------------------------------
        --Number the AdminNO and JanCD first to prevent duplication when running concurrently.
        Update M_SKUCounter
        set @LastAdminNO = AdminNO = AdminNO + isnull((select count(*) from #tmpSKU1 where AdminNO = 'New'),0)
        where MainKEY = 1

		--仮JAN
        Update M_JANCounter
        set @LastJanCD = JanCount = JanCount + isnull((select count(*) from #tmpSKU1 where JanCD = '仮JAN'),0)
        where MainKEY = 1
		--自社JAN
        Update M_JANCounter
        set @LastJanCDJ = JanCount = JanCount + isnull((select count(*) from #tmpSKU1 where JanCD = '自社JAN'),0)
        where MainKEY = 2
		--削除JAN
        Update M_JANCounter
        set @LastJanCDD = JanCount = JanCount + isnull((select count(*) from #tmpSKU1 where JanCD = '削除JAN'),0)
        where MainKEY = 3


        Insert into [#tmpSKU1_N]
        select 
            (case when AdminNo = 'New' then @LastAdminNO - AdminCounter else AdminNo end ) as LastAdminNO,
            (case when JanCD = '仮JAN' then dbo.Fnc_SetCheckdigit(@LastJanCD - JancdCounter) 
			      when JanCD = '自社JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDJ - JancdCounter)
				  when JanCD = '削除JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDD - JancdCounter)
                  else case when len(JanCD) < 13 then dbo.Fnc_SetCheckdigit(JanCD) else JanCD end end ) as LastJanCD,
            *
            from 
            (
                select *,
                ROW_NUMBER() over (partition by AdminNO order by SKUCD desc) - 1 as AdminCounter,
                ROW_NUMBER() over (partition by JanCD order by SKUCD desc) - 1 as JancdCounter
                from #tmpSKU1
            ) f

        --for debug
        --drop table debug_tmpSKU1
        --select * into debug_tmpSKU1 from #tmpSKU1_N
        --return
        ----------------------------------------


        --M_SKU
        Update ms
        set
                SKUCD=ts.SKUCD,
                VariousFLG=isnull(ts.VariousFLG,0),
                SKUName=ts.SKUName,
                SKUNameLong=ts.SKUName,
                KanaName=ts.KanaName,
                SKUShortName=isnull(ts.SKUShortName, LEFT(ts.SKUName,40)),
                EnglishName=ts.EnglishName,
                ITemCD=ts.ITEMCD,
                SizeNO=ts.SizeNO,
                ColorNO=ts.ColorNO,
                JanCD=ts.LastJanCD,
                SizeName=ts.SizeName,
                ColorName=ts.ColorName,
                SizeNameLong=ts.SizeName,
                ColorNameLong=ts.ColorName,
                SetKBN=ts.SetKBN,
                PresentKBN=ts.PresentKBN,
                DiscountKBN=ts.DiscountKBN,
                WebFlg=ts.WebFlg,
                RealStoreFlg=ts.RealStoreFlg,
                MainVendorCD=ts.MainVendorCD,
                MakerVendorCD=ts.MainVendorCD,
                BrandCD=ts.BrandCD,
                MakerItem=ts.MakerItem,
                TaniCD=ts.TaniCD,
                SportsCD=ts.SportsCD,
                SegmentCD=ts.SegmentCD,
                ZaikoKBN=ts.ZaikoKBN,
                Rack=ts.Rack,
                VirtualFlg=ts.VirtualFlg,
                DirectFlg=ts.DirectFlg,
                ReserveCD=ts.ReserveCD,
                NoticesCD=ts.NoticesCD,
                PostageCD=ts.PostageCD,
                ManufactCD=ts.ManufactCD,
                ConfirmCD=ts.ConfirmCD,
                WebStockFlg=ts.WebStockFlg,
                StopFlg=ts.StopFlg,
                DiscontinueFlg=ts.DiscontinueFlg,
                SoldOutFlg=ts.SoldOutFlg,
                InventoryAddFlg=ts.InventoryAddFlg,
                MakerAddFlg=ts.MakerAddFlg,
                StoreAddFlg=ts.StoreAddFlg,
                NoNetOrderFlg=ts.NoNetOrderFlg,
                EDIOrderFlg=ts.EDIOrderFlg,
                AutoOrderFlg=ts.AutoOrderFlg,
                CatalogFlg=ts.CatalogFlg,
                ParcelFlg=ts.ParcelFlg,
                TaxRateFLG=ts.TaxRateFLG,
                CostingKBN=ts.CostingKBN,
                SaleExcludedFlg=ts.SaleExcludedFlg,
                NormalCost=isnull(ts.NormalCost,0),
                PriceOutTax=isnull(ts.PriceOutTax,0),
                PriceWithTax=isnull(ts.PriceWithTax,0),
                OrderPriceWithTax=isnull(ts.OrderPriceWithTax,0),
                OrderPriceWithoutTax=isnull(ts.OrderPriceWithoutTax,0),
                Rate=isnull(ts.Rate,0),
                SaleStartDate=ts.SaleStartDate,
                WebStartDate=ts.WebStartDate,
                OrderAttentionCD=ts.OrderAttentionCD,
                OrderAttentionNote=ts.OrderAttentionNote,
                CommentInStore=ts.CommentInStore,
                CommentOutStore=ts.CommentOutStore,
                LastYearTerm=ts.LastYearTerm,
                LastSeason=ts.LastSeason,
                LastCatalogNO=ts.LastCatalogNO,
                LastCatalogPage=ts.LastCatalogPage,
                LastCatalogNOLong=ts.LastCatalogNOLong,
                LastCatalogPageLong=ts.LastCatalogPageLong, 
                LastCatalogText=ts.LastCatalogText,
                LastInstructionsNO=ts.LastInstructionsNO,
                LastInstructionsDate=ts.LastInstructionsDate,
                WebAddress= isnull(ts.WebAddress,ts.ITEMCD),
                --SetAdminCD=0, 
                --SetItemCD=null,    
                --SetSKUCD=null,
                --SetSU=0,
                ExhibitionSegmentCD=ts.ExhibitionSegmentCD,
                OrderLot=isnull(ts.OrderLot,1),
                --ExhibitionCommonCD=null,
                ApprovalDate=ts.ApprovalDate,
                DeleteFlg=isnull(ts.DeleteFlg,0),
                --UsedFlg=0,
                SKSUpdateFlg=1,
                SKSUpdateDateTime=null,
                --InsertOperator=@OperatorCD,
                --InsertDateTime=@SysDatetime,
                UpdateOperator=@OperatorCD,
                UpdateDateTime=@SysDatetime 
                from M_SKU as ms
                inner join #tmpSKU1_N as ts on ts.LastAdminNO = ms.AdminNO and ts.ChangeDate = ms.ChangeDate
            
        Insert into M_SKU  
        Select    
                LastAdminNO,
                ChangeDate,
                SKUCD,
                isnull(VariousFLG,0),
                SKUName,
                SKUName, --SKUNameLong
                KanaName,
                isnull(SKUShortName,LEFT(SKUName,40)),
                EnglishName,
                ITEMCD,
                SizeNO,
                ColorNO,    
                LastJanCD,
                SetKBN,
                PresentKBN,
                SampleKBN,
                DiscountKBN,
                SizeName,
                ColorName,
                SizeName,
                ColorName,
                WebFlg,
                RealStoreFlg,
                MainVendorCD,
                MainVendorCD,
                BrandCD,
                MakerItem,
                TaniCD,
                SportsCD,
                SegmentCD,
                ZaikoKBN,
                Rack,
                VirtualFlg,
                DirectFlg,
                ts.ReserveCD,
                ts.NoticesCD,
                ts.PostageCD,
                ts.ManufactCD,
                ts.ConfirmCD,
                ts.WebStockFlg,
                ts.StopFlg,
                ts.DiscontinueFlg,
                ts.SoldOutFlg,
                ts.InventoryAddFlg,
                ts.MakerAddFlg,
                ts.StoreAddFlg,
                ts.NoNetOrderFlg,
                ts.EDIOrderFlg,
                ts.AutoOrderFlg,
                ts.CatalogFlg,
                ts.ParcelFlg,
                ts.TaxRateFLG,
                ts.CostingKBN,
                isnull(NormalCost,0) as NormalCost,
                ts.SaleExcludedFlg,
                isnull(PriceOutTax,0) as PriceOutTax,
                isnull(PriceWithTax,0) as PriceWithTax,
                isnull(OrderPriceWithTax,0) as OrderPriceWithTax,
                isnull(OrderPriceWithoutTax,0) as OrderPriceWithoutTax,
                isnull(Rate,0) as Rate,
                SaleStartDate,
                WebStartDate,
                OrderAttentionCD,
                OrderAttentionNote,
                CommentInStore,
                CommentOutStore,
                ts.LastYearTerm,
                ts.LastSeason,
                ts.LastCatalogNO,
                ts.LastCatalogPage,
                ts.LastCatalogNOLong,
                ts.LastCatalogPageLong, 
                ts.LastCatalogText,
                ts.LastInstructionsNO,
                ts.LastInstructionsDate,
                isnull(ts.WebAddress,ts.ITEMCD),
                0 as SetAdminCD,
                null as SetItemCD,
                null as SetSKUCD,
                0 as SetSU,
                ts.ExhibitionSegmentCD,
                isnull(ts.OrderLot,1),
                null as ExhibitionCommonCD,
                ts.ApprovalDate,
                isnull(ts.DeleteFlg,0),
                0 as UsedFlg,
                1 as SKSUpdateFlg,
                null as SKSUpdateDateTime,
                @OperatorCD,
                @SysDatetime,
                @OperatorCD,
                @SysDatetime 
                from #tmpSKU1_N as ts
                where not exists(select ms.AdminNO from M_SKU as ms 
                    where ms.AdminNO=ts.LastAdminNO and ms.ChangeDate=ts.ChangeDate)


        --M_SKUTag
        Delete mtag
                from M_SKUTag as mtag
                inner join #tmpSKU1_N as ts on ts.LastAdminNO = mtag.AdminNO and ts.ChangeDate = mtag.ChangeDate

        Insert into M_SKUTag
        Select 
                LastAdminNO,
                ChangeDate,
                ROW_NUMBER() OVER (PARTITION BY LastAdminNO ORDER BY LastAdminNO),
                ColumnValue 
                from #tmpSKU1_N as ts
                unpivot(ColumnValue for ColumnName in
                    (TagName1,TagName2,TagName3,TagName4,TagName5,TagName6,TagName7,TagName8,TagName9,TagName10)) AS H


        --M_JANOrderPrice
        Delete mj
                from M_JANOrderPrice as mj
                inner join M_SKU ms on ms.AdminNO = mj.AdminNO and ms.ChangeDate = mj.ChangeDate
                inner join #tmpSKU1_N as ts on ts.LastAdminNO= mj.AdminNO and ts.ChangeDate = mj.ChangeDate

        Insert into M_JANOrderPrice
        Select
                MainVendorCD,
                '0000',
                LastAdminNO,
                ChangeDate,
                SKUCD,
                isnull(Rate,0),
                isnull(OrderPriceWithoutTax,0),
                null as Remarks,
                isnull(DeleteFlg,0),
                0,
                @OperatorCD,
                @SysDatetime,
                @OperatorCD,
                @SysDatetime
                from #tmpSKU1_N 
                where MainVendorCD is not null and MainVendorCD <> ''


        --M_SKUInfo
        Update mi
        Set
                YearTerm=ts.LastYearTerm,
                Season=ts.LastSeason,
                CatalogNO=ts.LastCatalogNO,
                CatalogPage=ts.LastCatalogPage,
                CatalogText=ts.LastCatalogText,
                InstructionsNO=ts.LastInstructionsNO,
                InstructionsDate=ts.LastInstructionsDate,
                DeleteFlg=ts.DeleteFlg,
                UpdateOperator=@OperatorCD,
                UpdateDateTime=@SysDatetime
                from M_SKUInfo as mi
                inner join #tmpSKU1_N as ts on ts.LastAdminNO = mi.AdminNO and ts.ChangeDate = mi.ChangeDate
                where mi.SEQ= 1

        Insert into M_SKUInfo
        Select 
                ts.LastAdminNO,
                ts.ChangeDate,
                1,
                ts.LastYearTerm,
                ts.LastSeason,
                ts.LastCatalogNO,
                ts.LastCatalogPage,
                ts.LastCatalogText,
                ts.LastInstructionsNO,
                ts.LastInstructionsDate,
                ts.DeleteFlg,
                @OperatorCD,
                @SysDatetime,
                @OperatorCD,
                @SysDatetime
                from #tmpSKU1_N as ts
                where not exists(select AdminNO from M_SKUInfo as mi 
                    where mi.AdminNO = ts.LastAdminNO and mi.ChangeDate = ts.ChangeDate and mi.SEQ = 1)


        --M_SKUPrice
		Update mp 
        set 
                 mp.PriceWithTax = ts.PriceWithTax
                ,mp.PriceWithoutTax = ts.PriceOutTax
                ,mp.UpdateOperator = @OperatorCD
                ,mp.UpdateDateTime = @SysDatetime
                from M_SKUPrice mp
                inner join M_SKU ms on ms.AdminNO = mp.AdminNO and ms.ChangeDate = mp.ChangeDate
                inner join #tmpSKU1_N ts on ts.LastAdminNO = ms.AdminNO and ts.ChangeDate = ms.ChangeDate

        Insert into M_SKUPrice
        Select
			    '0000000000000' 
			    ,'0000' 
			    ,ts.LastAdminNO
			    ,ts.SKUCD
			    ,ts.ChangeDate
			    ,null
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,null
			    ,0
			    ,0
			    ,@OperatorCD
			    ,@SysDatetime
			    ,@OperatorCD
			    ,@SysDatetime
		        from #tmpSKU1_N ts 
                inner join M_SKU ms on ms.AdminNO = ts.LastAdminNO and ms.ChangeDate = ts.ChangeDate
		        where not exists(select * from M_SKUPrice mp 
                    where mp.AdminNO = ts.LastAdminNO and mp.ChangeDate = ts.ChangeDate) 


        --M_Site
        delete from M_Site where exists(
                select * from  #tmpSKU1_N ts 
                where ts.LastAdminNO = M_Site.AdminNO and ISNULL(ts.WebAddress,'') = '')

	    update ms set
                 ms.ShouhinCD = ts.WebAddress
	            ,ms.siteURL = ISNULL(ma.ShopURL,'') + ISNULL(ts.WebAddress,'') + '.html' 
	            ,ms.UpdateOperator = @OperatorCD
	            ,ms.UpdateDateTime = @SysDatetime
	            from M_Site ms
                inner join #tmpSKU1_N as ts on ts.LastAdminNO = ms.AdminNO and ISNULL(ts.WebAddress,'') <> ''
	            cross apply (select top 1 ma.ShopURL 
                            from M_API ma 
                            where ma.APIKey = ms.APIKey and ma.ChangeDate <= ts.ChangeDate and ma.SiteKBN > 0
                            order by ma.ChangeDate desc) ma

	    insert into M_Site
	    select distinct 
                 ts.LastAdminNO
	            ,ma.APIKey 
	            ,ts.WebAddress
	            ,ISNULL(ma.ShopURL,'') + ISNULL(ts.WebAddress,'') + '.html'
	            ,@OperatorCD
	            ,@SysDatetime
	            ,@OperatorCD
	            ,@SysDatetime
				
                from #tmpSKU1_N ts
	            cross apply (
                    select ma.APIKey, ma.ShopURL, ROW_NUMBER() OVER(PARTITION BY ma.APIKey ORDER BY ma.ChangeDate DESC) Rowno
                    from M_API ma
                    where ma.ChangeDate <= ts.ChangeDate and ma.SiteKBN > 0) ma
	            where ISNULL(ts.WebAddress,'') <> ''
                and ma.Rowno = 1 
                and not exists (select * from M_Site ms where ms.AdminNO = ts.LastAdminNO and ms.APIKey = ma.APIKey)        


        --M_ITEM
        Update item 
        set
                SizeCount = cnt.SizeCount,
                ColorCount = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join (
                    select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU1_N t on t.LastAdminNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply  (
                    select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


        drop table #tmpSKU1
        drop table #tmpSKU1_N
    End







	if @type =2    --【Basic】
	  Begin
	   Create table [#tmpSKU2](
	
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NOT NULL,
	[SKUCD] [varchar](40) NULL,
	[VariousFLG] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[KanaName] [varchar](50) NULL,
	[SKUShortName] [varchar](40) NULL,
	[EnglishName] [varchar](80) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[JanCD] [varchar](13) NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL,
	[MainVendorCD] [varchar](13) NULL,
	[VendorName] [varchar](50) NULL,
	[BrandCD] [varchar](6) NULL,
	[BrandName] [varchar](40) NULL,
	[MakerItem] [varchar](50) NULL,
	[TaniCD] [varchar](2) NULL,
	[TaniName] [varchar](100) NULL,
	[SportsCD] [varchar](6) NULL,
	[SportsName] [varchar](100) NULL,
	[SegmentCD] [varchar](6) NULL,
	[SegmentName] [varchar](100) NULL,
	[ZaikoKBN] [tinyint] NULL,
	[Rack] [varchar](10) NULL,
	[NormalCost] [money] NOT NULL,
	[PriceWithTax] [money] NULL,
	[PriceOutTax] [money] NULL,
	[OrderPriceWithTax] [money] NULL,
	[OrderPriceWithoutTax] [money] NULL,
	[Rate] [decimal](5, 2) NULL,
	[SaleStartDate] [date] NULL,
	[WebStartDate] [date] NULL,
	[OrderAttentionCD] [varchar](3) NULL,
	[OrderAttentionName] [varchar](100) NULL,
	[OrderAttentionNote] [varchar](100) NULL,
	[CommentInStore] [varchar](300) NULL,
	[CommentOutStore] [varchar](300) NULL,
	[SetSU] [int] NULL,
	[ExhibitionSegmentCD] [varchar](5) NULL,
	[ExhibitionSegmentName] [varchar](100) NULL,
	[OrderLot] [int] NULL,
	[ApprovalDate] [date] NULL,
	[DeleteFlg] [tinyint] NULL
	)

	 Create table [#tmpSKU2_N](
	[LastNO][int] NOT NUll,
	[LastJanNo][varchar](13) NULL,
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NOT NULL,
	[SKUCD] [varchar](40) NULL,
	[VariousFLG] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[KanaName] [varchar](50) NULL,
	[SKUShortName] [varchar](40) NULL,
	[EnglishName] [varchar](80) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[JanCD] [varchar](13) NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL,
	[MainVendorCD] [varchar](13) NULL,
	[VendorName] [varchar](50) NULL,
	[BrandCD] [varchar](6) NULL,
	[BrandName] [varchar](40) NULL,
	[MakerItem] [varchar](50) NULL,
	[TaniCD] [varchar](2) NULL,
	[TaniName] [varchar](100) NULL,
	[SportsCD] [varchar](6) NULL,
	[SportsName] [varchar](100) NULL,
	[SegmentCD] [varchar](6) NULL,
	[SegmentName] [varchar](100) NULL,
	[ZaikoKBN] [tinyint] NULL,
	[Rack] [varchar](10) NULL,
	[NormalCost] [money] NOT NULL,
	[PriceWithTax] [money] NULL,
	[PriceOutTax] [money] NULL,
	[OrderPriceWithTax] [money] NULL,
	[OrderPriceWithoutTax] [money] NULL,
	[Rate] [decimal](5, 2) NULL,
	[SaleStartDate] [date] NULL,
	[WebStartDate] [date] NULL,
	[OrderAttentionCD] [varchar](3) NULL,
	[OrderAttentionName] [varchar](100) NULL,
	[OrderAttentionNote] [varchar](100) NULL,
	[CommentInStore] [varchar](300) NULL,
	[CommentOutStore] [varchar](300) NULL,
	[SetSU] [int] NULL,
	[ExhibitionSegmentCD] [varchar](5) NULL,
	[ExhibitionSegmentName] [varchar](100) NULL,
	[OrderLot] [int] NULL,
	[ApprovalDate] [date] NULL,
	[DeleteFlg] [tinyint] NULL,
    [AdminCounter] int,
    [JancdCounter] int
	)
	declare @DocHandle2 int

	exec sp_xml_preparedocument @DocHandle2 output, @xml
	insert into #tmpSKU2
	select *  FROM OPENXML (@DocHandle2, '/NewDataSet/test',2)
			with
			(
	AdminNO varchar(50),
	改定日 date,
	SKUCD varchar(40) ,
	諸口区分 tinyint,
	商品名 varchar(100),
	カナ名 varchar(50),
	略名 varchar(40),
	英語名 varchar(80),
	ITEMCD varchar(30),
	サイズ枝番 int,
	カラー枝番 int,
	JANCD varchar(13),
	サイズ名 varchar(32) ,
	カラー名 varchar(32) ,
	主要仕入先CD varchar(13) ,
	主要仕入先名 varchar(50),
	ブランドCD varchar(6) ,
	ブランド名 varchar(40),
	メーカー商品CD varchar(50) ,
	単位CD varchar(2) ,
	単位名 varchar(100),
	競技CD varchar(6) ,
	競技名 varchar(100),
	商品分類CD varchar(6) ,
	分類名 varchar(100),
	ZaikoKBN tinyint ,
	棚番 varchar(10) ,
	標準原価 money  ,
	税抜定価 money ,
	税込定価 money ,
	発注税込価格 money ,
	発注税抜価格 money ,
	掛率 decimal(5, 2) ,
	発売開始日 date ,
	Web掲載開始日 date,
	発注注意区分 varchar(3) ,
	発注注意区分名 varchar(100),
	発注注意事項 varchar(100) ,
	管理用備考 varchar(300) ,
	表示用備考 varchar(300) ,
	構成数 int,
	セグメントCD varchar(5),
	セグメント名 varchar(100),
	発注ロット int ,
	承認日 date ,
	削除 tinyint  
	)
	exec sp_xml_removedocument @DocHandle2;


        ----------------------------------------
        --Number the AdminNO and JanCD first to prevent duplication when running concurrently.
        Update M_SKUCounter
        set @LastAdminNO = AdminNO = AdminNO + isnull((select count(*) from #tmpSKU2 where AdminNO = 'New'),0)
        where MainKEY = 1

		--仮JAN
        Update M_JANCounter
        set @LastJanCD = JanCount = JanCount + isnull((select count(*) from #tmpSKU2 where JanCD = '仮JAN'),0)
        where MainKEY = 1
		--自社JAN
        Update M_JANCounter
        set @LastJanCDJ = JanCount = JanCount + isnull((select count(*) from #tmpSKU2 where JanCD = '自社JAN'),0)
        where MainKEY = 2
		--削除JAN
        Update M_JANCounter
        set @LastJanCDD = JanCount = JanCount + isnull((select count(*) from #tmpSKU2 where JanCD = '削除JAN'),0)
        where MainKEY = 3



        Insert into [#tmpSKU2_N]
        select 
            (case when AdminNo = 'New' then @LastAdminNO - AdminCounter else AdminNo end ) as LastAdminNO,
            (case when JanCD = '仮JAN' then dbo.Fnc_SetCheckdigit(@LastJanCD - JancdCounter)
			      when JanCD = '自社JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDJ - JancdCounter)
				  when JanCD = '削除JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDD - JancdCounter)
			      else JanCD end ) as LastJanCD,
            *
            from 
            (
                select *,
                ROW_NUMBER() over (partition by AdminNO order by SKUCD desc) - 1 as AdminCounter,
                ROW_NUMBER() over (partition by JanCD order by SKUCD desc) - 1 as JancdCounter
                from #tmpSKU2
            ) f
        ----------------------------------------
			
	
		Insert 
						Into    M_SKU
						Select	
								LastNO,
								ChangeDate ,
								SKUCD ,
								IsNull(VariousFLG,0),
								IsNull(SKUName,'---'),
								SKUName,
								KanaName,
								IsNull(SKUShortName,LEFT(SKUName,40)),
								EnglishName ,
								IsNull(ITEMCD,'---') ,
								SizeNO,
								ColorNO ,
								LastJanNo ,
								(SELECT SetKBN from M_SKUInitial where MainKey=1),
								(SELECT PresentKBN from M_SKUInitial where MainKey=1),
								(SELECT SampleKBN from M_SKUInitial where MainKey=1),
								(SELECT DiscountKBN from M_SKUInitial where MainKey=1),
								SizeName,
								ColorName ,
								SizeName,
								ColorName ,
								(SELECT WebFlg from M_SKUInitial where MainKey=1),
								(SELECT RealStoreFlg from M_SKUInitial where MainKey=1),
								MainVendorCD ,
								MainVendorCD ,
								BrandCD,
								MakerItem,
								TaniCD,
								SportsCD,
								SegmentCD,
								(SELECT VirtualFlg from M_SKUInitial where MainKey=1)ZaikoKBN,
								Rack ,
								(SELECT VirtualFlg from M_SKUInitial where MainKey=1),
								(SELECT DirectFlg from M_SKUInitial where MainKey=1),
								(SELECT ReserveCD from M_SKUInitial where MainKey=1),
								(SELECT NoticesCD from M_SKUInitial where MainKey=1),
								(SELECT PostageCD from M_SKUInitial where MainKey=1),
								(SELECT ManufactCD from M_SKUInitial where MainKey=1),
								(SELECT ConfirmCD from M_SKUInitial where MainKey=1),
								(SELECT WebStockFlg from M_SKUInitial where MainKey=1),
								(SELECT StopFlg from M_SKUInitial where MainKey=1),
								(SELECT DiscontinueFlg from M_SKUInitial where MainKey=1),
								(SELECT SoldOutFlg from M_SKUInitial where MainKey=1),
								(SELECT InventoryAddFlg from M_SKUInitial where MainKey=1),
								(SELECT MakerAddFlg from M_SKUInitial where MainKey=1),
								(SELECT StoreAddFlg from M_SKUInitial where MainKey=1),
								(SELECT NoNetOrderFlg from M_SKUInitial where MainKey=1),
								(SELECT EDIOrderFlg from M_SKUInitial where MainKey=1),
								(SELECT AutoOrderFlg from M_SKUInitial where MainKey=1),
								(SELECT CatalogFlg from M_SKUInitial where MainKey=1),
								(SELECT ParcelFlg from M_SKUInitial where MainKey=1),
								(SELECT TaxRateFLG from M_SKUInitial where MainKey=1),
								(SELECT CostingKBN from M_SKUInitial where MainKey=1),
								IsNull(NormalCost,0)as NormalCost,
								(SELECT SaleExcludedFlg from M_SKUInitial where MainKey=1),
								IsNull(PriceOutTax,0)as PriceOutTax ,
								IsNull(PriceWithTax,0) as PriceWithTax,
								IsNull(OrderPriceWithTax ,0)as OrderPriceWithTax,
								IsNull(OrderPriceWithoutTax,0)as OrderPriceWithoutTax,
								IsNull(Rate,0) as Rate,
								SaleStartDate ,
								WebStartDate,
								OrderAttentionCD ,
								OrderAttentionNote,
								CommentInStore,
								CommentOutStore ,
								Null,
								Null,
								Null,
								Null,
								Null,
								Null, 
								Null,
								Null,
								Null,
								ts.ITEMCD,--WebAddress
								0,
								Null,	
								Null,		--ts.SetSKUCD,
								0,   --ts.SetSU,
								ts.ExhibitionSegmentCD,
								1,--OrderLost
								Null,	--ts.ExhibitionCommonCD,
								ts.ApprovalDate,
								IsNull(ts.DeleteFlg,0),
								0,			--ts.UsedFlg,
								1,		--ts.SKSUpdateFlg,
								Null,		--ts.SKSUpdateDateTime,
								@OperatorCD,
								getdate(),
								@OperatorCD,
								getdate() 
						from #tmpSKU2_N as ts
						where not Exists(
											Select ms.AdminNO
											from M_SKU as ms
											where ms.AdminNO=ts.LastNO
											and ms.ChangeDate=ts.ChangeDate
										)
					
	  	Update M_SKU
						Set		
								AdminNo=ts.LastNO,
								ChangeDate=ts.ChangeDate ,
								SKUCD=ts.SKUCD ,
								VariousFLG=mi.VariousFLG,
								SKUName=IsNull(ts.SKUName,'---'),
								SKUNameLong=ts.SKUName,
								KanaName=ts.KanaName,
								SKUShortName=IsNull(ts.SKUShortName,LEFT(ts.SKUName,40)),
								EnglishName=ts.EnglishName ,
								ITemCD=IsNull(ts.ITEMCD,'---') ,
								SizeNO=ts.SizeNO,
								ColorNO=ts.ColorNO ,
								JanCD=ts.LastJanNo ,
								SizeName=ts.SizeName,
								ColorName=ts.ColorName ,
								SizeNameLong=ts.SizeName,
								ColorNameLong=ts.ColorName ,
								SetKBN=mi.SetKBN,
								PresentKBN=(SELECT PresentKBN from M_SKUInitial where MainKey=1),
								DiscountKBN=(SELECT DiscountKBN from M_SKUInitial where MainKey=1),
								WebFlg=(SELECT WebFlg from M_SKUInitial where MainKey=1),
								RealStoreFlg=(SELECT RealStoreFlg from M_SKUInitial where MainKey=1),
								MainVendorCD=ts.MainVendorCD ,
								MakerVendorCD=ts.MainVendorCD ,
								BrandCD=mi.BrandCD,
								MakerItem=mi.MakerItem,
								TaniCD=mi.TaniCD,
								SportsCD=mi.SportsCD,
								SegmentCD=mi.SegmentCD,
								ZaikoKBN=mi.ZaikoKBN,
								Rack=ts.Rack ,
								VirtualFlg=(SELECT VirtualFlg from M_SKUInitial where MainKey=1),
								DirectFlg=mi.DirectFlg,
								ReserveCD=mi.ReserveCD,
								NoticesCD=mi.NoticesCD,
								PostageCD=mi.PostageCD,
								ManufactCD=mi.ManufactCD,
								ConfirmCD=mi.ConfirmCD,
								WebStockFlg=mi.WebStockFlg,
								StopFlg=(SELECT StopFlg from M_SKUInitial where MainKey=1),
								DiscontinueFlg=(SELECT DiscontinueFlg from M_SKUInitial where MainKey=1),
								SoldOutFlg=(SELECT SoldOutFlg from M_SKUInitial where MainKey=1),
								InventoryAddFlg=mi.InventoryAddFlg,
								MakerAddFlg=mi.MakerAddFlg,
								StoreAddFlg=mi.StoreAddFlg,
								NoNetOrderFlg=mi.NoNetOrderFlg,
								EDIOrderFlg=mi.EDIOrderFlg,
								AutoOrderFlg=mi.AutoOrderFlg,
								CatalogFlg=(SELECT CatalogFlg from M_SKUInitial where MainKey=1),
								ParcelFlg=(SELECT ParcelFlg from M_SKUInitial where MainKey=1),
								TaxRateFLG=mi.TaxRateFLG,
								CostingKBN=mi.CostingKBN,
								SaleExcludedFlg=(SELECT SaleExcludedFlg from M_SKUInitial where MainKey=1),
								NormalCost=IsNull(ts.NormalCost,0),
								PriceOutTax=IsNull(ts.PriceOutTax,0) ,
								PriceWithTax=IsNull(ts.PriceWithTax,0),
								OrderPriceWithTax=IsNull(ts.OrderPriceWithTax ,0),
								OrderPriceWithoutTax=IsNull(ts.OrderPriceWithoutTax,0),
								Rate=IsNull(ts.Rate,0),
								SaleStartDate=ts.SaleStartDate ,
								WebStartDate=ts.WebStartDate,
								OrderAttentionCD=ts.OrderAttentionCD ,
								OrderAttentionNote=ts.OrderAttentionNote,
								CommentInStore=ts.CommentInStore,
								CommentOutStore=ts.CommentOutStore ,
								WebAddress=ts.ITEMCD,
								SetAdminCD=0, 
								SetItemCD=Null,	
								SetSKUCD=Null,		--ts.SetSKUCD,
								SetSU=0,   --ts.SetSU,
								ExhibitionSegmentCD=ts.ExhibitionSegmentCD,
								OrderLot=1,
								ExhibitionCommonCD=Null,	--ts.ExhibitionCommonCD,
								ApprovalDate=ts.ApprovalDate,
								DeleteFlg=IsNull(ts.DeleteFlg,0),
								UsedFlg=0,			--ts.UsedFlg,
								SKSUpdateFlg=1,		--ts.SKSUpdateFlg,
								SKSUpdateDateTime=Null,		--ts.SKSUpdateDateTime,
								InsertOperator=@OperatorCD,
								InsertDateTime=getdate(),
								UpdateOperator=@OperatorCD,
								UpdateDateTime=getdate() 
								from M_SKU as ms
								inner join #tmpSKU2_N  as ts on ts.LastNO =ms.AdminNO
								inner join M_Item as mi on mi.ItemCD = ms.ItemCD and mi.ChangeDate = ms.ChangeDate
								where ms.ChangeDate=ts.ChangeDate

		Delete mj
			from M_JANOrderPrice as mj
			
			Where mj.AdminNO In
			(
			Select ms.AdminNO 
			from M_SKU as ms
			Inner join #tmpSKU2_N as ts on ts.LastNO= ms.AdminNO
			where ms.ItemCD=ts.ITEMCD
			)

		Insert 
			Into M_JANOrderPrice
			Select
			MainVendorCD,
			'0000',
			LastNO,
			ChangeDate,
			SKUCD,
			IsNull(Rate,0),
			IsNull(OrderPriceWithoutTax,0),
			Null,
			IsNull(DeleteFlg,0),
			0,
			@OperatorCD,
			getdate(),
			@OperatorCD,
			getdate()
			from #tmpSKU2_N
			where MainVendorCD is not Null


		--M_SKUPrice
		Update mp 
        set 
                 mp.PriceWithTax = ts.PriceWithTax
                ,mp.PriceWithoutTax = ts.PriceOutTax
                ,mp.UpdateOperator = @OperatorCD
                ,mp.UpdateDateTime = @SysDatetime
                from M_SKUPrice mp
                inner join M_SKU ms on ms.AdminNO = mp.AdminNO and ms.ChangeDate = mp.ChangeDate
                inner join #tmpSKU2_N ts on ts.LastNO = ms.AdminNO and ts.ChangeDate = ms.ChangeDate

		Insert into M_SKUPrice
        Select
			    '0000000000000' 
			    ,'0000' 
			    ,ts.LastNO
			    ,ts.SKUCD
			    ,ts.ChangeDate
			    ,null
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,null
			    ,0
			    ,0
			    ,@OperatorCD
			    ,@SysDatetime
			    ,@OperatorCD
			    ,@SysDatetime
		        from #tmpSKU2_N ts 
                inner join M_SKU ms on ms.AdminNO = ts.LastNO and ms.ChangeDate = ts.ChangeDate
		        where not exists(select * 
				                 from M_SKUPrice mp 
                                 where mp.AdminNO = ts.LastNO and mp.ChangeDate = ts.ChangeDate
								 )


        --M_ITEM
        Update item 
        set
                SizeCount      = cnt.SizeCount,
                ColorCount     = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join
				(   select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU2_N t on t.LastNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply
				(   select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


	drop table #tmpSKU2
	drop table #tmpSKU2_N

	  End 

	if @type =3    --【attribute】
		Begin
		 Create table [#tmpSKU3](
			[AdminNO] [varchar](50) NOT NULL,
			[ChangeDate] [date] NOT NULL,
			[ApprovalDate] [date] NULL,
			[SKUCD] [varchar](40) NULL,
			[JanCD] [varchar](13) NULL,
			[DeleteFlg] [tinyint] NULL,
			[SKUName] [varchar](100) NULL,
			[ITEMCD] [varchar](30) NULL,
			[SizeNO] [int] NULL,
			[ColorNO] [int] NULL,
			[SizeName] [varchar](32) NULL,
			[ColorName] [varchar](32) NULL,
			[MainVendorCD] [varchar](13) NULL,
			[VendorName] [varchar](50) NULL,
			[SetKBN] [tinyint] NULL,
			[PresentKBN] [tinyint] NULL,
			[SampleKBN] [tinyint] NULL,
			[DiscountKBN] [tinyint] NULL,
			[WebFlg] [tinyint] NULL,
			[RealStoreFlg] [tinyint] NULL,
			[ZaikoKBN] [tinyint] NULL,
			[VirtualFlg] [tinyint] NULL,
			[DirectFlg] [tinyint] NULL,
			[ReserveCD] [varchar](3) NULL,
			[NoticesCD] [varchar](3) NULL,
			[PostageCD] [varchar](3) NULL,
			[ManufactCD] [varchar](3) NULL,
			[ConfirmCD] [varchar](3) NULL,
			[WebStockFlg] [tinyint] NULL,
			[StopFlg] [tinyint] NULL,
			[DiscontinueFlg] [tinyint] NULL,
			[SoldOutFlg] [tinyint] NULL,
			[InventoryAddFlg] [tinyint] NULL,
			[MakerAddFlg] [tinyint] NULL,
			[StoreAddFlg] [tinyint] NULL,
			[NoNetOrderFlg] [tinyint] NULL,
			[EDIOrderFlg] [tinyint] NULL,
			[AutoOrderFlg] [tinyint] NULL,
			[CatalogFlg] [tinyint] NULL,
			[ParcelFlg] [tinyint] NULL,
			[SaleExcludedFlg] [tinyint] NULL,
			[NormalCost] [money] NOT NULL,
			[PriceWithTax] [money] NULL,
			[PriceOutTax] [money] NULL,
			[OrderPriceWithTax] [money] NULL,
			[OrderPriceWithoutTax] [money] NULL,
			[Rate] [decimal](5, 2) NULL,
			)

			 Create table [#tmpSKU3_N](
			[LastNo][int] NOT NULL,
			[LastJanNo][varchar](13) NULL,
			[AdminNO] [varchar](50) NOT NULL,
			[ChangeDate] [date] NOT NULL,
			[ApprovalDate] [date] NULL,
			[SKUCD] [varchar](40) NULL,
			[JanCD] [varchar](13) NULL,
			[DeleteFlg] [tinyint] NULL,
			[SKUName] [varchar](100) NULL,
			[ITEMCD] [varchar](30) NULL,
			[SizeNO] [int] NULL,
			[ColorNO] [int] NULL,
			[SizeName] [varchar](32) NULL,
			[ColorName] [varchar](32) NULL,
			[MainVendorCD] [varchar](13) NULL,
			[VendorName] [varchar](50) NULL,
			[SetKBN] [tinyint] NULL,
			[PresentKBN] [tinyint] NULL,
			[SampleKBN] [tinyint] NULL,
			[DiscountKBN] [tinyint] NULL,
			[WebFlg] [tinyint] NULL,
			[RealStoreFlg] [tinyint] NULL,
			[ZaikoKBN] [tinyint] NULL,
			[VirtualFlg] [tinyint] NULL,
			[DirectFlg] [tinyint] NULL,
			[ReserveCD] [varchar](3) NULL,
			[NoticesCD] [varchar](3) NULL,
			[PostageCD] [varchar](3) NULL,
			[ManufactCD] [varchar](3) NULL,
			[ConfirmCD] [varchar](3) NULL,
			[WebStockFlg] [tinyint] NULL,
			[StopFlg] [tinyint] NULL,
			[DiscontinueFlg] [tinyint] NULL,
			[SoldOutFlg] [tinyint] NULL,
			[InventoryAddFlg] [tinyint] NULL,
			[MakerAddFlg] [tinyint] NULL,
			[StoreAddFlg] [tinyint] NULL,
			[NoNetOrderFlg] [tinyint] NULL,
			[EDIOrderFlg] [tinyint] NULL,
			[AutoOrderFlg] [tinyint] NULL,
			[CatalogFlg] [tinyint] NULL,
			[ParcelFlg] [tinyint] NULL,
			[SaleExcludedFlg] [tinyint] NULL,
			[NormalCost] [money] NOT NULL,
			[PriceWithTax] [money] NULL,
			[PriceOutTax] [money] NULL,
			[OrderPriceWithTax] [money] NULL,
			[OrderPriceWithoutTax] [money] NULL,
			[Rate] [decimal](5, 2) NULL,
            [AdminCounter] int,
            [JancdCounter] int
			)

			declare @DocHandle3 int

			exec sp_xml_preparedocument @DocHandle3 output, @xml
			INSERT Into #tmpSKU3
			select *  FROM OPENXML (@DocHandle3, '/NewDataSet/test',2)
			with
			(
			AdminNO varchar(50),
			改定日 date,
			承認日 date ,
			SKUCD varchar(40) ,
			JANCD varchar(13),
			削除 tinyint ,
			商品名 varchar(100),
			ITEMCD varchar(30),
			サイズ枝番 int,
			カラー枝番 int,
			サイズ名 varchar(32) ,
			カラー名 varchar(32) ,
			主要仕入先CD varchar(13),
			主要仕入先名 varchar(50),
			セット品区分 tinyint,
			プレゼント品区分 tinyint ,
			サンプル品区分 tinyint ,
			値引商品区分 tinyint,
			Webストア取扱区分 tinyint ,
			実店舗取扱区分 tinyint ,
			在庫管理対象区分 tinyint ,
			架空商品区分 tinyint ,
			直送品区分 tinyint ,
			予約品区分 varchar(3) ,
			特記区分 varchar(3) ,
			送料区分 varchar(3) ,
			要加工品区分 varchar(3) ,
			要確認品区分 varchar(3) ,
			Web在庫連携区分 tinyint ,
			販売停止品区分 tinyint ,
			廃番品区分 tinyint ,
			完売品区分 tinyint ,
			自社在庫連携対象 tinyint ,
			メーカー在庫連携対象 tinyint ,
			店舗在庫連携対象 tinyint ,
			Net発注不可区分 tinyint ,
			EDI発注可能区分 tinyint ,
			自動発注対象区分 tinyint ,
			カタログ掲載有無区分 tinyint ,
			小包梱包可能区分 tinyint ,
			Sale対象外区分 tinyint ,
			標準原価 money  ,
			税抜定価 money ,
			税込定価 money ,
			発注税込価格 money ,
			発注税抜価格 money ,
			掛率 decimal(5, 2) 
			)
			exec sp_xml_removedocument @DocHandle3;

        ----------------------------------------
        --Number the AdminNO and JanCD first to prevent duplication when running concurrently.
        Update M_SKUCounter
        set @LastAdminNO = AdminNO = AdminNO + isnull((select count(*) from #tmpSKU3 where AdminNO = 'New'),0)
        where MainKEY = 1

		--仮JAN
        Update M_JANCounter
        set @LastJanCD = JanCount = JanCount + isnull((select count(*) from #tmpSKU3 where JanCD = '仮JAN'),0)
        where MainKEY = 1
		--自社JAN
        Update M_JANCounter
        set @LastJanCDJ = JanCount = JanCount + isnull((select count(*) from #tmpSKU3 where JanCD = '自社JAN'),0)
        where MainKEY = 2
		--削除JAN
        Update M_JANCounter
        set @LastJanCDD = JanCount = JanCount + isnull((select count(*) from #tmpSKU3 where JanCD = '削除JAN'),0)
        where MainKEY = 3


        Insert into [#tmpSKU3_N]
        select 
            (case when AdminNo = 'New' then @LastAdminNO - AdminCounter else AdminNo end ) as LastAdminNO,
            (case when JanCD = '仮JAN' then dbo.Fnc_SetCheckdigit(@LastJanCD - JancdCounter)
			      when JanCD = '自社JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDJ - JancdCounter)
				  when JanCD = '削除JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDD - JancdCounter)
			      else JanCD end ) as LastJanCD,
            *
            from 
            (
                select *,
                ROW_NUMBER() over (partition by AdminNO order by SKUCD desc) - 1 as AdminCounter,
                ROW_NUMBER() over (partition by JanCD order by SKUCD desc) - 1 as JancdCounter
                from #tmpSKU3
            ) f
        ----------------------------------------

			
			Update M_SKU
			Set		
					AdminNo=ts.LastNo,
					ChangeDate=ts.ChangeDate ,
					SKUCD=ts.SKUCD ,
					SKUName=ts.SKUName,
					SKUNameLong=ts.SKUName,
					ITemCD=ts.ITEMCD ,
					SizeNO=ts.SizeNO,
					ColorNO=ts.ColorNO ,
					JanCD=ts.LastJanNo ,
					SizeName=ts.SizeName,
					ColorName=ts.ColorName ,
					SizeNameLong=ts.SizeName,
					ColorNameLong=ts.ColorName ,
					--SetKBN=ts.SetKBN,
					SetKBN=mi.SetKBN,
					PresentKBN=ts.PresentKBN,
					DiscountKBN=ts.DiscountKBN,
					WebFlg=ts.WebFlg,
					RealStoreFlg=ts.RealStoreFlg,
					--ZaikoKBN=ts.ZaikoKBN,
					ZaikoKBN=mi.ZaikoKBN,
					VirtualFlg=ts.VirtualFlg,
					--DirectFlg=ts.DirectFlg,
					--ReserveCD=ts.ReserveCD,
					--NoticesCD=ts.NoticesCD,
					--PostageCD=ts.PostageCD,
					--ManufactCD=ts.ManufactCD,
					--ConfirmCD=ts.ConfirmCD,
					--WebStockFlg=ts.WebStockFlg,
					DirectFlg=mi.DirectFlg,
					ReserveCD=mi.ReserveCD,
					NoticesCD=mi.NoticesCD,
					PostageCD=mi.PostageCD,
					ManufactCD=mi.ManufactCD,
					ConfirmCD=mi.ConfirmCD,
					WebStockFlg=mi.WebStockFlg,
					StopFlg=ts.StopFlg,
					DiscontinueFlg=ts.DiscontinueFlg,
					SoldOutFlg=ts.SoldOutFlg,
					--InventoryAddFlg=ts.InventoryAddFlg,
					--MakerAddFlg=ts.MakerAddFlg,
					--StoreAddFlg=ts.StoreAddFlg,
					--NoNetOrderFlg=ts.NoNetOrderFlg,
					--EDIOrderFlg=ts.EDIOrderFlg,
					--AutoOrderFlg=ts.AutoOrderFlg,
					InventoryAddFlg=mi.InventoryAddFlg,
					MakerAddFlg=mi.MakerAddFlg,
					StoreAddFlg=mi.StoreAddFlg,
					NoNetOrderFlg=mi.NoNetOrderFlg,
					EDIOrderFlg=mi.EDIOrderFlg,
					AutoOrderFlg=mi.AutoOrderFlg,
					CatalogFlg=ts.CatalogFlg,
					ParcelFlg=ts.ParcelFlg,
					SaleExcludedFlg=ts.SaleExcludedFlg,
					NormalCost=IsNull(ts.NormalCost,0),
					PriceOutTax=IsNull(ts.PriceOutTax,0) ,
					PriceWithTax=IsNull(ts.PriceWithTax,0),
					OrderPriceWithTax=IsNull(ts.OrderPriceWithTax ,0),
					OrderPriceWithoutTax=IsNull(ts.OrderPriceWithoutTax,0),
					Rate=IsNull(ts.Rate,0),
					SetAdminCD=0, 
					SetItemCD=Null,	
					SetSKUCD=Null,		--ts.SetSKUCD,
					SetSU=0,   --ts.SetSU,
					ExhibitionCommonCD=Null,	--ts.ExhibitionCommonCD,
					ApprovalDate=ts.ApprovalDate,
					DeleteFlg=IsNull(ts.DeleteFlg,0),
					UsedFlg=0,			--ts.UsedFlg,
					SKSUpdateFlg=1,		--ts.SKSUpdateFlg,
					SKSUpdateDateTime=Null,		--ts.SKSUpdateDateTime,
					InsertOperator=@OperatorCD,
					InsertDateTime=getdate(),
					UpdateOperator=@OperatorCD,
					UpdateDateTime=getdate() 
					from M_SKU as ms
					inner join #tmpSKU3_N  as ts on ts.LastNo =ms.AdminNO
					inner join M_Item as mi on mi.ItemCD = ms.ItemCD and mi.ChangeDate = ms.ChangeDate
					where ms.ChangeDate=ts.ChangeDate
			
			Delete mj
							from M_JANOrderPrice as mj
							
							Where mj.AdminNO In 
							(
							Select ms.AdminNO 
							from M_SKU as ms
							Inner join #tmpSKU3_N as ts on ts.LastNo= ms.AdminNO
							where ms.ItemCD=ts.ITEMCD
							)
			Insert 
					Into	 M_JANOrderPrice
					Select
						    MainVendorCD,
							'0000',
							LastNo,
							ChangeDate,
							SKUCD,
							IsNull(Rate,0),
							IsNull(OrderPriceWithoutTax,0),
							Null,
							IsNull(DeleteFlg,0),
							0,
							@OperatorCD,
							getdate(),
							@OperatorCD,
							getdate()
							from #tmpSKU3_N
							where MainVendorCD is not Null


			--M_SKUPrice
			Update mp 
			set 
                 mp.PriceWithTax = ts.PriceWithTax
                ,mp.PriceWithoutTax = ts.PriceOutTax
                ,mp.UpdateOperator = @OperatorCD
                ,mp.UpdateDateTime = @SysDatetime
                from M_SKUPrice mp
                inner join M_SKU ms on ms.AdminNO = mp.AdminNO and ms.ChangeDate = mp.ChangeDate
                inner join #tmpSKU3_N ts on ts.LastNO = ms.AdminNO and ts.ChangeDate = ms.ChangeDate

			Insert into M_SKUPrice
			Select
			    '0000000000000' 
			    ,'0000' 
			    ,ts.LastNO
			    ,ts.SKUCD
			    ,ts.ChangeDate
			    ,null
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,null
			    ,0
			    ,0
			    ,@OperatorCD
			    ,@SysDatetime
			    ,@OperatorCD
			    ,@SysDatetime
		        from #tmpSKU3_N ts 
                inner join M_SKU ms on ms.AdminNO = ts.LastNO and ms.ChangeDate = ts.ChangeDate
		        where not exists(select * 
				                 from M_SKUPrice mp 
                                 where mp.AdminNO = ts.LastNO and mp.ChangeDate = ts.ChangeDate
								 )


			--M_ITEM
			Update item 
			set
                SizeCount      = cnt.SizeCount,
                ColorCount     = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join
				(   select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU3_N t on t.LastNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply
				(   select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


			drop table #tmpSKU3
			drop table #tmpSKU3_N
	End

	if @type =4    --【Price】
		Begin
			Create table [#tmpSKU4](
		[AdminNO] [varchar](50) NOT NULL,
		[ChangeDate] [date] NOT NULL,
		[ApprovalDate] [date] NULL,
		[SKUCD] [varchar](40) NULL,
		[JanCD] [varchar](13) NULL,
		[DeleteFlg] [tinyint] NULL,
		[SKUName] [varchar](100) NULL,
		[ITEMCD] [varchar](30) NULL,
		[SizeNO] [int] NULL,
		[ColorNO] [int] NULL,
		[SizeName] [varchar](32) NULL,
		[ColorName] [varchar](32) NULL,
		[MainVendorCD] [varchar](13) NULL,
		[VendorName] [varchar](50) NULL,
		[TaxRateFLG] [tinyint] NULL,
		[CostingKBN] [tinyint] NULL,
		[SaleExcludedFlg] [tinyint] NULL,
		[NormalCost] [money] NOT NULL,
		[PriceWithTax] [money] NULL,
		[PriceOutTax] [money] NULL,
		[OrderPriceWithTax] [money] NULL,
		[OrderPriceWithoutTax] [money] NULL,
		[Rate] [decimal](5, 2) NULL,
		)

			Create table [#tmpSKU4_N](
		[LastNo][int] Not Null,
		[AdminNO] [varchar](50) NOT NULL,
		[ChangeDate] [date] NOT NULL,
		[ApprovalDate] [date] NULL,
		[SKUCD] [varchar](40) NULL,
		[JanCD] [varchar](13) NULL,
		[DeleteFlg] [tinyint] NULL,
		[SKUName] [varchar](100) NULL,
		[ITEMCD] [varchar](30) NULL,
		[SizeNO] [int] NULL,
		[ColorNO] [int] NULL,
		[SizeName] [varchar](32) NULL,
		[ColorName] [varchar](32) NULL,
		[MainVendorCD] [varchar](13) NULL,
		[VendorName] [varchar](50) NULL,
		[TaxRateFLG] [tinyint] NULL,
		[CostingKBN] [tinyint] NULL,
		[SaleExcludedFlg] [tinyint] NULL,
		[NormalCost] [money] NOT NULL,
		[PriceWithTax] [money] NULL,
		[PriceOutTax] [money] NULL,
		[OrderPriceWithTax] [money] NULL,
		[OrderPriceWithoutTax] [money] NULL,
		[Rate] [decimal](5, 2) NULL,
		[RowNo][int] Null
		)

		declare @DocHandle4 int

		exec sp_xml_preparedocument @DocHandle4 output, @xml
		INSERT Into #tmpSKU4
		select *  FROM OPENXML (@DocHandle4, '/NewDataSet/test',2)
		with
		(
		AdminNO varchar(50),
		改定日 date,
		承認日 date ,
		SKUCD varchar(40) ,
		JANCD varchar(13),
		削除 tinyint ,
		商品名 varchar(100),
		ITEMCD varchar(30),
		サイズ枝番 int,
		カラー枝番 int,
		サイズ名 varchar(32) ,
		カラー名 varchar(32) ,
		主要仕入先CD varchar(13) ,
		主要仕入先名 varchar(50),
		税率区分 tinyint,
		原価計算方法 tinyint,
		Sale対象外区分 tinyint ,
		標準原価 money  ,
		税抜定価 money ,
		税込定価 money ,
		発注税込価格 money ,
		発注税抜価格 money ,
		掛率 decimal(5, 2) 
		)
		exec sp_xml_removedocument @DocHandle4;


		declare @AdminCounter4 as int = (select Max (AdminNo) from M_SKUCounter where MainKEY = 1);

								Insert into [#tmpSKU4_N]
								select (case when AdminNo = 'New' then @AdminCounter4+ RowNo else AdminNo end ) as LastNo , *  from 
								 (select  * ,   (ROW_NUMBER () Over (order by AdminNo desc)) as RowNo
								from #tmpSKU4 ) f


								declare @LastNO4 as int =0;

								SEt @LastNO4=(SElect MAX(LastNo) from #tmpSKU4_N where AdminNO='New');
								Update M_SKUCounter
								Set AdminNO=@LastNO4
								where @LastNO4 <> 0
		
		    Update M_SKU
		    Set		
	    		AdminNO=ts.LastNo,
		    	ChangeDate=ts.ChangeDate,
		    	--TaxRateFLG=ts.TaxRateFLG,
		    	--CostingKBN=ts.CostingKBN,
				TaxRateFLG=mi.TaxRateFLG,
				CostingKBN=mi.CostingKBN,
		    	SaleExcludedFlg=ts.SaleExcludedFlg,
	    		NormalCost=IsNull(ts.NormalCost,0),
	    		PriceOutTax=IsNull(ts.PriceOutTax,0),
		    	PriceWithTax=IsNull(ts.PriceWithTax,0),
		    	OrderPriceWithTax=IsNull(ts.OrderPriceWithTax,0),
		    	OrderPriceWithoutTax=IsNull(ts.OrderPriceWithoutTax,0),
		    	Rate=IsNull(ts.Rate,0),
		    	ApprovalDate=ts.ApprovalDate,
		    	DeleteFlg=ts.DeleteFlg,
		    	UsedFlg=0,
		    	SKSUpdateFlg=1,
		    	SKSUpdateDateTime=Null,
		    	InsertOperator=@OperatorCD,
		    	InsertDateTime=getdate(),
		    	UpdateOperator=@OperatorCD,
		    	UpdateDateTime=getdate()
			from M_SKU as ms
			inner join #tmpSKU4_N  as ts on ts.LastNo =ms.AdminNO
			inner join M_Item as mi on mi.ItemCD = ms.ItemCD and mi.ChangeDate = ms.ChangeDate
			where ms.ChangeDate=ts.ChangeDate

		    Delete mj
		    from M_JANOrderPrice as mj
							
		    Where mj.AdminNO  In 
							(
							Select ms.AdminNO 
							from M_SKU ms
							Inner join #tmpSKU4_N as ts on ts.LastNo= ms.AdminNO
							where ms.ItemCD=ts.ITEMCD
							)
		    Insert 
		    Into	 M_JANOrderPrice
		    Select
						    MainVendorCD,
							'0000',
							LastNo,
							ChangeDate,
							SKUCD,
							IsNull(Rate,0),
							IsNull(OrderPriceWithoutTax,0),
							Null,
							IsNull(DeleteFlg,0),
							0,
							@OperatorCD,
							getdate(),
							@OperatorCD,
							getdate()
			from #tmpSKU4_N
			where MainVendorCD is not Null


			--M_SKUPrice
			Update mp 
			set 
                 mp.PriceWithTax = ts.PriceWithTax
                ,mp.PriceWithoutTax = ts.PriceOutTax
                ,mp.UpdateOperator = @OperatorCD
                ,mp.UpdateDateTime = @SysDatetime
                from M_SKUPrice mp
                inner join M_SKU ms on ms.AdminNO = mp.AdminNO and ms.ChangeDate = mp.ChangeDate
                inner join #tmpSKU4_N ts on ts.LastNO = ms.AdminNO and ts.ChangeDate = ms.ChangeDate

			Insert into M_SKUPrice
			Select
			    '0000000000000' 
			    ,'0000' 
			    ,ts.LastNO
			    ,ts.SKUCD
			    ,ts.ChangeDate
			    ,null
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,100
			    ,ts.PriceWithTax
			    ,ts.PriceOutTax
			    ,null
			    ,0
			    ,0
			    ,@OperatorCD
			    ,@SysDatetime
			    ,@OperatorCD
			    ,@SysDatetime
		        from #tmpSKU4_N ts 
                inner join M_SKU ms on ms.AdminNO = ts.LastNO and ms.ChangeDate = ts.ChangeDate
		        where not exists(select * 
				                 from M_SKUPrice mp 
                                 where mp.AdminNO = ts.LastNO and mp.ChangeDate = ts.ChangeDate
								 )


			--M_ITEM
			Update item 
			set
                SizeCount      = cnt.SizeCount,
                ColorCount     = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join
				(   select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU4_N t on t.LastNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply
				(   select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


		drop table #tmpSKU4
		drop table #tmpSKU4_N




		End

	if @type =5     --【Catalog】
	Begin
		 Create table [#tmpSKU5](
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NOT NULL,
	[ApprovalDate] [date] NULL,
	[SKUCD] [varchar](40) NULL,
	[JanCD] [varchar](13) NULL,
	[DeleteFlg] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL,
	[LastYearTerm] [varchar](6) NULL,
	[LastSeason] [varchar](6) NULL,
	[LastCatalogNO] [varchar](20) NULL,
	[LastCatalogPage] [varchar](20) NULL,
	[LastCatalogNOLong] [varchar](2000) NULL,
	[LastCatalogPageLong] [varchar](2000) NULL,
	[LastCatalogText] [varchar](1000) NULL,
	[LastInstructionsNO] [varchar](1000) NULL,
	[LastInstructionsDate] [date] NULL,
	) 

			Create table [#tmpSKU5_N](
	[LastNo][int] Not Null,
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NOT NULL,
	[ApprovalDate] [date] NULL,
	[SKUCD] [varchar](40) NULL,
	[JanCD] [varchar](13) NULL,
	[DeleteFlg] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL,
	[LastYearTerm] [varchar](6) NULL,
	[LastSeason] [varchar](6) NULL,
	[LastCatalogNO] [varchar](20) NULL,
	[LastCatalogPage] [varchar](20) NULL,
	[LastCatalogNOLong] [varchar](2000) NULL,
	[LastCatalogPageLong] [varchar](2000) NULL,
	[LastCatalogText] [varchar](1000) NULL,
	[LastInstructionsNO] [varchar](1000) NULL,
	[LastInstructionsDate] [date] NULL,
	[RowNo][int] Null
	)


	declare @DocHandle5 int

	exec sp_xml_preparedocument @DocHandle5 output, @xml
	INSERT Into #tmpSKU5
	select *  FROM OPENXML (@DocHandle5, '/NewDataSet/test',2)
	with
	(
	AdminNO varchar(50),
	改定日 date,
	承認日 date ,
	SKUCD varchar(40) ,
	JANCD varchar(13),
	削除 tinyint ,
	商品名 varchar(100),
	ITEMCD varchar(30),
	サイズ枝番 int,
	カラー枝番 int,
	サイズ名 varchar(32) ,
	カラー名 varchar(32) ,
	年度 varchar(6) ,
	シーズン varchar(6) ,
	カタログ番号 varchar(20) ,
	カタログページ varchar(20) ,
	カタログ番号Long varchar(2000) ,
	カタログページLong varchar(2000) ,
	カタログ情報 varchar(1000),
	指示書番号 varchar(1000),
	指示書発行日 date
	)
	exec sp_xml_removedocument @DocHandle5;
		declare @AdminCounter5 as int = (select Max (AdminNo) from M_SKUCounter where MainKEY = 1);

								Insert into [#tmpSKU5_N]
								select (case when AdminNo = 'New' then @AdminCounter5+ RowNo else AdminNo end ) as LastNo , *  from 
								 (select  * ,   (ROW_NUMBER () Over (order by AdminNo desc)) as RowNo
								from #tmpSKU5  ) f
							

								
								declare @LastNO5 as int =0;

								SEt @LastNO5=(SElect MAX(LastNo) from #tmpSKU5_N where AdminNO='New');
								Update M_SKUCounter
								Set AdminNO=@LastNO5
								where @LastNO5 <> 0
	
	
	Update M_SKU
	Set		
			AdminNO=ts.LastNo,
			ChangeDate=ts.ChangeDate,
			LastYearTerm=ts.LastYearTerm,
			LastSeason=ts.LastSeason,
			LastCatalogNO=ts.LastCatalogNO ,
			LastCatalogPage=ts.LastCatalogPage,
			LastCatalogNOLong=ts.LastCatalogNOLong,
			LastCatalogPageLong=ts.LastCatalogPageLong ,
			LastCatalogText=ts.LastCatalogText,
			LastInstructionsNO=ts.LastInstructionsNO,
			LastInstructionsDate=ts.LastInstructionsDate,
			ApprovalDate=ts.ApprovalDate,
			DeleteFlg=IsNull(ts.DeleteFlg,0),
			UsedFlg=0,
			SKSUpdateFlg=1,
			SKSUpdateDateTime=Null,
			InsertOperator=@OperatorCD,
			InsertDateTime=getdate(),
			UpdateOperator=@OperatorCD,
			UpdateDateTime=getdate()
			from M_SKU as ms
			inner join #tmpSKU5_N as ts on ts.LastNo =ms.AdminNO
			where ms.ChangeDate=ts.ChangeDate
		

		
		Insert into M_SKUInfo
		Select 
		LastNo,
		ChangeDate,
		1,
		LastYearTerm,
		LastSeason,
		LastCatalogNO,
		LastCatalogPage,
		LastCatalogText,
		LastInstructionsNO,
		LastInstructionsDate,
		DeleteFlg,
		@OperatorCD,
		getdate(),
		@OperatorCD,
		getdate()
		From #tmpSKU5_N as ts
		Where not Exists(
					Select  AdminNO
					from M_SKUInfo as mi
					where mi.AdminNO=ts.LastNo
					and mi.ChangeDate= ts.ChangeDate
					and mi.SEQ=1
				)
		
		Update M_SKUInfo
		Set
		AdminNO=ts.LastNo,
		ChangeDate=ts.ChangeDate,
		SEQ=1,
		YearTerm=ts.LastYearTerm,
		Season=ts.LastSeason,
		CatalogNO=ts.LastCatalogNO,
		CatalogPage=ts.LastCatalogPage,
		CatalogText=ts.LastCatalogText,
		InstructionsNO=ts.LastInstructionsNO,
		InstructionsDate=ts.LastInstructionsDate,
		DeleteFlg=ts.DeleteFlg,
		InsertOperator=@OperatorCD,
		InsertDateTime=getdate(),
		UpdateOperator=@OperatorCD,
		UpdateDateTime=getdate()
		From M_SKUInfo as mI
		inner join #tmpSKU5_N as ts on ts.LastNo=mI.AdminNO
		where mI.AdminNO= ts.LastNo
		and mI.ChangeDate=ts.ChangeDate
		and mI.SEQ= 1


			--M_ITEM
			Update item 
			set
                SizeCount      = cnt.SizeCount,
                ColorCount     = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join
				(   select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU5_N t on t.LastNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply
				(   select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


	drop table #tmpSKU5
	drop table #tmpSKU5_N

	End  

	if @type=6    --【Tag】
	Begin 
	  Create table [#tmpSKU6](
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NOT NULL,
	[ApprovalDate] [date] NULL,
	[SKUCD] [varchar](40) NULL,
	[JanCD] [varchar](13) NULL,
	[DeleteFlg] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL,
	[TagName1] [varchar](40) NULL,
	[TagName2] [varchar](40) NULL,
	[TagName3] [varchar](40) NULL,
	[TagName4] [varchar](40) NULL,
	[TagName5] [varchar](40) NULL,
	[TagName6] [varchar](40) NULL,
	[TagName7] [varchar](40) NULL,
	[TagName8] [varchar](40) NULL,
	[TagName9] [varchar](40) NULL,
	[TagName10] [varchar](40) NULL,
	)

 Create table [#tmpSKU6_N](
	[LastNo][int] NOT NULL,
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NOT NULL,
	[ApprovalDate] [date] NULL,
	[SKUCD] [varchar](40) NULL,
	[JanCD] [varchar](13) NULL,
	[DeleteFlg] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL,
	[TagName1] [varchar](40) NULL,
	[TagName2] [varchar](40) NULL,
	[TagName3] [varchar](40) NULL,
	[TagName4] [varchar](40) NULL,
	[TagName5] [varchar](40) NULL,
	[TagName6] [varchar](40) NULL,
	[TagName7] [varchar](40) NULL,
	[TagName8] [varchar](40) NULL,
	[TagName9] [varchar](40) NULL,
	[TagName10] [varchar](40) NULL,
	[RowNo][int] NUll,
	)
	declare @DocHandle6 int

	exec sp_xml_preparedocument @DocHandle6 output, @xml
	INSERT Into #tmpSKU6
	select *  FROM OPENXML (@DocHandle6, '/NewDataSet/test',2)
	with
	(
	AdminNO varchar(50),
	改定日 date,
	承認日 date ,
	SKUCD varchar(40) ,
	JANCD varchar(13),
	削除 tinyint ,
	商品名 varchar(100),
	ITEM varchar(30),
	サイズ枝番 int,
	カラー枝番 int,
	サイズ名 varchar(32) ,
	カラー名 varchar(32) ,
	タグ1  varchar(40) ,
	タグ2  varchar(40) ,
	タグ3  varchar(40) ,
	タグ4 varchar(40) ,
	タグ5  varchar(40) ,
	タグ6  varchar(40) ,
	タグ7  varchar(40),
	タグ8 varchar(40),
	タグ9 varchar(40),
	タグ10 varchar(40)
	)
	exec sp_xml_removedocument @DocHandle6;

	        declare @AdminCounter6 as int = (select Max (AdminNo) from M_SKUCounter where MainKEY = 1);

			Insert into [#tmpSKU6_N]
					select (case when AdminNo = 'New' then @AdminCounter6+ RowNo else AdminNo end ) as LastNo , *  from (select  * ,   (ROW_NUMBER () Over (order by AdminNo desc)) as RowNo
					from #tmpSKU6  ) f


							
			declare @LastNO6 as int =0;

			Set @LastNO6=(SElect MAX(LastNo) from #tmpSKU6_N where AdminNO='New');

			Update M_SKUCounter
			Set AdminNO=@LastNO6
			where @LastNO6 <> 0
	
	
	        Update M_SKU
    	        Set		
		        	AdminNO=ts.LastNo,
	    	    	ChangeDate=ts.ChangeDate,
		        	ApprovalDate=ts.ApprovalDate,
		        	DeleteFlg=IsNull(ts.DeleteFlg,0),
		        	UsedFlg=0,
		        	SKSUpdateFlg=1,
		        	SKSUpdateDateTime=Null,
		        	InsertOperator=@OperatorCD,
		        	InsertDateTime=getdate(),
		        	UpdateOperator=@OperatorCD,
		        	UpdateDateTime=getdate()
			from M_SKU as ms
			inner join #tmpSKU6_N as ts on ts.LastNo =ms.AdminNO
			where ms.ChangeDate=ts.ChangeDate


		    --M_TAG
		    Delete mtag
    		from M_SKUTag as mtag
	    	inner join #tmpSKU6_N as ts on ts.LastNo=mtag.AdminNO
	    	Where mtag.AdminNO=ts.LastNo
    		and mtag.ChangeDate=ts.ChangeDate
		
	    	Insert Into M_SKUTag
		    SELECT LastNo,ChangeDate,ROW_NUMBER() OVER (PARTITION BY LastNo ORDER BY LastNo),ColumnValue 
		    FROM #tmpSKU6_N as ts
	    	Unpivot(ColumnValue For ColumnName IN (TagName1,TagName2,TagName3,TagName4,TagName5,TagName6,TagName7,TagName8,TagName9,TagName10)) AS H


		 	--M_ITEM
			Update item 
			set
                SizeCount      = cnt.SizeCount,
                ColorCount     = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join
				(   select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU6_N t on t.LastNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply
				(   select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


	    drop table #tmpSKU6
	    drop table #tmpSKU6_N
	End

	if @type = 7    --【JANCD】
  begin
	CREATE TABLE [dbo].[#tmpSKU7](
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NULL,
	[ApprovalDate] [date]  NULL,
	[SKUCD] [varchar](40) NULL,
	[JANCD] [varchar](13) NULL,
	[DeleteFlg] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[KanaName] [varchar](50) NULL,
	[SKUShortName] [varchar](40) NULL,
	[EnglishName] [varchar](80) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL
	) 

	CREATE TABLE [dbo].[#tmpSKU7_N](
	[LastNo][int] NOT NUll,
	[LastJanNo][varchar](13)Null,
	[AdminNO] [varchar](50) NOT NULL,
	[ChangeDate] [date] NULL,
	[ApprovalDate] [date]  NULL,
	[SKUCD] [varchar](40) NULL,
	[JANCD] [varchar](13) NULL,
	[DeleteFlg] [tinyint] NULL,
	[SKUName] [varchar](100) NULL,
	[KanaName] [varchar](50) NULL,
	[SKUShortName] [varchar](40) NULL,
	[EnglishName] [varchar](80) NULL,
	[ITEMCD] [varchar](30) NULL,
	[SizeNO] [int] NULL,
	[ColorNO] [int] NULL,
	[SizeName] [varchar](32) NULL,
	[ColorName] [varchar](32) NULL,
    [AdminCounter] int,
    [JancdCounter] int
	)

	declare @DocHandle7 int

	exec sp_xml_preparedocument @DocHandle7 output, @xml
	insert into #tmpSKU7
	select *  FROM OPENXML (@DocHandle7, '/NewDataSet/test',2)
	with
	(
	AdminNO varchar(50),
	改定日  date,
	承認日 date,
	SKUCD varchar(40),
	JANCD varchar(13),
	削除 tinyint,
	商品名 varchar(100),
	カナ名 varchar(50),
	略名 varchar(40),
	英語名 varchar(80),
	ITEMCD varchar(30),
	サイズ枝番 int,
	カラー枝番 int,
	サイズ名 varchar(32),
	カラー名 varchar(32)
	)
exec sp_xml_removedocument @DocHandle7;
		
        ----------------------------------------
        --Number the AdminNO and JanCD first to prevent duplication when running concurrently.
        Update M_SKUCounter
        set @LastAdminNO = AdminNO = AdminNO + isnull((select count(*) from #tmpSKU7 where AdminNO = 'New'),0)
        where MainKEY = 1

		--仮JAN
        Update M_JANCounter
        set @LastJanCD = JanCount = JanCount + isnull((select count(*) from #tmpSKU7 where JanCD = '仮JAN'),0)
        where MainKEY = 1
		--自社JAN
        Update M_JANCounter
        set @LastJanCDJ = JanCount = JanCount + isnull((select count(*) from #tmpSKU7 where JanCD = '自社JAN'),0)
        where MainKEY = 2
		--削除JAN
        Update M_JANCounter
        set @LastJanCDD = JanCount = JanCount + isnull((select count(*) from #tmpSKU7 where JanCD = '削除JAN'),0)
        where MainKEY = 3


        Insert into [#tmpSKU7_N]
        select 
            (case when AdminNo = 'New' then @LastAdminNO - AdminCounter else AdminNo end ) as LastAdminNO,
            (case when JanCD = '仮JAN' then dbo.Fnc_SetCheckdigit(@LastJanCD - JancdCounter)
			      when JanCD = '自社JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDJ - JancdCounter)
				  when JanCD = '削除JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDD - JancdCounter)
			      else JanCD end ) as LastJanCD,
            *
            from 
            (
                select *,
                ROW_NUMBER() over (partition by AdminNO order by SKUCD desc) - 1 as AdminCounter,
                ROW_NUMBER() over (partition by JanCD order by SKUCD desc) - 1 as JancdCounter
                from #tmpSKU7
            ) f
        ----------------------------------------
													

		
		Update	M_SKU
			SET	SKUName=ts.SKUName,
				SKUNameLong=ts.SKUName,
				KanaName=ts.KanaName,
				EnglishName=ts.EnglishName,
				SKUShortName=IsNull(ts.SKUShortName,LEFT(ts.SKUName,40)),
				JanCD=ts.LastJanNo,
				ITemCD=ts.ITEMCD,
				SizeNO=ts.SizeNO,
				ColorNO=ts.ColorNo,
				ApprovalDate=ts.ApprovalDate,--ts.ApprovalDate,
				DeleteFlg=IsNull(ts.DeleteFlg,0),
				UsedFlg=0,  --ts.UsedFlg,
				SKSUpdateFlg=1,		--ts.SKSUpdateFlg,
				SKSUpdateDateTime=Null,			--ts.SKSUpdateDateTime,
				InsertOperator='0001' ,    --ts.InsertOperator,
				InsertDateTime=getdate(),			--ts.InsertDateTime,
				UpdateOperator='0001'	,		--ts.UpdateOperator,
				UpdateDateTime=getdate()	
		from M_SKU as ms
		inner join #tmpSKU7_N  as ts on ts.LastNo =ms.AdminNO
		where ms.ChangeDate=ts.ChangeDate


			--M_ITEM
			Update item 
			set
                SizeCount      = cnt.SizeCount,
                ColorCount     = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join
				(   select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU7_N t on t.LastNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply
				(   select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


	drop table #tmpSKU7
	drop table #tmpSKU7_N

	end

	if @type =8    --【SiteURL】
	Begin
			CREATE TABLE [dbo].[#tmpSKU8](
						[AdminNO] [varchar](50) NOT NULL,
						[ChangeDate] [date] NULL,
						[ApprovalDate] [date]  NULL,
						[SKUCD] [varchar](40) NULL,
						[JANCD] [varchar](13) NULL,
						[DeleteFlg] [tinyint] NULL,
						[SKUName] [varchar](100) NULL,
						[ITEMCD] [varchar](30) NULL,
						[SizeNO] [int] NULL,
						[ColorNO] [int] NULL,
						[SizeName] [varchar](32) NULL,
						[ColorName] [varchar](32) NULL,
						[APIKey] [varchar](20) NULL,
						[ShouhinCD] [varchar](30) NULL,
					)  

						CREATE TABLE [dbo].[#tmpSKU8_N](
						[LastNo][int] NOT NULL,
						[LastJanNo][varchar](13)Null,
						[AdminNO] [varchar](50) NOT NULL,
						[ChangeDate] [date] NULL,
						[ApprovalDate] [date]  NULL,
						[SKUCD] [varchar](40) NULL,
						[JANCD] [varchar](13) NULL,
						[DeleteFlg] [tinyint] NULL,
						[SKUName] [varchar](100) NULL,
						[ITEMCD] [varchar](30) NULL,
						[SizeNO] [int] NULL,
						[ColorNO] [int] NULL,
						[SizeName] [varchar](32) NULL,
						[ColorName] [varchar](32) NULL,
						[APIKey] [varchar](20) NULL,
						[ShouhinCD] [varchar](30) NULL,
                        [AdminCounter] int,
                        [JancdCounter] int
					)

			declare @DocHandle8 int

				exec sp_xml_preparedocument @DocHandle8 output, @xml
				insert into #tmpSKU8
				select *  FROM OPENXML (@DocHandle8, '/NewDataSet/test',2)
				with
				(
				AdminNO varchar(50),
				改定日 date,
				承認日 date,
				SKUCD varchar(40),
				JANCD varchar(13),
				削除 tinyint,
				商品名 varchar(100),
				ITEMCD varchar(30),
				サイズ枝番 int,
				カラー枝番 int,
				サイズ名 varchar(32),
				カラー名 varchar(32),
				APIKey varchar(20),
				サイト商品CD varchar(30)
				)
			exec sp_xml_removedocument @DocHandle8;

        ----------------------------------------
        --Number the AdminNO and JanCD first to prevent duplication when running concurrently.
        Update M_SKUCounter
        set @LastAdminNO = AdminNO = AdminNO + isnull((select count(*) from #tmpSKU8 where AdminNO = 'New'),0)
        where MainKEY = 1

		--仮JAN
        Update M_JANCounter
        set @LastJanCD = JanCount = JanCount + isnull((select count(*) from #tmpSKU8 where JanCD = '仮JAN'),0)
        where MainKEY = 1
		--自社JAN
        Update M_JANCounter
        set @LastJanCDJ = JanCount = JanCount + isnull((select count(*) from #tmpSKU8 where JanCD = '自社JAN'),0)
        where MainKEY = 2
		--削除JAN
        Update M_JANCounter
        set @LastJanCDD = JanCount = JanCount + isnull((select count(*) from #tmpSKU8 where JanCD = '削除JAN'),0)
        where MainKEY = 3


        Insert into [#tmpSKU8_N]
        select 
            (case when AdminNo = 'New' then @LastAdminNO - AdminCounter else AdminNo end ) as LastAdminNO,
            (case when JanCD = '仮JAN' then dbo.Fnc_SetCheckdigit(@LastJanCD - JancdCounter)
			      when JanCD = '自社JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDJ - JancdCounter)
				  when JanCD = '削除JAN' then dbo.Fnc_SetCheckdigit(@LastJanCDD - JancdCounter)
			      else JanCD end ) as LastJanCD,
            *
            from 
            (
                select *,
                ROW_NUMBER() over (partition by AdminNO order by SKUCD desc) - 1 as AdminCounter,
                ROW_NUMBER() over (partition by JanCD order by SKUCD desc) - 1 as JancdCounter
                from #tmpSKU8
            ) f
        ----------------------------------------
			
	
	        --【M_SKU】
	        Update	M_SKU
			SET	JanCD=ts.LastJanNo,
				ApprovalDate=ts.ApprovalDate,--ts.ApprovalDate,
				DeleteFlg=IsNull(ts.DeleteFlg,0),
				UsedFlg=0,  --ts.UsedFlg,
				SKSUpdateFlg=1,		--ts.SKSUpdateFlg,
				SKSUpdateDateTime=Null,			--ts.SKSUpdateDateTime,
				InsertOperator=@OperatorCD ,    --ts.InsertOperator,
				InsertDateTime=getdate(),			--ts.InsertDateTime,
				UpdateOperator=@OperatorCD	,		--ts.UpdateOperator,
				UpdateDateTime=getdate()	
		    from M_SKU as ms
		    inner join #tmpSKU8_N  as ts on ts.LastNo =ms.AdminNO
		    where ms.ChangeDate=ts.ChangeDate


			--【M_Site】
			DELETE sit
			FROM M_Site sit
			INNER JOIN #tmpSKU8_N tmp
			ON tmp.LastNO = sit.AdminNO
			;
	
			Insert into M_Site
			Select 
				ts.LastNo,
				ts.APIKey,
				ts.ShouhinCD,
				ISNULL(mp.ShopURL,'') +ts.ShouhinCD + '.html',
				@OperatorCD,
				getdate(),
				@OperatorCD,
				getdate()
				from #tmpSKU8_N as ts
				inner join F_API(getdate()) mp on mp.APIKey = ts.APIKey
				;


			--【M_ITEM】
			Update item 
			set
                SizeCount      = cnt.SizeCount,
                ColorCount     = cnt.ColorCount,
                UpdateOperator = @OperatorCD,
                UpdateDateTime = @SysDatetime

                from M_ITEM item
                inner join
				(   select ms.ITemCD, ms.ChangeDate 
                    from M_SKU ms
                    inner join #tmpSKU8_N t on t.LastNO = ms.AdminNO and t.ChangeDate = ms.ChangeDate
                    group by ms.ITemCD, ms.ChangeDate 
                ) itemKey
                on itemKey.ITemCD = item.ITemCD and itemKey.ChangeDate = item.ChangeDate
                cross apply
				(   select
                    count(*) over (partition by ms.ColorNO) as SizeCount,
                    count(*) over (partition by ms.SizeNO)  as ColorCount
                    from M_SKU ms
                    where ms.ITemCD = item.ITemCD AND ms.ChangeDate = item.ChangeDate
                ) cnt


			drop table #tmpSKU8
			drop table #tmpSKU8_N
	End
	
	  exec dbo.L_Log_Insert @OperatorCD,@ProgramID,@PC,Null,@KeyItem
	
END
