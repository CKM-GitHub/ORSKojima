 BEGIN TRY 
 Drop Procedure [dbo].[M_SKU_Export]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[M_SKU_Export]
	-- Add the parameters for the stored procedure here
	@ChangeDate as date,
	@VendorCD as varchar(13),
	@MakerCD as varchar(13),
	@BrandCD as varchar(6),
	@SKUName as varchar(100),
	@JanCD as varchar(13),
	@SkuCD as varchar(40),
	@MakerItem as varchar(300),
	@ItemCD as varchar(300),
	@CommentInStore as varchar(300),
	@ReserveCD as varchar(3),
	@NoticesCD as varchar(3),
	@PostageCD as varchar(3),
	@OrderAttention as varchar(3),
	@SportsCD as varchar(6),
	@InsertDateTimeT as datetime,
	@InsertDateTimeF as datetime,
	@UpdateDateTimeT as datetime,
	@UpdateDateTimeF as datetime,
	@ApprovalDateF as date,
	@ApprovalDateT as date,
	@YearTerm as varchar(6),
	@Season as varchar(6),
	@CatalogNo as varchar(50),
	@InstructionsNO as varchar(1000),
	@Tag1 as varchar(40),
	@Tag2 as varchar(40),
	@Tag3 as varchar(40),
	@Tag4 as varchar(40),
	@Tag5 as varchar(40),
	@mode as tinyint,
	@checkflg as tinyint,
	@chkUnapprove as tinyint,
	@Program as varchar(100),
	@PC as varchar(30),
	@ProcessMode as varchar(50),
	@KeyItem as varchar(100),
	@Operator as varchar(100),
	--@keyword1 as varchar(80),
	--@keyword2 as varchar(80),
	--@keyword3 as varchar(80),
	@type as tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



		 IF (@YearTerm = -1)
		SET @YearTerm = null

	IF (@Season = -1)
		SET @Season = null

		IF (@ReserveCD = -1)
		SET @ReserveCD = null

	IF (@NoticesCD = -1)
		SET @NoticesCD = null

	IF (@PostageCD = -1)
		SET @PostageCD = null

	IF (@OrderAttention = -1)
		SET @OrderAttention = null

DECLARE @SQL NVARCHAR(MAX), @CommentInStore1 as varchar(300)

	IF @type = 1 AND (@CommentInStore IS NOT NULL OR @CommentInStore <> '')
		SET @CommentInStore1 = '''%'' + ''' + REPLACE(@CommentInStore,',',''' + ''%'' OR msku.CommentInStore LIKE ''%'' + ''') + ''' + ''%'''
	ELSE IF @type = 2 AND (@CommentInStore IS NOT NULL OR @CommentInStore <> '')
		SET @CommentInStore1 = '''%'' + ''' + REPLACE(@CommentInStore,',',''' + ''%'' AND msku.CommentInStore LIKE ''%'' + ''') + ''' + ''%'''
	ELSE IF @CommentInStore IS NULL OR @CommentInStore = ''
		SET @CommentInStore1 = '''%''''%'''



	CREATE TABLE [dbo].[#TAdminNo](
	[AdminNO] [int] NULL,)

    -- Insert statements for procedure here
	if @mode=1
	begin 
				SET @SQL = '
				insert into #TAdminNo
				select distinct AdminNO from F_SKU(@ChangeDate)  where ITemCD in
				
				(select ITemCD
					From	F_SKU(@ChangeDate) as msku
					Left outer join M_SKUInfo as msInfo on msku.AdminNO=msInfo.AdminNO
														and msku.ChangeDate = msInfo.ChangeDate 
														and msku.DeleteFlg=0
					Left outer join  M_SKUTag as mst on msku.AdminNO=mst.AdminNo
														and msku.ChangeDate =mst.ChangeDate

					where 
					 (@VendorCD is Null or (msku.MainVendorCD =@VendorCD))
					and ( @makerCD is Null or ( msku.MakerVendorCD = @makerCD))
					and (@brandCD is Null or  (msku.BrandCD =@brandCD))
					and (@SKUName is NUll or (msku.SKUName Like  ''%'' +@SKUName +  ''%''))
					and (@JanCD is Null or ( msku.JanCD=@JanCD))
					and (@SkuCD is Null or (msku.SKUCD=@SkuCD))
					and (@MakerItem is Null or (msku.MakerItem IN (Select * from SplitString(@MakerItem,'',''))))
					and (@ItemCD is Null or (msku.ITemCD  IN (Select * from SplitString(@ItemCD,'',''))))
					and (@CommentInStore is Null or (msku.CommentInStore LIKE ' + @CommentInStore1 + '))
					and (@ReserveCD is Null or ( msku.ReserveCD=@ReserveCD))
					and (@NoticesCD is Null or (msku.NoticesCD=@NoticesCD))
					and  (@PostageCD is Null or (msku.PostageCD=@PostageCD))
					and (@OrderAttention is Null or (msku.OrderAttentionCD=@OrderAttention))
					and (@SportsCD is Null or (msku.SportsCD=@SportsCD))
					and (@InsertDateTimeF is Null or (msku.InsertDateTime >= @InsertDateTimeF))
					and (@InsertDateTimeT is Null or (msku.InsertDateTime <= @InsertDateTimeT))
					and (@UpdateDateTimeT is Null or (msku.UpdateDateTime >= @UpdateDateTimeT))
					and (@UpdateDateTimeF is Null or (msku.UpdateDateTime <= @UpdateDateTimeF))
					--and (@ApprovalDateF is Null or ( msku.ApprovalDate >= @ApprovalDateF))		
					--and (@ApprovalDateT is Null or (msku.ApprovalDate <= @ApprovalDateT))
					and ((((@ApprovalDateF is Null or ( msku.ApprovalDate >= @ApprovalDateF))		
							and (@ApprovalDateT is Null or (msku.ApprovalDate <= @ApprovalDateT))) ) or 
							(@chkUnapprove = 1 and msku.ApprovalDate is null)
							) 
					and (@YearTerm is Null or( msInfo.YearTerm=@YearTerm))
					and  (@Season is Null or(  msInfo.Season=@SeaSon))
					and (@CatalogNo is Null or ( msInfo.CatalogNO=@CatalogNo))
					and ( @InstructionsNO is Null or (msInfo.InstructionsNO=@InstructionsNO))
					and (@Tag1 is Null or  TagName =@Tag1)
					and (@Tag2 is Null or  TagName =@Tag2)
					and (@Tag3 is Null or  TagName =@Tag3)
					and (@Tag4 is Null or  TagName =@Tag4)
					and (@Tag5 is Null or  TagName =@Tag5))'
		EXECUTE sp_executesql @SQL, N'@ChangeDate DATE,@VendorCD VARCHAR(13),@MakerCD VARCHAR(13),@BrandCD VARCHAR(6),@SKUName VARCHAR(100),@JanCD VARCHAR(13),@SkuCD VARCHAR(40),@MakerItem VARCHAR(300),@ItemCD VARCHAR(300),@CommentInStore VARCHAR(300),@ReserveCD VARCHAR(3),@NoticesCD VARCHAR(3),@PostageCD VARCHAR(3),@OrderAttention VARCHAR(3),@SportsCD VARCHAR(6),@InsertDateTimeT DATETIME,@InsertDateTimeF DATETIME,@UpdateDateTimeT DATETIME,@UpdateDateTimeF DATETIME,@ApprovalDateF DATETIME,@ApprovalDateT DATE,@YearTerm as varchar(6),@Season VARCHAR(6),@CatalogNo VARCHAR(50),@InstructionsNO VARCHAR(1000),@Tag1 VARCHAR(40),@Tag2 VARCHAR(40),@Tag3 VARCHAR(40),@Tag4 VARCHAR(40),@Tag5 VARCHAR(40),@chkUnapprove TINYINT',
		@ChangeDate = @ChangeDate, @VendorCD = @VendorCD, @MakerCD = @MakerCD, @BrandCD = @BrandCD, @SKUName = @SKUName, @JanCD = @JanCD, @SkuCD = @SkuCD, @MakerItem = @MakerItem, @ItemCD = @ItemCD, @CommentInStore = @CommentInStore, 
		@ReserveCD = @ReserveCD, @NoticesCD = @NoticesCD, @PostageCD = @PostageCD, @OrderAttention = @OrderAttention, @SportsCD = @SportsCD, @InsertDateTimeF = @InsertDateTimeF, @InsertDateTimeT = @InsertDateTimeT, @UpdateDateTimeF = @UpdateDateTimeF, @UpdateDateTimeT = @UpdateDateTimeT, @ApprovalDateF = @ApprovalDateF, 
		@ApprovalDateT = @ApprovalDateT, @YearTerm = @YearTerm, @Season = @Season, @CatalogNo = @CatalogNo, @InstructionsNO = @InstructionsNO, @Tag1 = @Tag1, @Tag2 = @Tag2, @Tag3 = @Tag3, @Tag4 = @Tag4, @Tag5 = @Tag5, @chkUnapprove = @chkUnapprove 
			
		end
	
	if @mode=2
	begin 
				SET @SQL = '
				insert into #TAdminNo
				select distinct AdminNO from F_SKU(@ChangeDate)  where MakerItem in
				
				(select MakerItem
					From	F_SKU(@ChangeDate) as msku
					Left outer join M_SKUInfo as msInfo on msku.AdminNO=msInfo.AdminNO
														and msku.ChangeDate = msInfo.ChangeDate 
														and msku.DeleteFlg=0
					Left outer join  M_SKUTag as mst on msku.AdminNO=mst.AdminNo
														and msku.ChangeDate =mst.ChangeDate

					where (@VendorCD is Null or (msku.MainVendorCD =@VendorCD))
					and ( @makerCD is Null or ( msku.MakerVendorCD = @makerCD))
					and (@brandCD is Null or  (msku.BrandCD =@brandCD))
					and (@SKUName is NUll or (msku.SKUName Like   ''%'' +@SKUName + ''%''))
					and (@JanCD is Null or ( msku.JanCD=@JanCD))
					and (@SkuCD is Null or (msku.SKUCD=@SkuCD))
					and (@MakerItem is Null or (msku.MakerItem IN (Select * from SplitString(@MakerItem,'',''))))
					and (@ItemCD is Null or (msku.ITemCD  IN (Select * from SplitString(@ItemCD,'',''))))
					and (@CommentInStore is Null or (msku.CommentInStore LIKE ' + @CommentInStore1 + '))
					and (@ReserveCD is Null or ( msku.ReserveCD=@ReserveCD))
					and (@NoticesCD is Null or (msku.NoticesCD=@NoticesCD))
					and  (@PostageCD is Null or (msku.PostageCD=@PostageCD))
					and (@OrderAttention is Null or (msku.OrderAttentionCD=@OrderAttention))
					and (@SportsCD is Null or (msku.SportsCD=@SportsCD))
					and (@InsertDateTimeF is Null or (msku.InsertDateTime >= @InsertDateTimeF))
					and (@InsertDateTimeT is Null or (msku.InsertDateTime <= @InsertDateTimeT))
					and (@UpdateDateTimeT is Null or (msku.UpdateDateTime >= @UpdateDateTimeT))
					and (@UpdateDateTimeF is Null or (msku.UpdateDateTime <= @UpdateDateTimeF))
					--and (@ApprovalDateF is Null or ( msku.ApprovalDate >= @ApprovalDateF))		
					--and (@ApprovalDateT is Null or (msku.ApprovalDate <= @ApprovalDateT))
					and ((((@ApprovalDateF is Null or ( msku.ApprovalDate >= @ApprovalDateF))		
							and (@ApprovalDateT is Null or (msku.ApprovalDate <= @ApprovalDateT))) ) or 
							(@chkUnapprove = 1 and msku.ApprovalDate is null)
							) 
					and (@YearTerm is Null or( msInfo.YearTerm=@YearTerm))
					and (@Season is Null or(  msInfo.Season=@SeaSon))
					and (@CatalogNo is Null or ( msInfo.CatalogNO=@CatalogNo))
					and ( @InstructionsNO is Null or (msInfo.InstructionsNO=@InstructionsNO))
					and (@Tag1 is Null or  TagName =@Tag1)
					and (@Tag2 is Null or  TagName =@Tag2)
					and (@Tag3 is Null or  TagName =@Tag3)
					and (@Tag4 is Null or  TagName =@Tag4)
					and (@Tag5 is Null or  TagName =@Tag5))'
			EXECUTE sp_executesql @SQL, N'@ChangeDate DATE,@VendorCD VARCHAR(13),@MakerCD VARCHAR(13),@BrandCD VARCHAR(6),@SKUName VARCHAR(100),@JanCD VARCHAR(13),@SkuCD VARCHAR(40),@MakerItem VARCHAR(300),@ItemCD VARCHAR(300),@CommentInStore VARCHAR(300),@ReserveCD VARCHAR(3),@NoticesCD VARCHAR(3),@PostageCD VARCHAR(3),@OrderAttention VARCHAR(3),@SportsCD VARCHAR(6),@InsertDateTimeT DATETIME,@InsertDateTimeF DATETIME,@UpdateDateTimeT DATETIME,@UpdateDateTimeF DATETIME,@ApprovalDateF DATETIME,@ApprovalDateT DATE,@YearTerm as varchar(6),@Season VARCHAR(6),@CatalogNo VARCHAR(50),@InstructionsNO VARCHAR(1000),@Tag1 VARCHAR(40),@Tag2 VARCHAR(40),@Tag3 VARCHAR(40),@Tag4 VARCHAR(40),@Tag5 VARCHAR(40),@chkUnapprove TINYINT',
			@ChangeDate = @ChangeDate, @VendorCD = @VendorCD, @MakerCD = @MakerCD, @BrandCD = @BrandCD, @SKUName = @SKUName, @JanCD = @JanCD, @SkuCD = @SkuCD, @MakerItem = @MakerItem, @ItemCD = @ItemCD, @CommentInStore = @CommentInStore, 
			@ReserveCD = @ReserveCD, @NoticesCD = @NoticesCD, @PostageCD = @PostageCD, @OrderAttention = @OrderAttention, @SportsCD = @SportsCD, @InsertDateTimeF = @InsertDateTimeF, @InsertDateTimeT = @InsertDateTimeT, @UpdateDateTimeF = @UpdateDateTimeF, @UpdateDateTimeT = @UpdateDateTimeT, @ApprovalDateF = @ApprovalDateF, 
			@ApprovalDateT = @ApprovalDateT, @YearTerm = @YearTerm, @Season = @Season, @CatalogNo = @CatalogNo, @InstructionsNO = @InstructionsNO, @Tag1 = @Tag1, @Tag2 = @Tag2, @Tag3 = @Tag3, @Tag4 = @Tag4, @Tag5 = @Tag5, @chkUnapprove = @chkUnapprove 
		
		end

	if @mode=3
	begin 
				SET @SQL = '
				insert into #TAdminNo
				select distinct msku.AdminNO
					From	F_SKU(@ChangeDate) as msku
					Left outer join M_SKUInfo as msInfo on msku.AdminNO=msInfo.AdminNO
														and msku.ChangeDate = msInfo.ChangeDate 
														and msku.DeleteFlg=0
					Left outer join  M_SKUTag as mst on msku.AdminNO=mst.AdminNo
														and msku.ChangeDate =mst.ChangeDate

					where (@VendorCD is Null or (msku.MainVendorCD =@VendorCD))
					and ( @makerCD is Null or ( msku.MakerVendorCD = @makerCD))
					and (@brandCD is Null or  (msku.BrandCD =@brandCD))
					and (@SKUName is NUll or (msku.SKUName Like   ''%'' +@SKUName + ''%''))
					and (@JanCD is Null or ( msku.JanCD=@JanCD))
					and (@SkuCD is Null or (msku.SKUCD=@SkuCD))
					and (@MakerItem is Null or (msku.MakerItem IN (Select * from SplitString(@MakerItem,'',''))))
					and (@ItemCD is Null or (msku.ITemCD  IN (Select * from SplitString(@ItemCD,'',''))))
					and (@CommentInStore is Null or (msku.CommentInStore LIKE ' + @CommentInStore1 + '))					
					and (@ReserveCD is Null or ( msku.ReserveCD=@ReserveCD))
					and (@NoticesCD is Null or (msku.NoticesCD=@NoticesCD))
					and (@PostageCD is Null or (msku.PostageCD=@PostageCD))
					and (@OrderAttention is Null or (msku.OrderAttentionCD=@OrderAttention))
					and (@SportsCD is Null or (msku.SportsCD=@SportsCD))
					and (@InsertDateTimeF is Null or (msku.InsertDateTime >= @InsertDateTimeF))
					and (@InsertDateTimeT is Null or (msku.InsertDateTime <= @InsertDateTimeT))
					and (@UpdateDateTimeT is Null or (msku.UpdateDateTime >= @UpdateDateTimeT))
					and (@UpdateDateTimeF is Null or (msku.UpdateDateTime <= @UpdateDateTimeF))
					--and (@ApprovalDateF is Null or ( msku.ApprovalDate >= @ApprovalDateF))		
					--and (@ApprovalDateT is Null or (msku.ApprovalDate <= @ApprovalDateT))
					and ((((@ApprovalDateF is Null or ( msku.ApprovalDate >= @ApprovalDateF))		
							and (@ApprovalDateT is Null or (msku.ApprovalDate <= @ApprovalDateT))) ) or 
							(@chkUnapprove = 1 and msku.ApprovalDate is null)
							) 
					and  (@YearTerm is Null or( msInfo.YearTerm=@YearTerm))
					and  (@Season is Null or(  msInfo.Season=@SeaSon))
					and (@CatalogNo is Null or ( msInfo.CatalogNO=@CatalogNo))
					and ( @InstructionsNO is Null or (msInfo.InstructionsNO=@InstructionsNO))
					and (@Tag1 is Null or  TagName =@Tag1)
					and (@Tag2 is Null or  TagName =@Tag2)
					and (@Tag3 is Null or  TagName =@Tag3)
					and (@Tag4 is Null or  TagName =@Tag4)
					and (@Tag5 is Null or  TagName =@Tag5)'
			EXECUTE sp_executesql @SQL, N'@ChangeDate DATE,@VendorCD VARCHAR(13),@MakerCD VARCHAR(13),@BrandCD VARCHAR(6),@SKUName VARCHAR(100),@JanCD VARCHAR(13),@SkuCD VARCHAR(40),@MakerItem VARCHAR(300),@ItemCD VARCHAR(300),@CommentInStore VARCHAR(300),@ReserveCD VARCHAR(3),@NoticesCD VARCHAR(3),@PostageCD VARCHAR(3),@OrderAttention VARCHAR(3),@SportsCD VARCHAR(6),@InsertDateTimeT DATETIME,@InsertDateTimeF DATETIME,@UpdateDateTimeT DATETIME,@UpdateDateTimeF DATETIME,@ApprovalDateF DATETIME,@ApprovalDateT DATE,@YearTerm as varchar(6),@Season VARCHAR(6),@CatalogNo VARCHAR(50),@InstructionsNO VARCHAR(1000),@Tag1 VARCHAR(40),@Tag2 VARCHAR(40),@Tag3 VARCHAR(40),@Tag4 VARCHAR(40),@Tag5 VARCHAR(40),@chkUnapprove TINYINT',
			@ChangeDate = @ChangeDate, @VendorCD = @VendorCD, @MakerCD = @MakerCD, @BrandCD = @BrandCD, @SKUName = @SKUName, @JanCD = @JanCD, @SkuCD = @SkuCD, @MakerItem = @MakerItem, @ItemCD = @ItemCD, @CommentInStore = @CommentInStore, 
			@ReserveCD = @ReserveCD, @NoticesCD = @NoticesCD, @PostageCD = @PostageCD, @OrderAttention = @OrderAttention, @SportsCD = @SportsCD, @InsertDateTimeF = @InsertDateTimeF, @InsertDateTimeT = @InsertDateTimeT, @UpdateDateTimeF = @UpdateDateTimeF, @UpdateDateTimeT = @UpdateDateTimeT, @ApprovalDateF = @ApprovalDateF, 
			@ApprovalDateT = @ApprovalDateT, @YearTerm = @YearTerm, @Season = @Season, @CatalogNo = @CatalogNo, @InstructionsNO = @InstructionsNO, @Tag1 = @Tag1, @Tag2 = @Tag2, @Tag3 = @Tag3, @Tag4 = @Tag4, @Tag5 = @Tag5, @chkUnapprove = @chkUnapprove 
		
		end	

	If @checkflg=8
		begin
				Select 
					 8 as データ区分,
					fs.AdminNO as AdminNO,
					Convert(varchar(10),fs.ChangeDate,111) as 改定日,
					Convert(varchar(10),fs.ApprovalDate,111) as 承認日,
					fs.SKUCD as SKUCD,
					fs.JanCD as JANCD,
					fs.DeleteFlg as 削除,
					fs.VariousFLG as 諸口区分,
					fs.SKUName as 商品名,
					fs.KanaName as カナ名,
					fs.SKUShortName as 略名,
					fs.EnglishName as 英語名,
					fs.ITemCD as ITEMCD,
					fs.SizeNO as サイズ枝番,
					fs.ColorNO as カラー枝番,
					fs.SizeName as サイズ名, 
					fs.ColorName as カラー名,
					fs.MainVendorCD as 主要仕入先CD,
					mv.VendorName as 主要仕入先名,			
					fs.BrandCD as ブランドCD,
					mb.BrandName as ブランド名,
					fs.MakerItem as メーカー商品CD,
					fs.TaniCD as 単位CD,
						(
									Select top 1 mb.Char1   
									from M_MultiPorpose as mb
									where mb.[Key]=fs.TaniCD
									and ID=201
						)	 as 単位名,
					fs.SportsCD as 競技CD,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.SportsCD
								and ID=202
						) as 競技名,
					fs.SegmentCD as 商品分類CD,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.SegmentCD
								and ID=203
						) as 分類名,
					fs.ExhibitionSegmentCD as セグメントCD,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ExhibitionSegmentCD
								and ID=226
						) as セグメント名,
					fs.SetKBN as セット品区分,
					Case When fs.SetKBN =1 Then 'セット'  end as セット品区分名,
					fs.PresentKBN as プレゼント品区分,
						Case When fs.PresentKBN =1 Then 'プレゼント'  end as プレゼント品区分名,
			
					fs.SampleKBN as サンプル品区分 ,
						Case When fs.SampleKBN =1 Then 'サンプル'  end as サンプル品区分名,
					fs.DiscountKBN as 値引商品区分,
						Case When fs.DiscountKBN =1 Then '値引'  end as 値引商品区分名,
					fs.WebFlg as Webストア取扱区分,
						Case When fs.WebFlg =1 Then '対象'  end as Webストア取扱区分名,
					fs.RealStoreFlg as 実店舗取扱区分,
						Case When fs.RealStoreFlg =1 Then '対象'  end as 実店舗取扱区分名,

					fs.ZaikoKBN as 在庫管理対象区分,
						Case When fs.ZaikoKBN =1 Then '対象'  end as 在庫管理対象区分名,

					fs.VirtualFlg as 架空商品区分,
						Case When fs.VirtualFlg =1 Then '架空'  end as 架空商品区分名,
					fs.DirectFlg as 直送品区分,
						Case When fs.DirectFlg =1 Then '直送'  end as 直送品区分名,
					fs.ReserveCD as 予約品区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ReserveCD
								and ID=311
						) as 予約品区分名,
					fs.NoticesCD as 特記区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.NoticesCD
								and ID=310
						) as 特記区分名,
					fs.PostageCD as 送料区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.PostageCD
								and ID=309
						) as 送料区分名,
					fs.ManufactCD as 要加工品区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ManufactCD
								and ID=312
						) as 要加工品区分名,
					fs.ConfirmCD as 要確認品区分,
						 (
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ConfirmCD
								and ID=313
						) as 要確認品区分名,
					fs.WebStockFlg as Web在庫連携区分,
						Case When fs.WebStockFlg =1 Then '対象'  end as Web在庫連携区分名,
					fs.StopFlg as 販売停止品区分,
						Case When fs.StopFlg =1 Then '停止'  end as 販売停止品区分名 ,
					fs.DiscontinueFlg as 廃番品区分,
						Case When fs.DiscontinueFlg =1 Then '廃番'  end as 廃番品区分名 ,
					fs.SoldOutFlg as 完売品区分,
						Case When fs.SoldOutFlg =1 Then '完売'  end as 完売品区分名,
					fs.InventoryAddFlg as 自社在庫連携対象,
						Case When fs.InventoryAddFlg =1 Then '対象'  end as 自社在庫連携対象名,
					fs.MakerAddFlg as メーカー在庫連携対象,
						Case When fs.MakerAddFlg =1 Then '対象'  end as メーカー在庫連携対象名,
					fs.StoreAddFlg as 店舗在庫連携対象,
						Case When fs.StoreAddFlg =1 Then '対象'  end as 店舗在庫連携対象名,
					fs.NoNetOrderFlg as Net発注不可区分,
						Case When fs.NoNetOrderFlg =1 Then '不可'  end as Net発注不可区分名,
					fs.EDIOrderFlg as EDI発注可能区分,
						Case When fs.EDIOrderFlg =1 Then '可能'  end as EDI発注可能区分名,
					fs.AutoOrderFlg as 自動発注対象区分 ,
						Case When fs.AutoOrderFlg =1 Then '対象'  end as 自動発注対象,
					fs.CatalogFlg as カタログ掲載有無区分,
						Case When fs.CatalogFlg =1 Then 'あり'  end as カタログ掲載有無,
					fs.ParcelFlg as 小包梱包可能区分,
						Case When fs.ParcelFlg =1 Then '可能'  end as 小包梱包可能,
					fs.TaxRateFlg as '税率区分',
						Case 
							when fs.TaxRateFLG=1 Then '通常課税' 
							when fs.TaxRateFLG=2 Then '軽減課税'
							When fs.TaxRateFlg =0 Then ':非課税'
 							end as 税率区分名,
					fs.CostingKBN as '原価計算方法',
						Case When fs.CostingKBN =1 Then '標準原価'
							when fs.CostingKBN=2 Then '総平均原価'
 							end as 原価計算方法名,
					fs.SaleExcludedFlg as 'Sale対象外区分',
						Case When fs.SaleExcludedFlg =1 Then '対象外'
 							end  as Sale対象外区分名,
					fs.NormalCost as 標準原価,
					fs.PriceOutTax as 税抜定価,
					fs.PriceWithTax as 税込定価,
					fs.OrderPriceWithTax as 発注税込価格,
					fs.OrderPriceWithoutTax as 発注税抜価格,
					fs.Rate as 掛率,
					Convert(varchar(10),fs.SaleStartDate, 111) as 発売開始日,
					Convert(varchar(10),fs.WebStartDate, 111) as Web掲載開始日, 
					fs.OrderAttentionCD as 発注注意区分,
						 (
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.OrderAttentionCD
								and ID=316
						) as 発注注意区分名,
					fs.OrderAttentionNote as 発注注意事項,
					fs.CommentInStore as 管理用備考,
					fs.CommentOutStore as 表示用備考,
					fs.Rack as 棚番 ,
					fs.LastYearTerm as 年度,
					fs.LastSeason as シーズン,
					fs.LastCatalogNO as カタログ番号,
					fs.LastCatalogPage as カタログページ,
					fs.LastCatalogNOLong as カタログ番号Long,
					fs.LastCatalogPageLong as カタログページLong,
					fs.LastCatalogText as カタログ情報,
					fs.LastInstructionsNO as 指示書番号,
                    Convert(varchar(10), fs.LastInstructionsDate, 111) as 指示書発行日,
					fs.WebAddress as 商品情報アドレス,
					fs.SetSU as 構成数,
					fs.OrderLot  as 発注ロット,
					ft1.TagName as タグ1,
					ft2.TagName as タグ2,
					ft3.TagName as タグ3,
					ft4.TagName as タグ4,
					ft5.TagName as タグ5,
					ft6.TagName as タグ6,
					ft7.TagName as タグ7,
					ft8.TagName as タグ8,
					ft9.TagName as タグ9,
					ft10.TagName as タグ10,
					ms.APIKey as APIKey,
					ms.ShouhinCD as サイト商品CD

				from #TAdminNo as tmp
				left outer join F_SKU(@changedate) as fs on tmp.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,1) as ft1 on ft1.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,2) as ft2 on ft2.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,3) as ft3 on ft3.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,4) as ft4 on ft4.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,5) as ft5 on ft5.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,6) as ft6 on ft6.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,7) as ft7 on ft7.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,8) as ft8 on ft8.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,9) as ft9 on ft9.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,10) as ft10 on ft10.AdminNO=fs.AdminNO
				left outer join M_Site as ms on ms.AdminNO =fs.AdminNO
				left outer join M_Brand as mb on mb.BrandCD =fs.BrandCD
				left outer join M_Vendor as mv on mv.VendorCD=fs.MainVendorCD
				order by SKUCD
		end

		Else
		begin
				Select 
					Case	When @checkflg=1 Then 1 
							When @checkflg=2 Then 2
							When @checkflg=3 Then 3
							When @checkflg=4 Then 4
							When @checkflg=5 Then 5
							When @checkflg=6 Then 6
							When @checkflg=7 Then 7
							End as データ区分,

  
					fs.AdminNO as AdminNO,
					Convert(varchar(10),fs.ChangeDate,111) as 改定日,
					Convert(varchar(10),fs.ApprovalDate,111) as 承認日,
					fs.SKUCD as SKUCD,
					fs.JanCD as JANCD,
					fs.DeleteFlg as 削除,
					fs.VariousFLG as 諸口区分,
					fs.SKUName as 商品名,
					fs.KanaName as カナ名,
					fs.SKUShortName as 略名,
					fs.EnglishName as 英語名,
					fs.ITemCD as ITEMCD,
					fs.SizeNO as サイズ枝番,
					fs.ColorNO as カラー枝番,
					fs.SizeName as サイズ名, 
					fs.ColorName as カラー名,
					fs.MainVendorCD as 主要仕入先CD,
					mv.VendorName as 主要仕入先名,	
					fs.BrandCD as ブランドCD,
					mb.BrandName as ブランド名,
					fs.MakerItem as メーカー商品CD,
					fs.TaniCD as 単位CD,
						(
									Select top 1 mb.Char1   
									from M_MultiPorpose as mb
									where mb.[Key]=fs.TaniCD
									and ID=201
						)	 as 単位名,
					fs.SportsCD as 競技CD,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.SportsCD
								and ID=202
						) as 競技名,
					fs.SegmentCD as 商品分類CD,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.SegmentCD
								and ID=203
						) as 分類名,
					fs.ExhibitionSegmentCD as セグメントCD,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ExhibitionSegmentCD
								and ID=226
						) as セグメント名,
					fs.SetKBN as セット品区分,
					Case When fs.SetKBN =1 Then 'セット'  end as セット品区分名,
					fs.PresentKBN as プレゼント品区分,
						Case When fs.PresentKBN =1 Then 'プレゼント'  end as プレゼント品区分名,
			
					fs.SampleKBN as サンプル品区分 ,
						Case When fs.SampleKBN =1 Then 'サンプル'  end as サンプル品区分名,
					fs.DiscountKBN as 値引商品区分,
						Case When fs.DiscountKBN =1 Then '値引'  end as 値引商品区分名,
					fs.WebFlg as Webストア取扱区分,
						Case When fs.WebFlg =1 Then '対象'  end as Webストア取扱区分名,
					fs.RealStoreFlg as 実店舗取扱区分,
						Case When fs.RealStoreFlg =1 Then '対象'  end as 実店舗取扱区分名,

					fs.ZaikoKBN as 在庫管理対象区分,
						Case When fs.ZaikoKBN =1 Then '対象'  end as 在庫管理対象区分名,

					fs.VirtualFlg as 架空商品区分,
						Case When fs.VirtualFlg =1 Then '架空'  end as 架空商品区分名,
					fs.DirectFlg as 直送品区分,
						Case When fs.DirectFlg =1 Then '直送'  end as 直送品区分名,
					fs.ReserveCD as 予約品区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ReserveCD
								and ID=311
						) as 予約品区分名,
					fs.NoticesCD as 特記区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.NoticesCD
								and ID=310
						) as 特記区分名,
					fs.PostageCD as 送料区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.PostageCD
								and ID=309
						) as 送料区分名,
					fs.ManufactCD as 要加工品区分,
						(
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ManufactCD
								and ID=312
						) as 要加工品区分名,
					fs.ConfirmCD as 要確認品区分,
						 (
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.ConfirmCD
								and ID=313
						) as 要確認品区分名,
					fs.WebStockFlg as Web在庫連携区分,
						Case When fs.WebStockFlg =1 Then '対象'  end as Web在庫連携区分名,
					fs.StopFlg as 販売停止品区分,
						Case When fs.StopFlg =1 Then '停止'  end as 販売停止品区分名 ,
					fs.DiscontinueFlg as 廃番品区分,
						Case When fs.DiscontinueFlg =1 Then '廃番'  end as 廃番品区分名 ,
					fs.SoldOutFlg as 完売品区分,
						Case When fs.SoldOutFlg =1 Then '完売'  end as 完売品区分名,
					fs.InventoryAddFlg as 自社在庫連携対象,
						Case When fs.InventoryAddFlg =1 Then '対象'  end as 自社在庫連携対象名,
					fs.MakerAddFlg as メーカー在庫連携対象,
						Case When fs.MakerAddFlg =1 Then '対象'  end as メーカー在庫連携対象名,
					fs.StoreAddFlg as 店舗在庫連携対象,
						Case When fs.StoreAddFlg =1 Then '対象'  end as 店舗在庫連携対象名,
					fs.NoNetOrderFlg as Net発注不可区分,
						Case When fs.NoNetOrderFlg =1 Then '不可'  end as Net発注不可区分名,
					fs.EDIOrderFlg as EDI発注可能区分,
						Case When fs.EDIOrderFlg =1 Then '可能'  end as EDI発注可能区分名,
					fs.AutoOrderFlg as 自動発注対象区分 ,
						Case When fs.AutoOrderFlg =1 Then '対象'  end as 自動発注対象,
					fs.CatalogFlg as カタログ掲載有無区分,
						Case When fs.CatalogFlg =1 Then 'あり'  end as カタログ掲載有無,
					fs.ParcelFlg as 小包梱包可能区分,
						Case When fs.ParcelFlg =1 Then '可能'  end as 小包梱包可能,
					fs.TaxRateFlg as '税率区分',
						Case 
							when fs.TaxRateFLG=1 Then '通常課税' 
							when fs.TaxRateFLG=2 Then '軽減課税'
							When fs.TaxRateFlg =0 Then ':非課税'
 							end as 税率区分名,
					fs.CostingKBN as '原価計算方法',
						Case When fs.CostingKBN =1 Then '標準原価'
							when fs.CostingKBN=2 Then '総平均原価'
 							end as 原価計算方法名,
					fs.SaleExcludedFlg as 'Sale対象外区分',
						Case When fs.SaleExcludedFlg =1 Then '対象外'
 							end  as Sale対象外区分名,
					fs.NormalCost as 標準原価,
					fs.PriceOutTax as 税抜定価,
					fs.PriceWithTax as 税込定価,
					fs.OrderPriceWithTax as 発注税込価格,
					fs.OrderPriceWithoutTax as 発注税抜価格,
					fs.Rate as 掛率,
					Convert(varchar(10), fs.SaleStartDate, 111) as 発売開始日,
					Convert(varchar(10), fs.WebStartDate, 111) as Web掲載開始日, 
					fs.OrderAttentionCD as 発注注意区分,
						 (
								Select top 1 mb.Char1   
								from M_MultiPorpose as mb
								where mb.[Key]=fs.OrderAttentionCD
								and ID=316
						) as 発注注意区分名,
					fs.OrderAttentionNote as 発注注意事項,
					fs.CommentInStore as 管理用備考,
					fs.CommentOutStore as 表示用備考,
					fs.Rack as 棚番 ,
					fs.LastYearTerm as 年度,
					fs.LastSeason as シーズン,
					fs.LastCatalogNO as カタログ番号,
					fs.LastCatalogPage as カタログページ,
					fs.LastCatalogNOLong as カタログ番号Long,
					fs.LastCatalogPageLong as カタログページLong,
					fs.LastCatalogText as カタログ情報,
					fs.LastInstructionsNO as 指示書番号,
					CONVERT(varchar(10), fs.LastInstructionsDate, 111) as 指示書発行日,
					fs.WebAddress as 商品情報アドレス,
					fs.SetSU as 構成数,
					fs.OrderLot  as 発注ロット,
					ft1.TagName as タグ1,
					ft2.TagName as タグ2,
					ft3.TagName as タグ3,
					ft4.TagName as タグ4,
					ft5.TagName as タグ5,
					ft6.TagName as タグ6,
					ft7.TagName as タグ7,
					ft8.TagName as タグ8,
					ft9.TagName as タグ9,
					ft10.TagName as タグ10,
					'' as APIKey,
					'' as サイト商品CD
			
				from #TAdminNo as tmp
				left outer join F_SKU(@changedate) as fs on tmp.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,1) as ft1 on ft1.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,2) as ft2 on ft2.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,3) as ft3 on ft3.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,4) as ft4 on ft4.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,5) as ft5 on ft5.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,6) as ft6 on ft6.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,7) as ft7 on ft7.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,8) as ft8 on ft8.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,9) as ft9 on ft9.AdminNO=fs.AdminNO
				left outer join F_SKUTag(@changedate,10) as ft10 on ft10.AdminNO=fs.AdminNO
				left outer join M_Brand as mb on mb.BrandCD =fs.BrandCD
				left outer join M_Vendor as mv on mv.VendorCD=fs.MainVendorCD
				order by SKUCD
		end
				drop table  #TAdminNo;
				exec dbo.L_Log_Insert @Operator,@Program,@PC,@ProcessMode,@KeyItem
					
END









































































































































