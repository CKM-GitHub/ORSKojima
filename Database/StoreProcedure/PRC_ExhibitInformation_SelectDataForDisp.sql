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

	  @TokuisakiCD as varchar(5)
	, @BrandName as varchar(200)
	, @Item_Name1 as varchar(200)
	, @Item_Name2 as varchar(200)
	, @Item_Code1 as varchar(32)
	, @Item_Code2 as varchar(32)
	, @Item_Code3 as varchar(32)
	, @Item_Code4 as varchar(32)
	, @Item_Code5 as varchar(32)
	, @GrossProfit as decimal(3,1)
	, @Discount as decimal(3,1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- ストアド内変数
	DECLARE 
			  @SSql				nvarchar(MAX)
			, @SSql1			nvarchar(MAX)
			, @CommentItemName	varchar(1000)			-- 商品名
			, @CommentItemCode	varchar(1000)			-- 商品番号
			, @AddFlg			bit
			, @TableName		varchar(100)
			, @ColumnName		varchar(100)


	--【商品名】
	IF (@Item_Name1 IS NOT NULL)
	BEGIN
		SET @CommentItemName = ' AND (Main.Item_Name LIKE ''%' + @Item_Name1 + '%'''

		IF (@Item_Name2 IS NOT NULL)
		BEGIN
			SET @CommentItemName = @CommentItemName + ' OR Main.Item_Name LIKE ''%' + @Item_Name2 + '%''' + ') '
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
			SET @CommentItemName = ' AND (Main.Item_Name LIKE ''%' + @Item_Name2 + '%''' + ') '
		END
	END

	--【商品番号】
	SET @AddFlg = 0;
	IF (ISNULL(@Item_Code1,'') + ISNULL(@Item_Code2,'') + ISNULL(@Item_Code3,'') + ISNULL(@Item_Code4,'') + ISNULL(@Item_Code5,'') <> '')
	BEGIN
		SET @CommentItemCode = ' AND ( '

		IF (@Item_Code1 IS NOT NULL)
		BEGIN
			SET @CommentItemCode = @CommentItemCode + ' Main.Item_Code LIKE ''%' + @Item_Code1 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code2 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + ' Main.Item_Code LIKE ''%' + @Item_Code2 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code3 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + ' Main.Item_Code LIKE ''%' + @Item_Code3 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code4 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + ' Main.Item_Code LIKE ''%' + @Item_Code4 + '%'''
			SET @AddFlg = 1
		END
		IF (@Item_Code5 IS NOT NULL)
		BEGIN
			IF (@AddFlg = 1) SET @CommentItemCode = @CommentItemCode + ' OR ';
		
			SET @CommentItemCode = @CommentItemCode + ' Main.Item_Code LIKE ''%' + @Item_Code5 + '%'''
			SET @AddFlg = 1
		END


		SET @CommentItemCode = @CommentItemCode + ' ) '
	END

		
	--【粗利率・割引率以外の条件でデータを抽出】
	CREATE TABLE #tmpSelectData
	(
	  [CheckTaishou] tinyint NULL
	, [Item_Code] varchar(32) NULL
	, [Item_Name] varchar(255) NULL
	, [List_Price] int NULL
	, [Price] int NULL
	, [Cost] int NULL
	, [GrossProfit] decimal(3,1) NULL
	, [Discount] decimal(3,1) NULL
	, [ID] int NULL
	, [Brand_Name] varchar(200) NULL
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
		WHERE	Main.Brand_Name LIKE ''%'' + ISNULL(@BrandName,'''') + ''%''
	'
	 + ISNULL(@CommentItemName,'')
	 + ISNULL(@CommentItemCode,'')
	;

	EXECUTE sp_executesql @SSql, N'@TokuisakiCD VARCHAR(5), @BrandName VARCHAR(200), @Item_Name1 VARCHAR(200), @Item_Name2 VARCHAR(200) ,@Item_Code1 VARCHAR(32), @Item_Code2 VARCHAR(32), @Item_Code3 VARCHAR(32), @Item_Code4 VARCHAR(32), @Item_Code5 VARCHAR(32)', 
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
		  @TableName = Char1			-- Item_Master
		, @ColumnName = Char2			-- Item_Master.SalesPrice
	FROM M_MultiPorpose
	WHERE [ID] = 1
	AND  [KEY] = @TokuisakiCD
	;


	IF (@TableName = 'Item_Master')
	BEGIN

		SET @SSql1	= 
			' UPDATE tmp 
			  SET tmp.Price = ISNULL(' + @ColumnName + ', 0) '
			+
			' FROM #tmpSelectData tmp
			  LEFT JOIN Item_Master 
			  ON tmp.ID = Item_Master.ID 
			'

		EXECUTE sp_executesql @SSql1

	END



	--【粗利率・割引率の算出(小数点以下1桁までで四捨五入)】
	UPDATE tmp
		SET   GrossProfit =
						CASE tmp.Price
							WHEN 0 THEN 0
							ELSE ROUND(CONVERT(DECIMAL,(tmp.Price - tmp.Cost)) / CONVERT(DECIMAL,TMP.Price) * 100,1)
						END
			, Discount = 
						CASE tmp.Cost
							WHEN 0 THEN 0
							ELSE ROUND(CONVERT(DECIMAL,(tmp.Cost - tmp.Price)) / CONVERT(DECIMAL,TMP.Cost) * 100,1)
						END
	FROM #tmpSelectData tmp
	;




	--【画面表示用データを取得】
	SELECT tmp.*
	FROM #tmpSelectData tmp
	ORDER BY tmp.Item_Code
	;


	--【一時テーブルを削除】
	DROP TABLE #tmpSelectData
	;


	--SELECT @CommentItemNM
	--;
	--SELECT @CommentItemNum
	--;



					
END