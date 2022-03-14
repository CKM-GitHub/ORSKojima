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


		-- �X�g�A�h���ϐ�
		DECLARE 
				  @Title_listIN varchar(max)
				, @Title_listSEL varchar(max)
				, @Title_sql nvarchar(max)
				, @Detail_sql nvarchar(max)
				, @StrSql nvarchar(max)


		--�yItem_ExportField����CSV�o�͂��鍀�ڂ��擾�z
		DECLARE @strSplit NVARCHAR(MAX) =
		(
			SELECT Export_Fields
			FROM Item_ExportField
			WHERE Export_Name = (SELECT ExportName FROM M_Tokuisaki WHERE TokuisakiCD = @TokuisakiCD)
		);


		--�y","�ŋ�؂�ꂽ�o�͍��ڂ𕪗����ă��[�N�e�[�u���ɑ}���z
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



		SET @Title_listIN = NULL;
		SET @Title_listSEL = NULL;
		SET @Title_sql = NULL;


		CREATE TABLE #tmpTitle
		(
			  SplitNum INT
			, SplitStr NVARCHAR(MAX)
		)
		;

		--�y�ϊ��}�X�^����\������^�C�g��������Ύ擾����z
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

		--�y���ISQL���g�p���čs�Ɨ�����ւ���z
		SELECT	  @Title_listIN = 
					CASE WHEN @Title_listIN IS NULL THEN '[' + tmp.SplitStr  + ']'
							ELSE @Title_listIN + ', [' + tmp.SplitStr + '] '
					END

				, @Title_listSEL = 
					CASE WHEN @Title_listSEL IS NULL THEN '[' + tmp.SplitStr  + '] AS ' + tmp.SplitStr 
							ELSE @Title_listSEL + ', [' + tmp.SplitStr + '] AS ' + tmp.SplitStr 
					END

		FROM #tmpTitle tmp
		ORDER BY tmp.SplitNum
		;

		SET @Title_listSEL = REPLACE(@Title_listSEL, '[', 'MAX([');
		SET @Title_listSEL = REPLACE(@Title_listSEL, ']', '])');

		SET @Title_sql = 
						'SELECT '' '' AS OrderNum,  '
						+
						@Title_listSEL
						+
						+ ' FROM #tmpTitle PIVOT (MAX(SplitStr) FOR SplitStr IN ( '
						+ @Title_listIN
						+ ' )) AS PV '
					;




		--�y���ו��f�[�^�擾�����z

		-- ���ISQL�p�ϐ�
		SET @Detail_sql = NULL;

		DECLARE @CurCsvTitle	AS VARCHAR(50);
		DECLARE @CurTableName	AS VARCHAR(50);
		DECLARE @CurStrChar		AS VARCHAR(50);
		DECLARE @CurNumKBN		AS INT;


		--�y�ėp�}�X�^������ۂɏo�͂��������ڂ��擾����z
		DECLARE CUR_Porpose CURSOR FOR
			SELECT Main.SplitStr AS CsvTitle, Sub.Char1, ISNULL(Sub.Char3, Sub.Char2) StrChar, Sub.Num1 
			FROM #tmpSplit Main
			LEFT JOIN M_MultiPorpose Sub
			ON  Sub.[id] = 2
			AND Sub.[Key] = Main.SplitStr
			ORDER BY Main.SplitNum
		;

		--�J�[�\���I�[�v��
		OPEN CUR_Porpose;

		--�ŏ���1�s�ڂ��擾���ĕϐ��֒l���Z�b�g
		FETCH NEXT FROM CUR_Porpose
		INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN;

		--�f�[�^�̍s�������[�v���������s����
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- ���[�v���̎��ۂ̏��� ��������===*******************CUR_Porpose

			IF (@CurNumKBN = 0)
			BEGIN
					IF (@Detail_sql IS NULL)
					BEGIN
						SET @Detail_sql = 'SELECT Main.Item_Code as OrderNum, ';
					END
					ELSE
					BEGIN
						SET @Detail_sql = @Detail_sql + ', ';
					END


					SET @Detail_sql = @Detail_sql +  ' CONVERT(VARCHAR(MAX), ' + @CurStrChar + ') ';
			END
			IF (@CurNumKBN = 1)
			BEGIN
					IF (@Detail_sql IS NULL)
					BEGIN
						SET @Detail_sql = 'SELECT Main.Item_Code as OrderNum, ' ;
					END
					ELSE
					BEGIN
						SET @Detail_sql = @Detail_sql + ', ' ;
					END

					SET @Detail_sql = @Detail_sql + ' CASE CHARINDEX('' '',' + @CurStrChar + ' )' 
													+ '   WHEN 0 THEN ' + @CurStrChar
													+ '   ELSE SUBSTRING(' + @CurStrChar + ', 1, CHARINDEX('' '', ' + @CurStrChar + '))'
													+ ' END '
					;
			END



			--���̍s�̃f�[�^���擾���ĕϐ��֒l���Z�b�g
			FETCH NEXT FROM CUR_Porpose
			INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN;

		END	-- LOOP�̏I���***************************************CUR_Porpose

		--�J�[�\�������
		CLOSE CUR_Porpose;
		DEALLOCATE CUR_Porpose;
	
		

		-- �y���ISQL�ׂ̈Ɉꎞ�e�[�u���Ƀf�[�^���ڍs����z
		CREATE TABLE #tmp_ItemCsv
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
		);

		INSERT #tmp_ItemCSV
		SELECT *
		FROM @TableCSV
		;



		--�y���Ӑ悪�^�C�g���s�L�肩�������̔��f�z
		DECLARE @TitleKBN tinyint = 
		(
			SELECT TitleUmuKBN
			FROM M_Tokuisaki
			WHERE TokuisakiCD = @TokuisakiCD
		)
		;


		-- �y���ISQL�����s���ăf�[�^���擾�z

		SET @StrSql = '';

		SET @StrSql = @StrSql + ' SELECT ' + @Title_listIN
		SET @StrSql = @StrSql + ' FROM ('
		SET @StrSql = @StrSql + '         ' + @Title_sql
		SET @StrSql = @StrSql + '         UNION  '
		SET @StrSql = @StrSql + '         ' + @Detail_sql
		SET @StrSql = @StrSql + '         FROM #tmp_ItemCSV Main '
		SET @StrSql = @StrSql + '         LEFT JOIN Item_Master ON Item_Master.[ID] = Main.[ID] '
		SET @StrSql = @StrSql + '         LEFT JOIN Monotaro_Item_Master ON Monotaro_Item_Master.[ID] = Main.[ID] '
		SET @StrSql = @StrSql + '      ) Main '
		-- �^�C�g���s�v�̏ꍇ
		IF (@TitleKBN = 0)
		BEGIN
			SET @StrSql = @StrSql + ' WHERE Main.OrderNum <> '' '''
		END
		SET @StrSql = @StrSql + ' ORDER BY Main.OrderNum '


		EXECUTE sp_executesql @StrSql;



		--�y�Ō�Ƀ��[�N�e�[�u�����폜����z
		DROP TABLE #tmpTitle
		;
		DROP TABLE #tmpSplit
		;
		DROP TABLE #tmp_ItemCSV
		;

					
END