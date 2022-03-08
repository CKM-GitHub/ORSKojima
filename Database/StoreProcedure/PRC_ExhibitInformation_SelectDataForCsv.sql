BEGIN TRY 
	Drop Procedure dbo.[PRC_ExhibitInformation_SelectDataForCsv]
END TRY
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TYPE T_ItemCsv AS TABLE
    (
        [Chk] [varchar](1) ,
        [Item_Code] [varchar](32),
        [Item_Name] [varchar](255),
        [List_Price] [int],
        [Price] [int],
        [Cost] [int],
        [ArariRate] [decimal](5,1),
        [WaribikiRate] [decimal](5,1),
        [ID][int],
        [Brand_Name][varchar](200)
    )
GO


CREATE PROCEDURE [dbo].[PRC_ExhibitInformation_SelectDataForCsv]
	-- Add the parameters for the stored procedure here

	  @TokuisakiCD as varchar(5)
	, @TableCSV		T_ItemCsv READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- ストアド内変数
	DECLARE 
			  @Title_listIN varchar(max)
			, @Title_listSEL varchar(max)
			, @Title_sql nvarchar(max)


	--【Item_ExportFieldからCSV出力する項目を取得】
	DECLARE @strSplit NVARCHAR(MAX) =
	(
		SELECT Export_Fields
		FROM Item_ExportField
		WHERE Export_Name = (SELECT ExportName FROM M_Tokuisaki WHERE TokuisakiCD = @TokuisakiCD)
	);


	--【","で区切られた出力項目を分離してワークテーブルに挿入】
	CREATE TABLE #tmpSplit 
	(	  SplitNum INT identity(1,1)
		, SplitStr NVARCHAR(MAX) NULL
	)
	;

	INSERT INTO #tmpSplit
	 (SplitStr)
	SELECT *
	FROM STRING_SPLIT(@strSplit,',')
	; 



	--【得意先.タイトル出力が有りの場合】

	--【得意先がタイトル行有りか無しかの判断】
	DECLARE @TitleKBN tinyint = 
	(
		SELECT TitleUmuKBN
		FROM M_Tokuisaki
		WHERE TokuisakiCD = @TokuisakiCD
	)
	;
	IF (@TitleKBN = 1)
	BEGIN

			SET @Title_listIN = '';
			SET @Title_listSEL = NULL;
			SET @Title_sql = NULL;


			CREATE TABLE #tmpTitle
			(
				  SplitNum INT
				, SplitStr NVARCHAR(MAX)
			)
			;

			--【変換マスタから表示するタイトルがあれば取得する】
			INSERT INTO #tmpTitle
			SELECT 
				  tmp.SplitNum
				, ISNULL(MHen.CsvTitleName, tmp.SplitStr) AS CsvTitle
			FROM #tmpSplit tmp
			LEFT JOIN M_HENKAN MHen
			ON	MHen.TokuisakiCD = @TokuisakiCD
			AND	MHen.RCMItemName = tmp.SplitStr
			AND	MHen.RCMItemValue = 99999
			;

			--【動的SQLを使用して行と列を入れ替える】
			SELECT @Title_listIN = 
						CASE WHEN @Title_listIN IS NULL THEN '[' + tmp.SplitStr  + ']'
							 ELSE @Title_listIN + ', [' + tmp.SplitStr + '] '
						END
			FROM #tmpTitle tmp
			ORDER BY tmp.SplitNum
			;

			SET @Title_listSEL = REPLACE(@Title_listIN, '[', 'MAX([');
			SET @Title_listSEL = REPLACE(@Title_listSEL, ']', '])');

			SET @Title_sql = 
							'SELECT '
							+
							@Title_listSEL
							+
							+ ' FROM #tmpTitle PIVOT (MAX(SplitStr) FOR SplitStr IN ( '
							+ @Title_listIN
							+ ' )) AS PV '
						;

			EXEC sp_executesql @Title_sql;
			


			DROP TABLE #tmpTitle
			;

	END


	--【明細部データ取得処理】

	-- 動的SQL用変数
	SET @Title_listIN = '';
	SET @Title_listSEL = NULL;
	SET @Title_sql = NULL;

	DECLARE @CurCsvTitle	AS VARCHAR(50);
	DECLARE @CurTableName	AS VARCHAR(50);
	DECLARE @CurStrChar		AS VARCHAR(50);
	DECLARE @CurNumKBN		AS INT;


	--【汎用マスタから実際に出力したい項目を取得する】
	DECLARE CUR_Porpose CURSOR FOR
		SELECT Main.SplitStr AS CsvTitle, Sub.Char1, ISNULL(Sub.Char3, Sub.Char2) StrChar, Sub.Num1 
		FROM #tmpSplit Main
		LEFT JOIN M_MultiPorpose Sub
		ON  Sub.[id] = 2
		AND Sub.[Key] = Main.SplitStr
		ORDER BY Main.SplitNum
	;

	--カーソルオープン
    OPEN CUR_Porpose;

	--最初の1行目を取得して変数へ値をセット
	FETCH NEXT FROM CUR_Porpose
	INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN;

	--データの行数分ループ処理を実行する
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ループ内の実際の処理 ここから===*******************CUR_Porpose

		IF (@CurNumKBN = 0)
		BEGIN
				IF (@Title_sql IS NOT NULL)
				BEGIN
					SET @Title_sql = 'SELECT ';
				END
				ELSE
				BEGIN
					SET @Title_sql = @Title_sql + ', ';
				END


				SET @Title_sql = @Title_sql + @CurStrChar;
		END
		IF (@CurNumKBN = 1)
		BEGIN
				IF (@Title_sql IS NOT NULL)
				BEGIN
					SET @Title_sql = 'SELECT ' ;
				END
				ELSE
				BEGIN
					SET @Title_sql = @Title_sql + ', ' ;
				END

				SET @Title_sql = @Title_sql + ' CASE CHARINDEX('' '',' + @CurStrChar + ' )' 
											+ '   WHEN 0 THEN ' + @CurStrChar
											+ '   ELSE SUBSTRING(' + @CurStrChar + ', 1, CHARINDEX('' '', ' + @CurStrChar + '))'
											+ ' END '
								;
		END



		--次の行のデータを取得して変数へ値をセット
		FETCH NEXT FROM CUR_Porpose
		INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN;

	END	-- LOOPの終わり***************************************CUR_Porpose

	--カーソルを閉じる
    CLOSE CUR_Porpose;
    DEALLOCATE CUR_Porpose;
	


	IF (@Title_sql IS NOT NULL)
	BEGIN
		
		SET @Title_sql = @Title_sql 
							+ ' FROM @TableCSV Main'
							+ ' LEFT JOIN Item_Master ON Item_Master.[ID] = Main.[ID]'
							+ ' LEFT JOIN Monotaro_Item_Master ON Monotaro_Item_Master.[ID] = Main.[ID]'
		;


		EXECUTE sp_executesql @Title_sql;

	END






	--【最後にワークテーブルを削除する】
	--DROP TABLE #tmpSplit
	--;

	DROP TYPE T_ItemCsv
	;


					
END