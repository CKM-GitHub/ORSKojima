IF EXISTS (select * from sys.table_types where user_type_id = Type_id(N'T_ItemImport'))
BEGIN
    IF EXISTS (select * from sys.objects where name = '_Item_Item')
        DROP PROCEDURE [_Item_Item]

    IF EXISTS (select * from sys.objects where name = '_Item_ItemPrice')
        DROP PROCEDURE [_Item_ItemPrice]

    IF EXISTS (select * from sys.objects where name = '_Item_ItemOrderPrice')
        DROP PROCEDURE [_Item_ItemOrderPrice]

    IF EXISTS (select * from sys.objects where name = '_Item_ItemOrderPrice2')
        DROP PROCEDURE [_Item_ItemOrderPrice2]

    IF EXISTS (select * from sys.objects where name = '_Item_SKU')
        DROP PROCEDURE [_Item_SKU]

    IF EXISTS (select * from sys.objects where name = '_Item_SKUInfo')
        DROP PROCEDURE [_Item_SKUInfo]

    IF EXISTS (select * from sys.objects where name = '_Item_SKUTag')
        DROP PROCEDURE [_Item_SKUTag]

    IF EXISTS (select * from sys.objects where name = '_Item_SKUPrice')
        DROP PROCEDURE [_Item_SKUPrice]

    IF EXISTS (select * from sys.objects where name = '_Item_Site')
        DROP PROCEDURE [_Item_Site]

    IF EXISTS (select * from sys.objects where name = '_Item_JanOrderPrice')
        DROP PROCEDURE [_Item_JanOrderPrice]

    IF EXISTS (select * from sys.objects where name = '_Item_JanOrderPrice2')
        DROP PROCEDURE [_Item_JanOrderPrice2]

    DROP TYPE [T_ItemImport]
END
GO

CREATE TYPE [T_ItemImport] AS TABLE
(
     ITemCD                     varchar(100) 
    ,ChangeDate                 date 
    ,ApprovalDate               date 
    ,DeleteFlg                  int 
    ,VariousFLG                 int 
    ,ITemName                   varchar(100) collate Japanese_CI_AS 
    ,KanaName                   varchar(100) collate Japanese_CI_AS 
    ,ITEMShortName              varchar(100) collate Japanese_CI_AS 
    ,EnglishName                varchar(100) collate Japanese_CI_AS 
    ,MainVendorCD               varchar(100) collate Japanese_CI_AS 
    ,VendorName                 varchar(100) collate Japanese_CI_AS 
    ,BrandCD                    varchar(100) collate Japanese_CI_AS 
    ,BrandName                  varchar(100) collate Japanese_CI_AS 
    ,MakerItem                  varchar(100) collate Japanese_CI_AS 
    ,SizeCount                  int 
    ,ColorCount                 int 
    ,TaniCD                     varchar(100) collate Japanese_CI_AS
    ,TaniName                   varchar(100) collate Japanese_CI_AS
    ,SportsCD                   varchar(100) collate Japanese_CI_AS
    ,SportsName                 varchar(100) collate Japanese_CI_AS 
    ,SegmentCD                  varchar(100) collate Japanese_CI_AS 
    ,SegmentCDName              varchar(100) collate Japanese_CI_AS 
    ,ExhibitionSegmentCD        varchar(100) collate Japanese_CI_AS 
    ,ExhibitionSegmentCDName    varchar(100) collate Japanese_CI_AS 
    ,SetKBN                     varchar(100) collate Japanese_CI_AS 
    ,SetKBNName                 varchar(100) collate Japanese_CI_AS 
    ,PresentKBN                 varchar(100) collate Japanese_CI_AS 
    ,PresentKBNName             varchar(100) collate Japanese_CI_AS 
    ,SampleKBN                  varchar(100) collate Japanese_CI_AS 
    ,SampleKBNName              varchar(100) collate Japanese_CI_AS 
    ,DiscountKBN                varchar(100) collate Japanese_CI_AS 
    ,DiscountKBNName            varchar(100) collate Japanese_CI_AS 
    ,WebFlg                     varchar(100) collate Japanese_CI_AS 
    ,WebFlgName                 varchar(100) collate Japanese_CI_AS 
    ,RealStoreFlg               varchar(100) collate Japanese_CI_AS 
    ,RealStoreFlgName           varchar(100) collate Japanese_CI_AS 
    ,ZaikoKBN                   varchar(100) collate Japanese_CI_AS 
    ,ZaikoKBNName               varchar(100) collate Japanese_CI_AS 
    ,VirtualFlg                 varchar(100) collate Japanese_CI_AS 
    ,VirtualFlgName             varchar(100) collate Japanese_CI_AS 
    ,DirectFlg                  varchar(100) collate Japanese_CI_AS 
    ,DirectFlgName              varchar(100) collate Japanese_CI_AS 
    ,ReserveCD                  varchar(100) collate Japanese_CI_AS 
    ,ReserveCDName              varchar(100) collate Japanese_CI_AS 
    ,NoticesCD                  varchar(100) collate Japanese_CI_AS 
    ,NoticesCDName              varchar(100) collate Japanese_CI_AS
    ,PostageCD                  varchar(100) collate Japanese_CI_AS 
    ,PostageCDName              varchar(100) collate Japanese_CI_AS
    ,ManufactCD                 varchar(100) collate Japanese_CI_AS 
    ,ManufactCDName             varchar(100) collate Japanese_CI_AS 
    ,ConfirmCD                  varchar(100) collate Japanese_CI_AS 
    ,ConfirmCDName              varchar(100) collate Japanese_CI_AS
    ,WebStockFlg                varchar(100) collate Japanese_CI_AS 
    ,WebStockFlgName            varchar(100) collate Japanese_CI_AS 
    ,StopFlg                    varchar(100) collate Japanese_CI_AS 
    ,StopFlgName                varchar(100) collate Japanese_CI_AS 
    ,DiscontinueFlg             varchar(100) collate Japanese_CI_AS 
    ,DiscontinueFlgName         varchar(100) collate Japanese_CI_AS 
    ,SoldOutFlg                 varchar(100) collate Japanese_CI_AS 
    ,SoldOutFlgName             varchar(100) collate Japanese_CI_AS 
    ,InventoryAddFlg            varchar(100) collate Japanese_CI_AS 
    ,InventoryAddFlgName        varchar(100) collate Japanese_CI_AS 
    ,MakerAddFlg                varchar(100) collate Japanese_CI_AS 
    ,MakerAddFlgName            varchar(100) collate Japanese_CI_AS 
    ,StoreAddFlg                varchar(100) collate Japanese_CI_AS 
    ,StoreAddFlgName            varchar(100) collate Japanese_CI_AS 
    ,NoNetOrderFlg              varchar(100) collate Japanese_CI_AS 
    ,NoNetOrderFlgName          varchar(100) collate Japanese_CI_AS 
    ,EDIOrderFlg                varchar(100) collate Japanese_CI_AS 
    ,EDIOrderFlgName            varchar(100) collate Japanese_CI_AS 
    ,AutoOrderFlg               varchar(100) collate Japanese_CI_AS 
    ,AutoOrderFlgName           varchar(100) collate Japanese_CI_AS 
    ,CatalogFlg                 varchar(100) collate Japanese_CI_AS 
    ,CatalogFlgName             varchar(100) collate Japanese_CI_AS 
    ,ParcelFlg                  varchar(100) collate Japanese_CI_AS 
    ,ParcelFlgName              varchar(100) collate Japanese_CI_AS 
    ,TaxRateFLG                 varchar(100) collate Japanese_CI_AS 
    ,TaxRateFLGName             varchar(100) collate Japanese_CI_AS 
    ,CostingKBN                 varchar(100) collate Japanese_CI_AS 
    ,CostingKBNName             varchar(100) collate Japanese_CI_AS 
    ,SaleExcludedFlg            varchar(100) collate Japanese_CI_AS 
    ,SaleExcludedFlgName        varchar(100) collate Japanese_CI_AS 
    ,NormalCost                 int 
    ,PriceWithTax               money
    ,PriceOutTax                money
    ,OrderPriceWithTax          money
    ,OrderPriceWithoutTax       money
    ,Rate                       decimal(5,2)     
    ,SaleStartDate              date 
    ,WebStartDate               date 
    ,OrderAttentionCD           varchar(100) collate Japanese_CI_AS 
    ,OrderAttentionCDName       varchar(100) collate Japanese_CI_AS 
    ,OrderAttentionNote         varchar(100) collate Japanese_CI_AS 
    ,CommentInStore             varchar(200) collate Japanese_CI_AS 
    ,CommentOutStore            varchar(200) collate Japanese_CI_AS 
    ,Rack                       varchar(100) collate Japanese_CI_AS 
    ,LastYearTerm               varchar(100) collate Japanese_CI_AS 
    ,LastSeason                 varchar(100) collate Japanese_CI_AS 
    ,LastCatalogNO              varchar(100) collate Japanese_CI_AS 
    ,LastCatalogPage            varchar(100) collate Japanese_CI_AS 
    ,LastCatalogText            varchar(1000) collate Japanese_CI_AS 
    ,LastInstructionsNO         varchar(500) collate Japanese_CI_AS 
    ,LastInstructionsDate       date 
    ,WebAddress                 varchar(200) collate Japanese_CI_AS 
    ,OrderLot                   varchar(100) collate Japanese_CI_AS 
    ,TagName01                  varchar(100) collate Japanese_CI_AS 
    ,TagName02                  varchar(100) collate Japanese_CI_AS 
    ,TagName03                  varchar(100) collate Japanese_CI_AS 
    ,TagName04                  varchar(100) collate Japanese_CI_AS 
    ,TagName05                  varchar(100) collate Japanese_CI_AS 
    ,TagName06                  varchar(100) collate Japanese_CI_AS 
    ,TagName07                  varchar(100) collate Japanese_CI_AS 
    ,TagName08                  varchar(100) collate Japanese_CI_AS 
    ,TagName09                  varchar(100) collate Japanese_CI_AS 
    ,TagName10                  varchar(100) collate Japanese_CI_AS
    ,RevisionFlg                tinyint
    ,MostRecentChangeDate       date
    ,INDEX T_ItemImport_IDX_1 NONCLUSTERED ( ITemCD, ChangeDate )
)
GO

