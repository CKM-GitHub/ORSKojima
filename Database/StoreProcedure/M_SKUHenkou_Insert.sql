BEGIN TRY
DROP PROCEDURE [dbo].[M_SKUHenKou_Insert]
END TRY
BEGIN CATCH END CATCH 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,> drop procedure  M_SKUHenKou
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[M_SKUHenKou_Insert]
	-- Add the parameters for the stored procedure here
	
					@OPTDate as Date,
					@OPTTime as Time,
					@InsertOPT as varchar(50),
					@Program as varchar(50),
					@PC as varchar(50),
					@OperateMode as varchar(50),
					@KeyItem as varchar(100),
					@xml as xml,
					@xml_1 xml 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
		
	 declare @DocHandle int
     exec sp_xml_preparedocument @DocHandle output, @Xml
	
	  
     select * into #temp FROM
     OPENXML (@DocHandle, '/NewDataSet/test',2)
	 with
	(InsertOperator varchar(50),
	InsertDateTime datetime,
	AdminNO varchar(13) ,
	JanCD varchar(13),
	NewSKUCD varchar(30),
	SKUCD varchar(13),
	ChangeDate datetime ,
	DeleteFlg varchar(20) ,
	NewSizeNo varchar(13),
	SizeNo varchar(13),
	NewColorNo varchar(13),
	ColorNo varchar(13))
	EXEc sp_xml_removedocument @DocHandle; 		
	
	--*D_SKUUpdate*
	insert into D_SKUUpdate(InsertOperator, InsertDateTime, AdminNo,JanCD, NewSKUCD, SKUCD, ChangeDate, DeleteFlag)	select a.InsertOperator, InsertDateTime, AdminNo, JanCD,((NewSKUCD))as NewSKUCD , SKUCD, ChangeDate, DeleteFlg  from 	(select * from #temp where (NewSizeNo  <> SizeNo )or (NewColorNo <> ColorNo)) a

	--M_Item
    select  top 1  mi.*,t.ChangeDate as NewChangeDate  into #ti from #temp t left outer join M_Item mi 
  on lEFT(t.NewSKUCD,LEN(t.NewSKUCD)-8) = mi.ItemCD 
    insert into M_Item
  (
ITemCD,							
ChangeDate,							
VariousFLG,							
ITemName	,						
KanaName,							
ITEMShortName	,						
EnglishName		,					
SetKBN			,				
PresentKBN		,					
SampleKBN		,					
DiscountKBN		,					
SizeCount		,					
ColorCount		,					
SizeName		,					
ColorName		,					
WebFlg			,				
RealStoreFlg	,						
MainVendorCD	,						
MakerVendorCD	,						
BrandCD			,				
MakerItem		,					
TaniCD			,				
SportsCD		,					
SegmentCD		,					
ZaikoKBN		,					
Rack			,				
VirtualFlg		,					
DirectFlg		,					
ReserveCD		,					
NoticesCD		,					
PostageCD		,					
ManufactCD		,					
ConfirmCD		,					
StopFlg			,				
DiscontinueFlg	,						
WebStockFlg		,					
InventoryAddFlg	,						
MakerAddFlg		,					
StoreAddFlg		,					
NoNetOrderFlg	,						
EDIOrderFlg		,					
AutoOrderFlg	,						
CatalogFlg		,					
ParcelFlg		,					
TaxRateFLG		,					
CostingKBN		,					
SaleExcludedFlg	,						
PriceWithTax	,						
PriceOutTax		,					
OrderPriceWithTax,							
OrderPriceWithoutTax,							
Rate				,			
SaleStartDate		,					
WebStartDate		,					
OrderAttentionCD	,						
OrderAttentionNote	,						
CommentInStore		,					
CommentOutStore		,					
LastYearTerm		,					
LastSeason			,				
LastCatalogNO		,					
LastCatalogPage		,					
LastCatalogText		,					
LastInstructionsNO		,					
LastInstructionsDate,							
WebAddress			,				
ApprovalDate		,					
ApprovalDateTime	,						
TagName01			,				
TagName02			,				
TagName03			,				
TagName04			,				
TagName05			,				
TagName06			,				
TagName07			,				
TagName08			,				
TagName09			,				
TagName10			,
ExhibitionSegmentCD,
OrderLot,				
DeleteFlg			,				
UsedFlg				,
SKSUpdateFlg,
SKSUpdateDateTime,
InsertOperator		,					
InsertDateTime		,					
UpdateOperator		,					
UpdateDateTime		
  )
  select 
  ItemCD,
  (select top 1 NewChangeDate  from #ti),
  VariousFLG,							
ITemName	,						
KanaName,							
ITEMShortName	,						
EnglishName		,					
SetKBN			,				
PresentKBN		,					
SampleKBN		,					
DiscountKBN		,					
SizeCount		,					
ColorCount		,					
SizeName		,					
ColorName		,					
WebFlg			,				
RealStoreFlg	,						
MainVendorCD	,						
MakerVendorCD	,						
BrandCD			,				
MakerItem		,					
TaniCD			,				
SportsCD		,					
SegmentCD		,					
ZaikoKBN		,					
Rack			,				
VirtualFlg		,					
DirectFlg		,					
ReserveCD		,					
NoticesCD		,					
PostageCD		,					
ManufactCD		,					
ConfirmCD		,					
StopFlg			,				
DiscontinueFlg	,						
WebStockFlg		,					
InventoryAddFlg	,						
MakerAddFlg		,					
StoreAddFlg		,					
NoNetOrderFlg	,						
EDIOrderFlg		,					
AutoOrderFlg	,						
CatalogFlg		,					
ParcelFlg		,					
TaxRateFLG		,					
CostingKBN		,					
SaleExcludedFlg	,						
PriceWithTax	,						
PriceOutTax		,					
OrderPriceWithTax,							
OrderPriceWithoutTax,							
Rate				,			
SaleStartDate		,					
WebStartDate		,					
OrderAttentionCD	,						
OrderAttentionNote	,						
CommentInStore		,					
CommentOutStore		,					
LastYearTerm		,					
LastSeason			,				
LastCatalogNO		,					
LastCatalogPage		,					
LastCatalogText		,					
LastInstructionsNO		,					
LastInstructionsDate,							
WebAddress			,				
ApprovalDate		,					
ApprovalDateTime	,						
TagName01			,				
TagName02			,				
TagName03			,				
TagName04			,				
TagName05			,				
TagName06			,				
TagName07			,				
TagName08			,				
TagName09			,				
TagName10			,
null,
0,
0,
0,
0,
null,

  (select top 1 InsertOperator from #temp),
  (select top 1 InsertDateTime from #temp),
  (select top 1 InsertOperator from #temp),
  (select top 1 InsertDateTime from #temp)
   from #ti t
     Drop table #ti
    
    --M_SKU
    select  mi.*,t.ChangeDate as NewChangeDate,t.NewSKUCD as NewSKUCD, t.NewSizeNo as NewSizeNo, t.NewColorNo as NewColorNo,t.DeleteFlg as D_Flg,t.InsertOperator as F_io,t.InsertDateTime as F_id  into #ts from #temp t inner join M_SKU mi 
  on lEFT(t.NewSKUCD,LEN(t.NewSKUCD)-8) = mi.ItemCD and mi.JanCD= t.JanCD and mi.AdminNo= t.AdminNo
    
    insert into M_SKU 
  (
AdminNO,							
ChangeDate,							
SKUCD,												
VariousFLG,					
SKUName		,				
KanaName,					
SKUShortName,				
EnglishName		,			
ITemCD		,				
SizeNO		,				
ColorNO		,				
JanCD		,					
SetKBN		,					
PresentKBN	,						
SampleKBN		,					
DiscountKBN		,					
SizeName	,						
ColorName	,						
WebFlg		,					
RealStoreFlg	,						
MainVendorCD,							
MakerVendorCD	,						
BrandCD			,				
MakerItem		,					
TaniCD		,					
SportsCD	,						
SegmentCD		,					
ZaikoKBN	,						
Rack		,					
VirtualFlg	,						
DirectFlg	,						
ReserveCD	,						
NoticesCD	,						
PostageCD	,						
ManufactCD	,						
ConfirmCD	,						
WebStockFlg	,						
StopFlg			,				
DiscontinueFlg	,						
InventoryAddFlg	,						
MakerAddFlg		,					
StoreAddFlg		,					
NoNetOrderFlg	,						
EDIOrderFlg		,					
AutoOrderFlg	,						
CatalogFlg		,					
ParcelFlg		,					
TaxRateFLG		,					
CostingKBN			,				
SaleExcludedFlg	,						
PriceWithTax	,						
PriceOutTax		,					
OrderPriceWithTax,							
OrderPriceWithoutTax,							
Rate				,			
SaleStartDate	,						
WebStartDate	,						
OrderAttentionCD,							
OrderAttentionNote	,						
CommentInStore		,					
CommentOutStore		,					
LastYearTerm		,					
LastSeason		,					
LastCatalogNO		,					
LastCatalogPage		,					
LastCatalogText		,					
LastInstructionsNO	,						
LastInstructionsDate	,						
WebAddress			,				
SetAdminCD			,				
SetItemCD			,				
SetSKUCD			,				
SetSU				,			
ApprovalDate		,					
DeleteFlg			,				
							
UsedFlg				,			
InsertOperator		,					
InsertDateTime		,					
UpdateOperator		,					
UpdateDateTime				
  ) 
  
  select 
  AdminNO,							
NewChangeDate,							
NewSKUCD,												
VariousFLG,					
SKUName		,				
KanaName,					
SKUShortName,				
EnglishName		,			
ITemCD		,			
NewSizeNO		,				
NewColorNO		,				
JanCD		,					
SetKBN		,					
PresentKBN	,						
SampleKBN		,					
DiscountKBN		,					
SizeName	,						
ColorName	,						
WebFlg		,					
RealStoreFlg	,						
MainVendorCD,							
MakerVendorCD	,						
BrandCD			,				
MakerItem		,					
TaniCD		,					
SportsCD	,						
SegmentCD		,					
ZaikoKBN	,						
Rack		,					
VirtualFlg	,						
DirectFlg	,						
ReserveCD	,						
NoticesCD	,						
PostageCD	,						
ManufactCD	,						
ConfirmCD	,						
WebStockFlg	,						
StopFlg			,				
DiscontinueFlg	,						
InventoryAddFlg	,						
MakerAddFlg		,					
StoreAddFlg		,					
NoNetOrderFlg	,						
EDIOrderFlg		,					
AutoOrderFlg	,						
CatalogFlg		,					
ParcelFlg		,					
TaxRateFLG		,					
CostingKBN			,				
SaleExcludedFlg	,						
PriceWithTax	,						
PriceOutTax		,					
OrderPriceWithTax,							
OrderPriceWithoutTax,							
Rate				,			
SaleStartDate	,						
WebStartDate	,						
OrderAttentionCD,							
OrderAttentionNote	,						
CommentInStore		,					
CommentOutStore		,					
LastYearTerm		,					
LastSeason		,					
LastCatalogNO		,					
LastCatalogPage		,					
LastCatalogText		,					
LastInstructionsNO	,						
LastInstructionsDate	,						
WebAddress			,				
SetAdminCD			,				
SetItemCD			,				
SetSKUCD			,				
SetSU				,			
ApprovalDate		,					
D_Flg			,
0,
F_io,
F_id,
F_io,
F_id
from #ts

	--*M_SKUChange

	 declare @DocHandle_1 int
     exec sp_xml_preparedocument @DocHandle_1 output, @Xml_1
	
	  
     select * into #temp_1 FROM
     OPENXML (@DocHandle_1, '/NewDataSet/test',2)
	 with(
	 InsertOperator varchar (50),
	 InsertDateTime varchar(50),
	 ItemCD varchar(30),
	 SizeColorKBN tinyint,
	 NewNo tinyint,
	 [No] int,
	 ChangeDate Datetime,
	 DeleteFlg tinyint
	 )
	 	EXEc sp_xml_removedocument @DocHandle_1; 
					insert into D_SKUChange (InsertOperator, InsertDateTime, ItemCD, SizeColorKBN,NewNo, [No],ChangeDate, DeleteFlg) select * from #Temp_1
    ---L_Log
					insert into L_Log(OperateDate, OPerateTime, InsertOperator, Program,PC,OperateMode, KeyItem) values(
					@OPTDate,
					@OPTTime,
					@InsertOPT,
					@Program,
					@PC,
					@OperateMode,
					@KeyItem
					)


					drop table #temp
					drop table #Temp_1
					End

