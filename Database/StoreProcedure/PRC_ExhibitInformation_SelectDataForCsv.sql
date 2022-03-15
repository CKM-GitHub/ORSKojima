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

	  @TokuisakiCD	as varchar(5)
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
				, @Henkan_sql nvarchar(max)
				, @Output_sql nvarchar(max)
				, @StrSql nvarchar(max)
				, @strOutput nvarchar(max)
				, @RowCnt int
				, @MaxRowCnt int



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


		--�y�o�͂��鍀�ڐ����擾����z
		SET @MaxRowCnt =
		(
			SELECT COUNT(*)
			FROM tmpSplit
		);

		--�y���Ӑ悪�^�C�g���s�L�肩�������̔��f�z
		DECLARE @TitleKBN tinyint = 
		(
			SELECT TitleUmuKBN
			FROM M_Tokuisaki
			WHERE TokuisakiCD = @TokuisakiCD
		)
		;


		--�y�ŏI�I�ɏo�͂���l���i�[����ׂ̃e�[�u���z
		CREATE TABLE #tmpOutputValue
		(
			  [RowNum] INT identity(1,1)
			, [CsvValue] [NVARCHAR](MAX)
		)
		;





		--====���y�^�C�g�����f�[�^�擾�����z��====--

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
		AND	MHen.RCMItemValue = '99999'
		;

		--�y���ISQL���g�p���čs�Ɨ�����ւ���z
		SELECT	  @Title_listIN = 
					CASE WHEN @Title_listIN IS NULL THEN '[' + tmp.SplitStr  + ']'
							ELSE @Title_listIN + ', [' + tmp.SplitStr + '] '
					END

				, @Title_listSEL = 
					CASE WHEN @Title_listSEL IS NULL THEN '[' + tmp.SplitStr  + '] '
							ELSE @Title_listSEL + ' + '','' + [' + tmp.SplitStr + '] ' 
					END

		FROM #tmpTitle tmp
		ORDER BY tmp.SplitNum
		;

		SET @Title_listSEL = REPLACE(@Title_listSEL, '[', 'MAX([');
		SET @Title_listSEL = REPLACE(@Title_listSEL, ']', '])');


		-- �^�C�g�����K�v�ȓ��Ӑ�̏ꍇ
		IF (@TitleKBN = 1)
		BEGIN

			SET @Title_sql = 'INSERT INTO #tmpOutputValue '
							+ ' ( CsvValue )'
							+ ' SELECT '
							+
							@Title_listSEL
							+
							+ ' FROM #tmpTitle PIVOT (MAX(SplitStr) FOR SplitStr IN ( '
							+ @Title_listIN
							+ ' )) AS PV '
						;

			EXECUTE sp_executesql @Title_sql;

		END


		--====���y�^�C�g�����f�[�^�擾�����z��====--


		--====���y���ו��f�[�^�擾�����z��====--

		-- ���ISQL�p�ϐ�
		SET @Henkan_sql = NULL;
		SET @Detail_sql = NULL;


		-- CUR_Porpose�p�ϐ�
		DECLARE @CurCsvTitle	AS VARCHAR(50);
		DECLARE @CurTableName	AS VARCHAR(50);
		DECLARE @CurStrChar		AS VARCHAR(50);
		DECLARE @CurNumKBN		AS INT;
		DECLARE @CurChar3		AS VARCHAR(100);

		-- CUR_Output�p�ϐ�
		DECLARE @CurRowNum		AS INT;


		--�y�ėp�}�X�^������ۂɏo�͂��������ڂ��擾����z
		DECLARE CUR_Porpose CURSOR FOR
			SELECT Main.SplitStr AS CsvTitle, Sub.Char1, ISNULL(Sub.Char3, Sub.Char2) StrChar, Sub.Num1, Sub.Char3
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
		INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN, @CurChar3;

		--�f�[�^�̍s�������[�v���������s����
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- ���[�v���̎��ۂ̏��� ��������===*******************CUR_Porpose

			IF (@CurChar3 IS NOT NULL)
			BEGIN
				
				SET @CurStrChar = '''' + @CurStrChar + '''' ;

			END

			IF (@CurNumKBN = 0)
			BEGIN
					IF (@Henkan_sql IS NULL)
					BEGIN
						SET @Henkan_sql = 'SELECT @parOutput = ';
					END
					ELSE
					BEGIN
						SET @Henkan_sql = @Henkan_sql + ' + '','' +  ';
					END


					SET @Henkan_sql = @Henkan_sql +  ' CONVERT(VARCHAR(MAX), ' + @CurStrChar + ') ';
			END
			IF (@CurNumKBN = 1)		-- Num1 = 1 �̎��A��������ōŏ��̃X�y�[�X�܂ł̒l���̗p
			BEGIN
					IF (@Henkan_sql IS NULL)
					BEGIN
						SET @Henkan_sql = 'SELECT @parOutput = ';
					END
					ELSE
					BEGIN
						SET @Henkan_sql = @Henkan_sql + ' + '','' + ' ;
					END

					SET @Henkan_sql = @Henkan_sql + ' CASE CHARINDEX('' '',' + @CurStrChar + ' )' 
													+ '   WHEN 0 THEN ' + @CurStrChar
													+ '   ELSE SUBSTRING(' + @CurStrChar + ', 1, CHARINDEX('' '', ' + @CurStrChar + '))'
													+ ' END '
					;
			END



			--���̍s�̃f�[�^���擾���ĕϐ��֒l���Z�b�g
			FETCH NEXT FROM CUR_Porpose
			INTO @CurCsvTitle, @CurTableName, @CurStrChar, @CurNumKBN, @CurChar3;

		END	-- LOOP�̏I���***************************************CUR_Porpose

		--�J�[�\�������
		CLOSE CUR_Porpose;
		DEALLOCATE CUR_Porpose;


		-- ��L�̓��ISQL�ɑ΂���JOIN��܂ŕϐ��ɒǉ�����
		SET @Henkan_sql = @Henkan_sql + ' FROM #tmpItemCSV Main '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Item_Master ON Item_Master.[ID] = Main.[ID] '
		SET @Henkan_sql = @Henkan_sql + ' LEFT JOIN Monotaro_Item_Master ON Monotaro_Item_Master.[ID] = Main.[ID] '



		-- �y���ISQL�ׂ̈Ɉꎞ�e�[�u���Ƀf�[�^���ڍs����z
		CREATE TABLE #tmpItemCsv
		(
			[RowNum] [int]  identity(1,1),
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
		


		-- �ϊ��}�X�^��READ����ׂ̃e�[�u��
		CREATE TABLE #tmpHenkan
		(
			  [SplitNum] INT identity(1,1)
			, [SplitTitle]  [NVARCHAR](MAX)
			, [SplitStr]  [NVARCHAR](MAX)
		)
		;
		


		-- �o�͑Ώۃf�[�^�ɂ���1������������
		DECLARE CUR_Output CURSOR FOR
			SELECT RowNum
			FROM #tmpItemCSV
			ORDER BY RowNum
		;

		--�J�[�\���I�[�v��
		OPEN CUR_Output;

		--�ŏ���1�s�ڂ��擾���ĕϐ��֒l���Z�b�g
		FETCH NEXT FROM CUR_Output
		INTO @CurRowNum;

		--�f�[�^�̍s�������[�v���������s����
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- ���[�v���̎��ۂ̏��� ��������===*******************CUR_Output
				
				SET @strOutput = '';
				SET @Detail_sql = '';

				SET @Detail_sql = @Henkan_sql 
				SET @Detail_sql = @Detail_sql + ' WHERE Main.RowNum = ' + CONVERT(VARCHAR,@CurRowNum)
				

				EXECUTE sp_executesql @Detail_sql, N'@parOutput NVARCHAR(MAX) OUTPUT', @parOutput = @strOutput OUTPUT;


				--�@INSERT�O�Ƀ��[�N�e�[�u����TRUNCATE
				TRUNCATE TABLE #tmpHenkan
				;

				--�@�V�K�s�̃f�[�^��}��
				INSERT INTO #tmpHenkan
				([SplitStr])
				SELECT *
				FROM STRING_SPLIT(@strOutput,',')
				; 

				-- M_Henkan��read���鎞�ɕK�v��Export_fields��1��1��Update
				UPDATE Main
				SET Main.SplitTitle = Sub.SplitStr
				FROM #tmpHenkan Main
				INNER JOIN #tmpSplit Sub
				ON Sub.SplitNum = Main.SplitNum
				;

				-- M_Henkan���������āA�l�̕ϊ��l���������ꍇ�͂�������g�p����
				UPDATE tmp
				SET tmp.SplitStr = ISNULL(MH.CsvOutputItemValue, tmp.SplitStr)
				FROM #tmpHenkan tmp
				LEFT JOIN M_Henkan MH
				ON  MH.TokuisakiCD = @TokuisakiCD
				AND MH.RCMItemName = tmp.SplitTitle
				AND MH.RCMItemValue = tmp.SplitStr
				;

				SET @RowCnt = 1;

				--�ŏI�o�͗p#tmpOutputValue �ɍs��}��
				SET @Output_sql = '';

				SET @Output_sql = 'INSERT INTO #tmpOutputValue '
				SET @Output_sql = @Output_sql + ' (CsvValue) ' 
				SET @Output_sql = @Output_sql + ' SELECT '

				WHILE (@RowCnt < @MaxRowCnt + 1)
				BEGIN
					
					IF (@RowCnt > 1)
					BEGIN
						SET @Output_sql = @Output_sql + ' + '','' + '
					END

					SET @Output_sql = @Output_sql + ' MAX(CASE SplitNum WHEN ' + CONVERT(VARCHAR,@RowCnt) + ' THEN SplitStr ELSE '''' END )'

					SET @RowCnt = @RowCnt + 1;

				END
				
				SET @Output_sql = @Output_sql + ' FROM #tmpHenkan '


				EXECUTE sp_executesql @Output_sql;



			--���̍s�̃f�[�^���擾���ĕϐ��֒l���Z�b�g
			FETCH NEXT FROM CUR_Output
			INTO @CurRowNum;

		END	-- LOOP�̏I���***************************************CUR_Output

		--�J�[�\�������
		CLOSE CUR_Output;
		DEALLOCATE CUR_Output;

	
		--====���y���ו��f�[�^�擾�����z��====--




		--�y�o�̓f�[�^���擾�z
		SELECT CsvValue
		FROM #tmpOutputValue
		ORDER BY RowNum;



		--�y�Ō�Ƀ��[�N�e�[�u�����폜����z
		DROP TABLE #tmpTitle
		;
		DROP TABLE #tmpSplit
		;
		DROP TABLE #tmpItemCSV
		;
		DROP TABLE #tmpHenkan
		;
		DROP TABLE #tmpOutputValue
		;
					
END