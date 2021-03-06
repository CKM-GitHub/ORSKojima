BEGIN TRY 
	Drop Procedure dbo.[PRC_ExhibitInformation_SelectDataForDisp]
END TRY
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRC_ExhibitInformation_SelectDataForDisp]
	-- Add the parameters for the stored procedure here

	  @TokuisakiCD as nvarchar(5)
	, @BrandName as nvarchar(200)
	, @Item_Name1 as nvarchar(200)
	, @Item_Name2 as nvarchar(200)
	, @Item_Code1 as nvarchar(32)
	, @Item_Code2 as nvarchar(32)
	, @Item_Code3 as nvarchar(32)
	, @Item_Code4 as nvarchar(32)
	, @Item_Code5 as nvarchar(32)
	, @GrossProfit as decimal(4,1)
	, @Discount as decimal(4,1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- ストアド内変数
	DECLARE 
			  @SSql				nvarchar(MAX)
			, @SSql1			nvarchar(MAX)
			, @CommentItemName	nvarchar(1000)			-- 商品名
			, @CommentItemCode	nvarchar(1000)			-- 商品番号
			, @AddFlg			bit
			, @TableName		nvarchar(100)
			, @ColumnName		nvarchar(100)


	--【商品名】
	IF (@Item_Name1 IS NOT NULL)
	BEGIN
		SET @CommentItemName = N' AND (Main.Item_Name LIKE N''%' + @Item_Name1 + '%'''

		IF (@Item_Name2 IS NOT NULL)
		BEGIN
			SET @CommentItemName = @CommentItemName + N' OR Main.Item_Name LIKE N''%' + @Item_Name2 + '%''' + ') '
		END
		ELSE
		BEGIN
			SET @CommentItemName = @CommentItemName + ' )'
		END
	END
	ELSE
	BEGIN
		IF(@Item_Name2 IS NOT NULL)
		BEGIN
			SET @CommentItemName = N' AND (Main.Item_Name LIKE N''%' + @Item_Name2 + '%''' + ') '
		END
	END

	--【商品番号】
	SET @AddFlg = 0;
	IF (ISNULL(@Item_Code1,'') + ISNULL(@Item_Code2,'') + ISNULL(@Item_Code3,'') + ISNULL(@Item_Code4,'') + ISNULL(@Item_Code5,'') <> '')
	BEGIN
		SET @CommentItemCode = ' AND ( '

		IF (@Item_Code1 IS NOT NULL)
		BEGIN
			SET @CommentItemCode = @CommentItemCode + N' Main.Item_Code LIKE N''%' + @Item_Code1 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code2 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + N' Main.Item_Code LIKE N''%' + @Item_Code2 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code3 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + N' Main.Item_Code LIKE N''%' + @Item_Code3 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code4 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + N' Main.Item_Code LIKE N''%' + @Item_Code4 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code5 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + N' Main.Item_Code LIKE N''%' + @Item_Code5 + '%'''
			SET @AddFlg = 1
		END


		SET @CommentItemCode = @CommentItemCode + ' ) '
	END

		
	--【粗利率・割引率以外の条件でデータを抽出】
	CREATE TABLE #tmpSelectData
	(
	  [CheckTaishou] tinyint NULL
	, [Item_Code] nvarchar(32) COLLATE database_default NULL
	, [Item_Name] nvarchar(255) COLLATE database_default NULL
	, [List_Price] int NULL
	, [Price] int NULL
	, [Cost] int NULL
	, [GrossProfit] decimal(4,1) NULL
	, [Discount] decimal(4,1) NULL
	, [ID] int NULL
	, [Brand_Name] nvarchar(200) COLLATE database_default NULL
	)
	;

	-- 抽出用クエリ
	SET @SSql = 
	'	INSERT INTO #tmpSelectData
		SELECT 
			  0
			, Main.Item_Code
			, Main.Item_Name
			, ISNULL(Item.List_Price,0)
			, 0 as Price
			, ISNULL(Item.Cost,0)
			, 0 as GrossProfit
			, 0 as Discount
			, Main.ID
			, Main.Brand_Name

		FROM D_ShoppingCart Main
		LEFT JOIN Item_Master Item ON Item.ID = Main.ID
		LEFT JOIN M_MultiPorpose MP ON MP.ID = 1
								   AND MP.[Key] = @TokuisakiCD
		WHERE	ISNULL(Main.Brand_Name,'''') LIKE ''%'' + ISNULL(@BrandName,'''') + ''%''
	'
	 + ISNULL(@CommentItemName,'')
	 + ISNULL(@CommentItemCode,'')
	;

	EXECUTE sp_executesql @SSql, N'@TokuisakiCD NVARCHAR(5), @BrandName NVARCHAR(200), @Item_Name1 NVARCHAR(200), @Item_Name2 NVARCHAR(200) ,@Item_Code1 NVARCHAR(32), @Item_Code2 NVARCHAR(32), @Item_Code3 NVARCHAR(32), @Item_Code4 NVARCHAR(32), @Item_Code5 NVARCHAR(32)', 
		  @TokuisakiCD = @TokuisakiCD
		, @BrandName = @BrandName
		, @Item_Name1 = @Item_Name1
		, @Item_Name2 = @Item_Name2
		, @Item_Code1 = @Item_Code1
		, @Item_Code2 = @Item_Code2
		, @Item_Code3 = @Item_Code3
		, @Item_Code4 = @Item_Code4
		, @Item_Code5 = @Item_Code5



	--【販売価格を取得してtmpにUPDATE】
	SELECT
		  @TableName = Char1			-- Item_Master            or Monotaro_Item_Master_Addon
		, @ColumnName = Char2			-- Item_Master.SalesPrice or Monotaro_Item_Master_Addon.SalesPrice
	FROM M_MultiPorpose
	WHERE [ID] = 1
	AND  [KEY] = @TokuisakiCD
	;


	IF (@TableName = 'Item_Master' OR @TableName = 'Monotaro_Item_Master_Addon')
	BEGIN
		
		SET @SSql1	= 
			' UPDATE tmp 
			  SET tmp.Price = ISNULL(' + @ColumnName + ', 0) '
			+
			' FROM #tmpSelectData tmp
				LEFT JOIN Item_Master ON tmp.ID = Item_Master.ID 
				LEFT JOIN Monotaro_Item_Master ON Monotaro_Item_Master.Item_ID = Item_Master.ID
				LEFT JOIN Monotaro_Item_Master_Addon ON Monotaro_Item_Master_Addon.ID = Monotaro_Item_Master.ID
			'

		EXECUTE sp_executesql @SSql1

	END



	--【粗利率・割引率の算出(小数点以下1桁までで四捨五入)】
	-- 粗利率 = (販売価格 - 原価) / 販売価格
	-- 割引率 = (定価 - 販売価格) / 定価

	UPDATE tmp
		SET   GrossProfit =
					CONVERT(DECIMAL(4,1),
								CASE tmp.Price
									WHEN 0 THEN 0
									ELSE ROUND(CONVERT(DECIMAL,(tmp.Price - tmp.Cost)) / CONVERT(DECIMAL,TMP.Price) * 100,1)
								END
							)
			, Discount = 
					CONVERT(DECIMAL(4,1),
								CASE tmp.List_Price
									WHEN 0 THEN 0
									ELSE ROUND(CONVERT(DECIMAL,(tmp.List_Price - tmp.Price)) / CONVERT(DECIMAL,TMP.List_Price) * 100,1)
								END
							)
	FROM #tmpSelectData tmp
	;

	--【粗利率/割引率が指定された場合、不要データを削除する】
	-- 粗利率 (画面で指定された数値以上の値は削除)
	IF (@GrossProfit IS NOT NULL)
	BEGIN
		
		DELETE 
		FROM #tmpSelectData
		WHERE GrossProfit >= @GrossProfit
		;

	END

	-- 割引率 (画面で指定された数値未満の値は削除)
	IF (@Discount IS NOT NULL)
	BEGIN

		DELETE 
		FROM #tmpSelectData
		WHERE Discount < @Discount
		;

	END



	--【画面表示用データを取得】
	SELECT tmp.*
	FROM #tmpSelectData tmp
	ORDER BY tmp.Item_Code
	;


	--【一時テーブルを削除】
	DROP TABLE #tmpSelectData
	;


					
END