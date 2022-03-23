BEGIN TRY 
	Drop Procedure dbo.[PRC_ExhibitHistory_SelectDataForDisp]
END TRY
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRC_ExhibitHistory_SelectDataForDisp]
	-- Add the parameters for the stored procedure here

	  @TokuisakiCD	as varchar(5)
	, @ExhibitDate1	as varchar(10)
	, @ExhibitDate2	as varchar(10)
	, @BrandName	as varchar(200)
	, @Item_Name1	as varchar(200)
	, @Item_Name2	as varchar(200)
	, @Item_Code1	as varchar(32)
	, @Item_Code2	as varchar(32)
	, @Item_Code3	as varchar(32)
	, @Item_Code4	as varchar(32)
	, @Item_Code5	as varchar(32)
	, @GrossProfit	as decimal(4,1)
	, @Discount		as decimal(4,1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- ストアド内変数
	DECLARE 
			  @SSql				nvarchar(MAX)
			, @CommentItemName	varchar(1000)			-- 商品名
			, @CommentItemCode	varchar(1000)			-- 商品番号
			, @CommentArari     varchar(1000)			-- 粗利率
			, @CommentWaribiki  varchar(1000)			-- 割引率
			, @AddFlg			bit


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

	--【粗利率】
	IF (@GrossProfit IS NOT NULL)
	BEGIN
		
		SET @CommentArari = ' AND Main.ArariRate < ' + CONVERT(VARCHAR, @GrossProfit)

	END

	--【割引率】
	IF (@Discount IS NOT NULL)
	BEGIN
		
		SET @CommentWaribiki = ' AND Main.WaribikiRate >= ' + CONVERT(VARCHAR, @Discount)

	END



	-- 抽出用クエリ
	SET @SSql = 
	'	INSERT INTO #tmpSelectData
		SELECT 
			  CONVERT(VARCHAR,Main.ExhibitDate,111) AS ExhibitDate
			, Main.Item_Code
			, Main.Item_Name
			, Main.List_Price
			, Main.Sale_Price
			, Main.Cost
			, Main.ArariRate
			, Main.WaribikiRate
			, MTok.TokuisakiName

		FROM D_ExhibitHistory Main
		INNER JOIN M_Tokuisaki MTok ON MTok.TokuisakiCD = Main.TokuisakiCD
		WHERE MTok.OyaTokuisakiCD = ' + @TokuisakiCD
	 + '  AND Main.ExhibitDate >= ' + @ExhibitDate1
	 + '  AND Main.ExhibitDate <= ' + @ExhibitDate2
	 + ISNULL(@CommentItemName,'')
	 + ISNULL(@CommentItemCode,'')
	 + ISNULL(@CommentArari,'')
	 + ISNULL(@CommentWaribiki,'')
	 + ' ORDER BY Main.ExhibitDate, Main.Item_Code, Main.TokuisakiCD'
	;

	EXECUTE sp_executesql @SSql, N'@TokuisakiCD VARCHAR(5), @ExhibitDate1 VARCHAR(10), @ExhibitDate2 VARCHAR(10), @BrandName VARCHAR(200), @Item_Name1 VARCHAR(200), @Item_Name2 VARCHAR(200) ,@Item_Code1 VARCHAR(32), @Item_Code2 VARCHAR(32), @Item_Code3 VARCHAR(32), @Item_Code4 VARCHAR(32), @Item_Code5 VARCHAR(32), @GrossProfit DECIMAL(4,1), @Discount DECIMAL(4,1) ', 
		  @TokuisakiCD = @TokuisakiCD
		, @ExhibitDate1 = @ExhibitDate1
		, @ExhibitDate2 = @ExhibitDate2
		, @BrandName = @BrandName
		, @Item_Name1 = @Item_Name1
		, @Item_Name2 = @Item_Name2
		, @Item_Code1 = @Item_Code1
		, @Item_Code2 = @Item_Code2
		, @Item_Code3 = @Item_Code3
		, @Item_Code4 = @Item_Code4
		, @Item_Code5 = @Item_Code5
	


					
END