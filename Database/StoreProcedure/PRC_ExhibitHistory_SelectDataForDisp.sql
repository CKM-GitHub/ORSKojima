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

	  @TokuisakiCD	as nvarchar(5)
	, @ExhibitDate1	as nvarchar(10)
	, @ExhibitDate2	as nvarchar(10)
	, @BrandName	as nvarchar(200)
	, @Item_Name1	as nvarchar(200)
	, @Item_Name2	as nvarchar(200)
	, @Item_Code1	as nvarchar(32)
	, @Item_Code2	as nvarchar(32)
	, @Item_Code3	as nvarchar(32)
	, @Item_Code4	as nvarchar(32)
	, @Item_Code5	as nvarchar(32)
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
			, @CommentBrand		nvarchar(1000)			-- ブランド名
			, @CommentItemName	nvarchar(1000)			-- 商品名
			, @CommentItemCode	nvarchar(1000)			-- 商品番号
			, @CommentArari     nvarchar(1000)			-- 粗利率
			, @CommentWaribiki  nvarchar(1000)			-- 割引率
			, @AddFlg			bit

	
	--【ブランド名】
	IF (@BrandName IS NOT NULL)
	BEGIN
		SET @CommentBrand = N' AND (Main.Brand_Name LIKE N''%' + @BrandName + '%''' + ') '
	END

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

	--【粗利率】
	IF (@GrossProfit IS NOT NULL)
	BEGIN
		
		SET @CommentArari = ' AND Main.ArariRate < ' + CONVERT(NVARCHAR, @GrossProfit)

	END

	--【割引率】
	IF (@Discount IS NOT NULL)
	BEGIN
		
		SET @CommentWaribiki = ' AND Main.WaribikiRate >= ' + CONVERT(NVARCHAR, @Discount)

	END



	-- 抽出用クエリ
	SET @SSql = 
	'	SELECT 
			  CONVERT(NVARCHAR,Main.ExhibitDate,111) AS ExhibitDate
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
	 + '  AND Main.ExhibitDate >= ' + '''' + @ExhibitDate1 + ''''
	 + '  AND Main.ExhibitDate <= ' + '''' + @ExhibitDate2 + ''''
	 + ISNULL(@CommentBrand,'')
	 + ISNULL(@CommentItemName,'')
	 + ISNULL(@CommentItemCode,'')
	 + ISNULL(@CommentArari,'')
	 + ISNULL(@CommentWaribiki,'')
	 + ' ORDER BY Main.ExhibitDate, Main.Item_Code, Main.TokuisakiCD, Main.Counter '
	;

	EXECUTE sp_executesql @SSql, N'@TokuisakiCD NVARCHAR(5), @ExhibitDate1 NVARCHAR(10), @ExhibitDate2 NVARCHAR(10), @BrandName NVARCHAR(200), @Item_Name1 NVARCHAR(200), @Item_Name2 NVARCHAR(200) ,@Item_Code1 NVARCHAR(32), @Item_Code2 NVARCHAR(32), @Item_Code3 NVARCHAR(32), @Item_Code4 NVARCHAR(32), @Item_Code5 NVARCHAR(32), @GrossProfit DECIMAL(4,1), @Discount DECIMAL(4,1) ', 
		  @TokuisakiCD	= @TokuisakiCD
		, @ExhibitDate1	= @ExhibitDate1
		, @ExhibitDate2	= @ExhibitDate2
		, @BrandName	= @BrandName
		, @Item_Name1	= @Item_Name1
		, @Item_Name2	= @Item_Name2
		, @Item_Code1	= @Item_Code1
		, @Item_Code2	= @Item_Code2
		, @Item_Code3	= @Item_Code3
		, @Item_Code4	= @Item_Code4
		, @Item_Code5	= @Item_Code5
		, @GrossProfit	= @GrossProfit
		, @Discount		= @Discount
	


					
END