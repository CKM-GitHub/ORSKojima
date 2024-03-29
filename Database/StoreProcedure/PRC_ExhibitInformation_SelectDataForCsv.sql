IF OBJECT_ID ( 'PRC_ExhibitInformation_SelectDataForCsv', 'P' ) IS NOT NULL
    Drop Procedure dbo.[PRC_ExhibitInformation_SelectDataForCsv]
GO
IF EXISTS (select * from sys.table_types where name = 'T_ItemCsv')
    Drop TYPE dbo.[T_ItemCsv]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TYPE T_ItemCsv AS TABLE
    (
        [Chk] [nvarchar](1) ,
        [Item_Code] [nvarchar](32),
        [Item_Name] [nvarchar](255),
        [List_Price] [int],
        [Price] [int],
        [Cost] [int],
        [ArariRate] [decimal](5,1),
        [WaribikiRate] [decimal](5,1),
        [ID][int],
        [Brand_Name][nvarchar](200)
    )
GO


CREATE PROCEDURE [dbo].[PRC_ExhibitInformation_SelectDataForCsv]
	-- Add the parameters for the stored procedure here

	  @TokuisakiCD	as nvarchar(5)
	, @TableCSV		T_ItemCsv READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		-- ストアド内変数
		DECLARE 
				  @Title_listIN nvarchar(max)
				, @Title_listSEL nvarchar(max)
				, @Title_sql nvarchar(max)
				, @Detail_sql nvarchar(max)
				, @Henkan_sql nvarchar(max)
				, @Output_sql nvarchar(max)
				, @StrSql nvarchar(max)
				, @StrWrkSql nvarchar(max)
				, @strOutput nvarchar(max)
				, @RowCnt int
				, @MaxRowCnt int


		/* -------------------------------------------------- */
		/*     項目転送表01 №Ⅰ タイトル行有り無しの判断     */
		/* -------------------------------------------------- */

		--【得意先がタイトル行有りか無しかの判断】
		DECLARE @TitleKBN tinyint = 
		(
			SELECT TitleUmuKBN
			FROM M_Tokuisaki
			WHERE TokuisakiCD = @TokuisakiCD
		)
		;


		/* ---------------------------------------- */
		/*      項目転送表01 №Ⅱ CSV項目の取得     */
		/* ---------------------------------------- */

		--【Item_ExportFieldからCSV出力する項目を取得】
		DECLARE @strSplit NVARCHAR(MAX) =
		(
			SELECT Export_Fields
			FROM Item_ExportField
			WHERE Export_Name = (SELECT ExportName FROM M_Tokuisaki WHERE TokuisakiCD = @TokuisakiCD)
		);

		-- 定義がない場合は処理終了
		IF (@strSplit IS NULL)
		BEGIN
			RETURN NULL;
		END


		--【","で区切られた出力項目を分離してワークテーブルに挿入】
		CREATE TABLE #tmpSplit 
		(	  SplitNum INT identity(1,1)
			, SplitStr NVARCHAR(MAX) COLLATE database_default NULL
		)
		;

		INSERT INTO #tmpSplit
		 (SplitStr)
		SELECT *
		FROM STRING_SPLIT(@strSplit,',')
		; 


		--【出力する項目数を取得する】
		SET @MaxRowCnt =
		(
			SELECT COUNT(*)
			FROM #tmpSplit
		);

		-- 出力する項目がない場合は処理終了
		IF (@MaxRowCnt = 0)
		BEGIN
			RETURN NULL;
		END



		--【最終的に出力する値を格納する為のテーブルを作成】
		--     項目数が不明な為、
		--     CREATE TABLE *** ([RowNum],[CsvVaue1],[CsvValue2],[CsvValue3], ..... )と項目数に応じて動的に作成   → グローバル一時テーブルになる

		SET @StrSql = '';				-- CREATE TABLE用変数
		SET @StrWrkSql = '';			-- 作成したワークテーブルに対し ヘッダー・明細データをINSERTする時に使用する変数

		SET @StrSql = @StrSql + ' CREATE TABLE ##tmpOutputValue '
		SET @StrSql = @StrSql + ' ('
		SET @StrSql = @StrSql + '   [RowNum] int identity(1,1) '

		SET @RowCnt = 1;
		WHILE (@RowCnt < @MaxRowCnt + 1)
		BEGIN
			SET @StrSql = @StrSql + ' , [CsvValue' + CONVERT(NVARCHAR,@RowCnt) + '] [nvarchar](max) COLLATE database_default';

			IF(@RowCnt = 1)
			BEGIN
				SET @StrWrkSql = ' (';
			END
			ELSE
			BEGIN
				SET @StrWrkSql = @StrWrkSql + ', '
			END
			
			SET @StrWrkSql = @StrWrkSql + ' CsvValue' + CONVERT(NVARCHAR,@RowCnt) 

			SET @RowCnt = @RowCnt + 1;
		END

		SET @StrSql = @StrSql + ' )';
		SET @StrWrkSql = @StrWrkSql + ') ';

		EXECUTE sp_executesql @StrSql;

		SET @StrSql = '';


		-- インデックスを作成
		CREATE INDEX Idx_tmpOutputValue ON ##tmpOutputValue (RowNum);



		/* ------------------------------------------------------------ */
		/*     項目転送表01 №Ⅲ (Ⅰ)でタイトル行有りだった場合のみ     */
		/* ------------------------------------------------------------ */

		--============↓【CSVタイトル部データ取得処理】↓============--

		SET @Title_listIN = NULL;		-- PIVOT句で使用する変数1
		SET @Title_listSEL = NULL;		-- PIVOT句で使用する変数2
		SET @Title_sql = NULL;			-- 最終的にクエリを作成する為の変数


		CREATE TABLE #tmpTitle
		(
			  SplitNum INT
			, SplitStr NVARCHAR(MAX) COLLATE database_default
		)
		;

		--【変換マスタから表示するタイトルがあれば取得する】
		INSERT INTO #tmpTitle
		SELECT 
				tmp.SplitNum
			--, ISNULL(MHen.CsvTitleName, tmp.SplitStr) AS CsvTitle
			, CASE WHEN MHen.CsvTitleName IS NULL THEN tmp.SplitStr ELSE MHen.CsvTitleName END AS CsvTitle
		FROM #tmpSplit tmp
		LEFT JOIN M_HENKAN MHen
		ON	MHen.TokuisakiCD = @TokuisakiCD
		AND	MHen.RCMItemName = tmp.SplitStr
		AND	MHen.RCMItemValue = '99999'
		ORDER BY tmp.SplitNum
		;

		--【動的SQLを使用して行と列を入れ替える】
		SELECT	  @Title_listIN = 
					CASE WHEN @Title_listIN IS NULL THEN '[' + tmp.SplitStr  + ']'
							ELSE @Title_listIN + ', [' + tmp.SplitStr + '] '
					END

				, @Title_listSEL = 
					CASE WHEN @Title_listSEL IS NULL THEN '[' + tmp.SplitStr  + '] '
							ELSE @Title_listSEL + ', [' + tmp.SplitStr + '] ' 
					END

		FROM #tmpTitle tmp
		ORDER BY tmp.SplitNum
		;

		SET @Title_listSEL = REPLACE(@Title_listSEL, '[', 'MAX([');
		SET @Title_listSEL = REPLACE(@Title_listSEL, ']', '])');


		-- タイトルが必要な得意先の場合
		IF (@TitleKBN = 1)
		BEGIN

			SET @Title_sql = 'INSERT INTO ##tmpOutputValue '
							+ @StrWrkSql
							+ ' SELECT '
							+ @Title_listSEL
							+ ' FROM #tmpTitle PIVOT (MAX(SplitStr) FOR SplitStr IN ( '
							+ @Title_listIN
							+ ' )) AS PV '
						;

			EXECUTE sp_executesql @Title_sql;

		END

		--============↑【CSVタイトル部データ取得処理】↑============--



		--============↓【明細部データ取得処理】↓============--

		-- 動的SQL用変数
		SET @Henkan_sql = NULL;			-- M_HenkanをREADする為に使用する変数
		SET @Detail_sql = NULL;			-- 最終的にクエリを作成する為の変数


		-- CUR_Porpose用変数
		DECLARE @CurCsvTitle	AS NVARCHAR(100);
		DECLARE @CurTableName	AS NVARCHAR(200);
		DECLARE @CurStrChar		AS NVARCHAR(200);
		DECLARE @CurNumKBN		AS INT;
		DECLARE @CurChar3		AS NVARCHAR(200);

		-- CUR_Output用変数
		DECLARE @CurRowNum		AS INT;



		-- 【動的SQLの為に一時テーブルにデータを移行する】
		CREATE TABLE #tmpItemCsv
		(
			[RowNum] [int]  identity(1,1),
			[Chk] [nvarchar](1) COLLATE database_default,
			[Item_Code] [nvarchar](32) COLLATE database_default,
			[Item_Name] [nvarchar](255) COLLATE database_default,
			[List_Price] [int],
			[Price] [int],
			[Cost] [int],
			[ArariRate] [decimal](5,1),
			[WaribikiRate] [decimal](5,1),
			[ID][int],
			[Brand_Name][nvarchar](200) COLLATE database_default
		);


		INSERT #tmpItemCSV
		(
			[Chk] ,
			[Item_Code],
			[Item_Name],
			[List_Price],
			[Price],
			[Cost],
			[ArariRate],
			[WaribikiRate],
			[ID],
			[Brand_Name]
		)
		SELECT *
		FROM @TableCSV
		ORDER BY [ID]
		;

		/* ------------------------------------------------------------------------------------ */
		/*     項目転送表01 №Ⅳ (Ⅱ)で取得したエクスポート定義を変換し、抽出する項目を決定     */
		/* ------------------------------------------------------------------------------------ */

		/* --------------------------------------------------------------------------------- */
		/*     項目転送表01 №Ⅴ 画面.対象チェックボックス=ONの行に対してCSVデータを出力     */
		/* --------------------------------------------------------------------------------- */

		--【汎用マスタから実際に出力したい項目を取得する】
		DECLARE CUR_Porpose CURSOR FOR
			SELECT Main.SplitStr AS CsvTitle, Sub.Char1, CASE WHEN Sub.Char3 IS NULL THEN Sub.Char2 ELSE Sub.Char3 END AS StrChar, Sub.Num1, Sub.Char3
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
		INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN, @CurChar3;

		--データの行数分ループ処理を実行する
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			-- ループ内の実際の処理 ここから===*******************CUR_Porpose

			IF (@Henkan_sql IS NULL)
			BEGIN
				SET @Henkan_sql = 'SELECT @parOutput = ';
			END
			ELSE
			BEGIN
				SET @Henkan_sql = @Henkan_sql + ' + '','' +  ';
			END


			--実際に出力したい項目を各テーブルから取得する
			--（後でSTRING_SPLITを使用したい為、取得した項目内に","がある場合[comma]の文字列に変換する）

			IF (@CurChar3 IS NOT NULL)		-- M_MultiPorposeに固定値が設定されている場合
			BEGIN
				
				SET @Henkan_sql = @Henkan_sql + 'N' + '''' + REPLACE(@CurStrChar,',','[comma]') + '''' ;

			END
			ELSE
			BEGIN							-- M_MultiPorposeに固定値が設定されていない場合
				
				IF (@CurStrChar IS NOT NULL)	-- 取得するテーブル項目が指定されている場合
				BEGIN

					IF (@CurNumKBN = 1)		-- Num1 = 1 の時、文字列内で最初のスペースまでの値を採用する場合
					BEGIN
						SET @Henkan_sql = @Henkan_sql + ' REPLACE( '

						SET @Henkan_sql = @Henkan_sql + ' ISNULL('
						SET @Henkan_sql = @Henkan_sql + '   CASE CHARINDEX('' '',' + @CurStrChar + ' )' 
													  + '     WHEN 0 THEN ' + @CurStrChar
													  + '     ELSE SUBSTRING(' + @CurStrChar + ', 1, CHARINDEX('' '', ' + @CurStrChar + ') - 1)'
													  + '   END '
						SET @Henkan_sql = @Henkan_sql + '  , '''') '

						SET @Henkan_sql = @Henkan_sql + ' , '','', ''[comma]'') '
						;
					END
					ELSE					-- Num1 = 0 で値をそのまま出力する場合
					BEGIN

						SET @Henkan_sql = @Henkan_sql +  ' REPLACE( ISNULL(CONVERT(NVARCHAR(MAX), ' + @CurStrChar + '), '''') ,'','' , ''[comma]'') ';

					END
				END
				ELSE	-- 出力する文字が無い場合
				BEGIN

					SET @Henkan_sql = @Henkan_sql + '''' + '''';

				END

			END


			--次の行のデータを取得して変数へ値をセット
			FETCH NEXT FROM CUR_Porpose
			INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN, @CurChar3;

		END	-- LOOPの終わり***************************************CUR_Porpose

		--カーソルを閉じる
		CLOSE CUR_Porpose;
		DEALLOCATE CUR_Porpose;


		-- 上記の動的SQLに対して FROM から JOIN句まで変数に追加する
		SET @Henkan_sql = @Henkan_sql + ' FROM #tmpItemCSV Main '

		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Item_Master ON Item_Master.[ID] = Main.[ID] '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Monotaro_Item_Master ON Monotaro_Item_Master.[Item_ID] = Main.[ID] '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Item_Master_Addon ON Item_Master_Addon.[ID] = Item_Master.[ID] '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Monotaro_Item_Master_Addon ON Monotaro_Item_Master_Addon.[ID] = Monotaro_Item_Master.[ID] '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Template_Detail ON Template_Detail.Item_Code = Main.Item_Code '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Dangarous_Goods ON Dangarous_Goods.Dangarous_Goods_ID = Monotaro_Item_Master.Dangarous_Goods '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Dangerous_Goods_Name ON Dangerous_Goods_Name.Dangarous_Goods_Name_ID = Monotaro_Item_Master.Dangarous_Goods_Name '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Risk_Rating ON Risk_Rating.Risk_Rating_ID = Monotaro_Item_Master.Risk_Rating '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Dangerous_Goods_Nature ON Dangerous_Goods_Nature.Dangerous_Goods_Nature_ID = Monotaro_Item_Master.Dangerous_Goods_Nature '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Procurement_Goods ON Procurement_Goods.Procurement_Goods_ID = Monotaro_Item_Master_Addon.Procurement_Goods '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN RoHS_Directive ON RoHS_Directive.RoHS_Directive_ID = Monotaro_Item_Master_Addon.RoHS_Directive '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Medical_Supplies ON Medical_Supplies.Medical_Supplies_ID = Monotaro_Item_Master_Addon.Medical_Supplies '


		-- 変換マスタをREADする為のテーブル
		CREATE TABLE #tmpHenkan
		(
			  [SplitNum] INT identity(1,1)
			, [SplitTitle]  [NVARCHAR](MAX) COLLATE database_default
			, [SplitStr]  [NVARCHAR](MAX) COLLATE database_default
		)
		;


		--
		DECLARE @FirstFLG tinyint;
		SET @FirstFLG = 1;


		-- 出力対象データについて1件ずつ処理する
		DECLARE CUR_Output CURSOR FOR
			SELECT RowNum
			FROM #tmpItemCSV
			ORDER BY RowNum
		;

		--カーソルオープン
		OPEN CUR_Output;

		--最初の1行目を取得して変数へ値をセット
		FETCH NEXT FROM CUR_Output
		INTO @CurRowNum;

		--データの行数分ループ処理を実行する
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- ループ内の実際の処理 ここから===*******************CUR_Output
				
				-- 出力項目を","繋ぎの文字列として@strOutput変数に挿入
				SET @strOutput = '';
				SET @Detail_sql = '';

				SET @Detail_sql = @Henkan_sql 
				SET @Detail_sql = @Detail_sql + ' WHERE Main.RowNum = ' + CONVERT(NVARCHAR,@CurRowNum)
				

				EXECUTE sp_executesql @Detail_sql, N'@parOutput NVARCHAR(MAX) OUTPUT', @parOutput = @strOutput OUTPUT;


				--　INSERT前にワークテーブルをTRUNCATE([SplitNum]がidentity値の為)
				TRUNCATE TABLE #tmpHenkan
				;

				--　文字列のデータを","で区切って変換マスタ用テーブルに挿入
				INSERT INTO #tmpHenkan
				([SplitStr])
				SELECT *
				FROM STRING_SPLIT(@strOutput,',')
				; 

				-- M_Henkanをreadする時に必要なExport_fieldsの1つ1つをテーブルにUpdate
				UPDATE Main
				SET Main.SplitTitle = Sub.SplitStr
				FROM #tmpHenkan Main
				INNER JOIN #tmpSplit Sub
				ON Sub.SplitNum = Main.SplitNum
				;

				-- M_Henkanを結合して、値の変換値があった場合はそちらを使用する
				UPDATE tmp
				SET tmp.SplitStr = CASE WHEN  MH.CsvOutputItemValue IS NULL THEN tmp.SplitStr ELSE MH.CsvOutputItemValue END
				FROM #tmpHenkan tmp
				LEFT JOIN M_Henkan MH
				ON  MH.TokuisakiCD = @TokuisakiCD
				AND MH.RCMItemName = tmp.SplitTitle
				AND MH.RCMItemValue = tmp.SplitStr
				;

				IF (@FirstFLG = 1)
				BEGIN

					SET @RowCnt = 1;

					--最終出力用##tmpOutputValue に行を挿入
					SET @Output_sql = '';

					SET @Output_sql = 'INSERT INTO ##tmpOutputValue '
					SET @Output_sql = @Output_sql + @StrWrkSql
					SET @Output_sql = @Output_sql + ' SELECT '

					WHILE (@RowCnt < @MaxRowCnt + 1)
					BEGIN
					
						IF (@RowCnt > 1)
						BEGIN
							--SET @Output_sql = @Output_sql + ' + '','' + '
							SET @Output_sql = @Output_sql + ' , '
						END

						--[comma]を","に戻す
						SET @Output_sql = @Output_sql + ' REPLACE(MAX(CASE SplitNum WHEN ' + CONVERT(NVARCHAR,@RowCnt) + ' THEN SplitStr ELSE '''' END ), ''[comma]'', '','') '

						SET @RowCnt = @RowCnt + 1;

					END
				
					SET @Output_sql = @Output_sql + ' FROM #tmpHenkan '

					SET @FirstFLG = 0;

				END


				EXECUTE sp_executesql @Output_sql;



			--次の行のデータを取得して変数へ値をセット
			FETCH NEXT FROM CUR_Output
			INTO @CurRowNum;

		END	-- LOOPの終わり***************************************CUR_Output

		--カーソルを閉じる
		CLOSE CUR_Output;
		DEALLOCATE CUR_Output;

	
		--============↑【明細部データ取得処理】↑============--




		--【出力データを取得】
		SELECT *
		FROM ##tmpOutputValue
		--↓OrderByはC#側で実行する
		--ORDER BY RowNum
		;


		--【最後にワークテーブルを削除する】
		DROP TABLE #tmpTitle
		;
		DROP TABLE #tmpSplit
		;
		DROP TABLE #tmpItemCSV
		;
		DROP TABLE #tmpHenkan
		;
		DROP TABLE ##tmpOutputValue
		;

					
END