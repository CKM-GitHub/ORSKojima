SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--  ======================================================================
--       Program Call    店舗レジ ジャーナル印刷
--       Program ID      TempoRegiPoint
--       Create date:    2019.12.22
--       Update date:    2020.06.06  雑入金、雑支払、両替仕様変更
--                       2020.07.17  件数が増えるを修正
--  ======================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'D_SelectData_ForTempoRegiJournal')
  DROP PROCEDURE [dbo].[D_SelectData_ForTempoRegiJournal]
GO


CREATE PROCEDURE [dbo].[D_SelectData_ForTempoRegiJournal]
(
    @StoreCD   varchar(4),
    @DateFrom  varchar(10),
    @DateTo    varchar(10)
)AS

--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    -- 【店舗精算】ワークテーブル１作成
    SELECT * 
      INTO #Temp_D_StoreCalculation1
      FROM (
            SELECT CalculationDate                  -- 精算日
                  ,[10000yen] [10000yenNum]         -- 現金残高10,000枚数
                  ,[5000yen] [5000yenNum]           -- 現金残高5,000枚数
                  ,[2000yen] [2000yenNum]           -- 現金残高2,000枚数
                  ,[1000yen] [1000yenNum]           -- 現金残高1,000枚数
                  ,[500yen] [500yenNum]             -- 現金残高500枚数
                  ,[100yen] [100yenNum]             -- 現金残高100枚数
                  ,[50yen] [50yenNum]               -- 現金残高50枚数
                  ,[10yen] [10yenNum]               -- 現金残高10枚数
                  ,[5yen] [5yenNum]                 -- 現金残高5枚数
                  ,[1yen] [1yenNum]                 -- 現金残高1枚数
                  ,[10000yen]*10000 [10000yenGaku]  -- 現金残高10,000金額
                  ,[5000yen]*5000 [5000yenGaku]     -- 現金残高5,000金額
                  ,[2000yen]*2000 [2000yenGaku]     -- 現金残高2,000金額
                  ,[1000yen]*1000 [1000yenGaku]     -- 現金残高1,000金額
                  ,[500yen]*500 [500yenGaku]        -- 現金残高500金額
                  ,[100yen]*100 [100yenGaku]        -- 現金残高100金額
                  ,[50yen]*50 [50yenGaku]           -- 現金残高50金額
                  ,[10yen]*10 [10yenGaku]           -- 現金残高10金額
                  ,[5yen]*5 [5yenGaku]              -- 現金残高5金額
                  ,[1yen]*1 [1yenGaku]              -- 現金残高1金額
                  ,Change                           -- 釣銭準備金
                  ,Etcyen                           -- その他金額
              FROM D_StoreCalculation
             WHERE StoreCD = @StoreCD
               AND CalculationDate >= convert(date, @DateFrom)
               AND CalculationDate <= convert(date, @DateTo)
           ) S1;

    SELECT *
      INTO #Temp_D_DepositHistory0
      FROM (
            SELECT DepositDateTime                  -- 登録日
                  ,Number                           -- 伝票番号
                  ,StoreCD                          -- 店舗CD
                  ,SKUCD                            -- 
                  ,JanCD                            -- JanCD
                  ,AdminNO
                  ,SalesSU                          -- 
                  ,SalesUnitPrice                   -- 
                  ,TotalGaku                        -- 価格
                  ,SalesTax                         -- 税額
                  ,SalesTaxRate                     -- 税率
                  ,DataKBN                          -- データ種別(1:販売情報、2:販売明細情報、3:入出金情報)
                  ,DepositKBN                       -- 入出金区分
                  ,CancelKBN                        -- 取消区分(1:取消、2:返品、3:訂正)
                  ,RecoredKBN                       -- 赤黒区分(0:黒、1:赤)
                  ,NotReceiptFlg                    -- レシート印刷対象額分(0:対象、1:対象外)
                  ,DenominationCD                   -- 
                  ,DepositGaku                      -- 
                  ,Refund                           -- 
                  ,DepositNO                        -- 
                  ,DiscountGaku                     -- 
                  ,CustomerCD                       -- 
                  ,ExchangeDenomination             -- 
                  ,ExchangeCount                    -- 
                  ,[Rows]                           -- 
                  ,AccountingDate                   -- 
                  ,InsertOperator
                  ,Remark
              FROM D_DepositHistory
             WHERE StoreCD = @StoreCD
               AND AccountingDate >= convert(date, @DateFrom)
               AND AccountingDate <= convert(date, @DateTo)
               AND DataKBN IN (2,3)
               AND DepositKBN IN (1,2,3,5,6)
           ) H1;
--Temp_D_DepositHistory0にIndex（Number）をつけたほうがよい？★
    -- インデックスindex1作成
    CREATE CLUSTERED INDEX index_D_DepositHistory0 on [#Temp_D_DepositHistory0] ([Number]);
    
    -- 【販売】ワークテーブル１作成
    SELECT * 
      INTO #Temp_D_DepositHistory1
      FROM (
            SELECT distinct history.DepositDateTime RegistDate                  -- 登録日時
                  ,CONVERT(Date, history.DepositDateTime) DepositDate           -- 登録日
                  ,history.Number SalesNO                                       -- 伝票番号
                  ,history.StoreCD                                              -- 店舗CD
                  ,history.DepositNO                                            -- Sortのために取得
                  ,history.JanCD                                                -- JanCD
                  ,(SELECT top 1 sku.SKUShortName
                      FROM M_SKU AS sku
                     WHERE sku.AdminNO = history.AdminNO
                       AND sku.DeleteFlg = 0
                       AND sku.ChangeDate <= history.AccountingDate
                     ORDER BY sku.ChangeDate DESC
                   ) As SKUShortName                                            -- 商品名
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE history.SalesUnitPrice
                   END AS SalesUnitPrice                                        -- 単価
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.SalesSU * (-1) ELSE history.SalesSU END
                   END AS SalesSU                                               -- 数量
                  ,CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1)
                        ELSE history.TotalGaku
                   END Kakaku                                                   -- 価格
                  ,history.SalesTax                                             -- 税額
                  ,history.SalesTaxRate                                         -- 税率
                  ,CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1)
                        ELSE history.TotalGaku
                   END TotalGaku                                                -- 販売合計額

                  ,CASE WHEN history.RecoredKBN = 1 AND history.CancelKBN = 3 THEN (sales.SalesHontaiGaku8 + sales.SalesTax8) * (-1) 
				        ELSE  sales.SalesHontaiGaku8 + sales.SalesTax8 
			       END TargetAmount8                                            -- 8％対象額
                  ,CASE WHEN history.RecoredKBN = 1 AND history.CancelKBN = 3 THEN (sales.SalesHontaiGaku10 + sales.SalesTax10) * (-1)
				        ELSE sales.SalesHontaiGaku10 + sales.SalesTax10
				   END TargetAmount10                                           -- 10％対象額
                  ,CASE WHEN history.RecoredKBN = 1 AND history.CancelKBN = 3 THEN sales.SalesTax8 * (-1)
						ELSE sales.SalesTax8
					END SalesTax8                                               -- 外税8％
                  ,CASE WHEN history.RecoredKBN = 1 AND history.CancelKBN = 3 THEN sales.SalesTax10 * (-1)
						ELSE sales.SalesTax10
					END SalesTax10                                              -- 外税10％
                  ,(SELECT top 1 staff.ReceiptPrint
                      FROM M_Staff AS staff
                     WHERE  staff.StaffCD = sales.StaffCD
                       AND staff.DeleteFlg = 0
                       AND staff.ChangeDate <= sales.SalesDate
                     ORDER BY staff.ChangeDate DESC
                    ) AS StaffReceiptPrint                                      -- 担当レシート表記
                  ,(SELECT top 1 store.ReceiptPrint
                      FROM M_Store AS store
                     WHERE store.StoreCD = sales.StoreCD
                       AND store.DeleteFlg = 0
                       AND store.ChangeDate <= sales.SalesDate
                     ORDER BY store.ChangeDate DESC
                    ) AS StoreReceiptPrint                                      -- 店舗レシート表記
                  ,history.AccountingDate
                  ,history.RecoredKBN
              FROM #Temp_D_DepositHistory0 AS history
              LEFT OUTER JOIN D_Sales AS sales ON sales.SalesNO = history.Number

             WHERE history.DataKBN = 2
               AND history.DepositKBN = 1
           ) D1;

    -- 【販売】ワークテーブル２作成
    SELECT * 
      INTO #Temp_D_DepositHistory2
      FROM (
            SELECT D.SalesNO                                                                     -- 伝票番号
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DenominationName ELSE NULL END) PaymentName1   -- 支払方法名1
                  ,MAX(CASE D.RANK WHEN  1 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay1     -- 支払方法額1
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DenominationName ELSE NULL END) PaymentName2   -- 支払方法名2
                  ,MAX(CASE D.RANK WHEN  2 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay2     -- 支払方法額2
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DenominationName ELSE NULL END) PaymentName3   -- 支払方法名3
                  ,MAX(CASE D.RANK WHEN  3 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay3     -- 支払方法額3
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DenominationName ELSE NULL END) PaymentName4   -- 支払方法名4
                  ,MAX(CASE D.RANK WHEN  4 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay4     -- 支払方法額4
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DenominationName ELSE NULL END) PaymentName5   -- 支払方法名5
                  ,MAX(CASE D.RANK WHEN  5 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay5     -- 支払方法額5
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DenominationName ELSE NULL END) PaymentName6   -- 支払方法名6
                  ,MAX(CASE D.RANK WHEN  6 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay6     -- 支払方法額6
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DenominationName ELSE NULL END) PaymentName7   -- 支払方法名7
                  ,MAX(CASE D.RANK WHEN  7 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay7     -- 支払方法額7
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DenominationName ELSE NULL END) PaymentName8   -- 支払方法名8
                  ,MAX(CASE D.RANK WHEN  8 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay8     -- 支払方法額8
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DenominationName ELSE NULL END) PaymentName9   -- 支払方法名9
                  ,MAX(CASE D.RANK WHEN  9 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay9     -- 支払方法額9
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DenominationName ELSE NULL END) PaymentName10  -- 支払方法名10
                  ,MAX(CASE D.RANK WHEN 10 THEN CASE D.RecoredKBN WHEN 1 THEN D.DepositGaku * (-1) ELSE D.DepositGaku END  ELSE NULL END) AmountPay10    -- 支払方法額10
                  ,D.RecoredKbn
                  ,D.DepositDateTime
              FROM (
                    SELECT history.Number SalesNO
                          ,history.DenominationCD
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku + history.Refund DepositGaku
                          ,history.DepositDateTime
                          --,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositDateTime ASC) as RANK	★
                          ,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositNO ASC) as RANK
                          ,history.RecoredKBN
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 1
                   ) D
             GROUP BY D.SalesNO
                    , D.RecoredKBN, D.DepositDateTime
           ) D2;

    -- 【販売】ワークテーブル３作成
    SELECT * 
      INTO #Temp_D_DepositHistory3
      FROM (
            SELECT history.Number  SalesNO                   -- 伝票番号
                  ,SUM(CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.Refund * (-1) ELSE history.Refund END) Refund                      -- 釣銭
                  ,SUM(CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.DiscountGaku * (-1) ELSE history.DiscountGaku END) DiscountGaku    -- 値引額
              FROM #Temp_D_DepositHistory0 AS history
              LEFT OUTER JOIN D_Sales AS sales ON sales.SalesNO = history.Number
             WHERE history.DataKBN = 3 
               AND history.DepositKBN = 1
             GROUP BY history.Number
           ) D3;

    -- 【釣銭準備】ワークテーブル４作成
    SELECT * 
      INTO #Temp_D_DepositHistory4
      FROM (
            SELECT CONVERT(Date, D.DepositDateTime) RegistDate                             -- 登録日
                  ,D.DepositDateTime ChangePreparationDate1                                -- 釣銭準備日1
                  ,'現金' ChangePreparationName1                                           -- 釣銭準備名1
                  ,D.DepositGaku ChangePreparationAmount1                                  -- 釣銭準備額1
                  ,NULL ChangePreparationDate2                                             -- 釣銭準備日2
                  ,NULL ChangePreparationName2                                             -- 釣銭準備名2
                  ,NULL ChangePreparationAmount2                                           -- 釣銭準備額2
                  ,NULL ChangePreparationDate3                                             -- 釣銭準備日3
                  ,NULL ChangePreparationName3                                             -- 釣銭準備名3
                  ,NULL ChangePreparationAmount3                                           -- 釣銭準備額3
                  ,NULL ChangePreparationDate4                                             -- 釣銭準備日4
                  ,NULL ChangePreparationName4                                             -- 釣銭準備名4
                  ,NULL ChangePreparationAmount4                                           -- 釣銭準備額4
                  ,NULL ChangePreparationDate5                                             -- 釣銭準備日5
                  ,NULL ChangePreparationName5                                             -- 釣銭準備名5
                  ,NULL ChangePreparationAmount5                                           -- 釣銭準備額5
                  ,NULL ChangePreparationDate6                                             -- 釣銭準備日6
                  ,NULL ChangePreparationName6                                             -- 釣銭準備名6
                  ,NULL ChangePreparationAmount6                                           -- 釣銭準備額6
                  ,NULL ChangePreparationDate7                                             -- 釣銭準備日7
                  ,NULL ChangePreparationName7                                             -- 釣銭準備名7
                  ,NULL ChangePreparationAmount7                                           -- 釣銭準備額7
                  ,NULL ChangePreparationDate8                                             -- 釣銭準備日8
                  ,NULL ChangePreparationName8                                             -- 釣銭準備名8
                  ,NULL ChangePreparationAmount8                                           -- 釣銭準備額8
                  ,NULL ChangePreparationDate9                                             -- 釣銭準備日9
                  ,NULL ChangePreparationName9                                             -- 釣銭準備名9
                  ,NULL ChangePreparationAmount9                                           -- 釣銭準備額9
                  ,NULL ChangePreparationDate10                                            -- 釣銭準備日10
                  ,NULL ChangePreparationName10                                            -- 釣銭準備名10
                  ,NULL ChangePreparationAmount10                                          -- 釣銭準備額10
                  ,D.Remark ChangePreparationRemark                                        -- 釣銭準備備考
                  ,D.DepositNO
              FROM #Temp_D_DepositHistory0 D
              INNER JOIN (
                                   SELECT MAX(history.DepositNO) DepositNO
                                     FROM #Temp_D_DepositHistory0 history
                                    WHERE history.DataKBN = 3
                                      AND history.DepositKBN = 6
                                      AND history.CancelKBN = 0
                                    GROUP BY history.AccountingDate
                                  ) AS DD
              ON DD.DepositNO = D.DepositNO
           ) D4;

    -- 【雑入金】ワークテーブル５作成
    SELECT * 
      INTO #Temp_D_DepositHistory5
      FROM (
            SELECT CONVERT(Date, history.DepositDateTime)  AS RegistDate             -- 登録日
                    ,history.DepositDateTime                 AS MiscDepositDate1       -- 雑入金日1
                    ,denominationKbn.DenominationName        AS MiscDepositName1       -- 雑入金名1
                    ,history.DepositGaku                     AS MiscDepositAmount1     -- 雑入金額1
                    --,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositDateTime ASC) as RANK	★
                    --,ROW_NUMBER() OVER(PARTITION BY history.Number,history.DepositNO ORDER BY history.DepositNO ASC) as RANK
                    ,history.DepositNO	                   --2020.11.20 add
                    ,history.InsertOperator                  AS StaffReceiptPrint
                    ,history.Remark                          AS MiscDepositRemark      -- 雑入金備考
                FROM #Temp_D_DepositHistory0 history
                LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                WHERE history.DataKBN = 3
                AND history.DepositKBN = 2
                AND history.CancelKBN = 0
                AND history.CustomerCD IS NULL
           ) D5;

    -- 【入金】ワークテーブル５１作成
    SELECT * 
      INTO #Temp_D_DepositHistory51
      FROM (
            SELECT CONVERT(Date, history.DepositDateTime) AS RegistDate
                    ,history.DepositDateTime                AS DepositDate1
                    ,history.CustomerCD
                    ,(SELECT top 1 customer.CustomerName
                    FROM M_Customer AS customer
                    WHERE customer.CustomerCD = history.CustomerCD             --DeleteFlgはあえて不要
                    AND customer.ChangeDate <= history.DepositDateTime
                    ORDER BY customer.ChangeDate DESC
                    ) AS CustomerName
                    ,denominationKbn.DenominationName                                                              AS DepositName1
                    ,history.DenominationCD 
                    ,CASE history.RecoredKBN WHEN 1 THEN history.DepositGaku * (-1) ELSE history.DepositGaku END   AS DepositAmount1
                    ,history.DepositNO	                  --2020.11.20 add
                    ,history.InsertOperator                 AS StaffReceiptPrint
                    ,history.Remark                         AS DepositRemark
                FROM #Temp_D_DepositHistory0 history
                LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD

            WHERE history.DataKBN = 3
                AND history.DepositKBN = 2
                AND history.CustomerCD IS NOT NULL
           ) D51;

    -- 【雑支払】ワークテーブル６作成
    SELECT * 
      INTO #Temp_D_DepositHistory6
      FROM (
            SELECT CONVERT(Date, history.DepositDateTime) AS RegistDate
                    ,history.DepositDateTime                AS MiscPaymentDate1
                    ,history.DenominationCD
                    ,denominationKbn.DenominationName       AS MiscPaymentName1
                    ,history.DepositGaku                    AS MiscPaymentAmount1
                    ,history.Remark                         AS MiscPaymentRemark
                    ,history.DepositNO
                    ,history.AccountingDate
                    ,history.InsertOperator                 AS StaffReceiptPrint
                FROM #Temp_D_DepositHistory0 history
                LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                WHERE history.DataKBN = 3
                AND history.DepositKBN = 3
                AND history.CancelKBN = 0
           ) D6;

    -- 【両替】ワークテーブル７作成
    SELECT * 
      INTO #Temp_D_DepositHistory7
      FROM (
            SELECT CONVERT(Date, history.DepositDateTime) AS RegistDate
                    ,COUNT(*) OVER(partition by CONVERT(Date, history.DepositDateTime)) AS ExchangeCount
                    ,history.DepositDateTime                AS ExchangeDate1
                    ,denominationKbn.DenominationName       AS ExchangeName1
                    ,ABS(history.DepositGaku)               AS ExchangeAmount1
                    ,history.ExchangeDenomination           AS ExchangeDenomination1
                    ,ABS(history.ExchangeCount)             AS ExchangeCount1
                    --,ROW_NUMBER() OVER (PARTITION BY  history.Number ORDER BY history.DepositDateTime) AS RANK	★
                    --,ROW_NUMBER() OVER(PARTITION BY history.Number,history.DepositNO ORDER BY history.DepositNO ASC) as RANK
                    ,history.DepositNO
                    ,history.InsertOperator                 AS StaffReceiptPrint
                    ,history.Remark                         AS ExchangeRemark
                FROM #Temp_D_DepositHistory0 history
                LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                WHERE history.DataKBN = 3
                AND history.DepositKBN = 5
                AND history.CancelKBN = 0
           ) D7;

    -- 【精算処理：現金売上(+)】ワークテーブル９作成
    SELECT * 
      INTO #Temp_D_DepositHistory9
      FROM (
            SELECT D.RegistDate                                   -- 登録日
                  ,SUM(D.DepositGaku) DepositGaku                 -- 現金売上(+)
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,CASE history.RecoredKBN WHEN 1 THEN history.DepositGaku * (-1) ELSE history.DepositGaku END AS DepositGaku
                      FROM #Temp_D_DepositHistory0 AS history
                      LEFT OUTER JOIN D_Sales AS sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN AS denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 1
                       AND denominationKbn.SystemKBN = 1
                   ) D
             GROUP BY D.RegistDate
           ) D9;

    -- 【精算処理：現金入金(+)】ワークテーブル１０作成
    SELECT * 
      INTO #Temp_D_DepositHistory10
      FROM (
            SELECT D.RegistDate                                   -- 登録日
                  ,SUM(D.DepositGaku) DepositGaku                 -- 現金売上(+)
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,CASE history.RecoredKBN WHEN 1 THEN history.DepositGaku * (-1) ELSE history.DepositGaku END AS DepositGaku
                      FROM #Temp_D_DepositHistory0 AS history
                     INNER JOIN M_DenominationKBN AS denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 2
                       AND denominationKbn.SystemKBN = 1
                   ) D
             GROUP BY D.RegistDate
           ) D10;

    -- 【精算処理：現金支払(-)】ワークテーブル１１作成
    SELECT * 
      INTO #Temp_D_DepositHistory11
      FROM (
            SELECT D.RegistDate                                   -- 登録日
                  ,SUM(D.DepositGaku) DepositGaku                 -- 現金支払(-)
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.DepositGaku
                      FROM #Temp_D_DepositHistory0 AS history
                     INNER JOIN M_DenominationKBN AS denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 3
                       AND history.CancelKBN = 0
                       AND denominationKbn.SystemKBN = 1
                   ) D
             GROUP BY D.RegistDate
           ) D11;

    -- 【精算処理】ワークテーブル１２作成
    SELECT * 
      INTO #Temp_D_DepositHistory12
      FROM (
            SELECT CONVERT(DATE, history.DepositDateTime) RegistDate 
                  ,COUNT(DISTINCT sales.SalesNO) SalesNOCount
                  ,COUNT(DISTINCT sales.CustomerCD) CustomerCDCount
                  ,SUM(CASE history.RecoredKBN WHEN 1 THEN history.SalesSU * (-1) ELSE history.SalesSu END) SalesSUSum
                  ,SUM(CASE history.RecoredKBN WHEN 1 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END) TotalGakuSum
                  ,SUM(CASE history.RecoredKBN WHEN 1 THEN history.DiscountGaku * (-1) ELSE history.DiscountGaku END) DiscountGaku
              FROM #Temp_D_DepositHistory0 AS history
              LEFT OUTER JOIN D_Sales AS sales ON sales.SalesNO = history.Number
             WHERE history.DataKBN = 2
               AND history.DepositKBN = 1
               AND sales.DeleteDateTime IS NULL
               AND sales.BillingType = 1
             GROUP BY CONVERT(DATE, history.DepositDateTime)
           ) D12;

    -- 【精算処理】ワークテーブル１３作成
    SELECT * 
      INTO #Temp_D_DepositHistory13
      FROM (
            SELECT D.RegistDate                                                 -- 登録日
                  ,SUM(D.TaxableAmount) TaxableAmount                           -- 内税分販売額の合計
                  ,SUM(D.ForeignTaxableAmount) ForeignTaxableAmount             -- 外税分販売額の合計
                  ,SUM(D.TaxExemptionAmount) TaxExemptionAmount                 -- 非課税分販売額の合計
                  ,SUM(D.TotalWithoutTax) TotalWithoutTax                       -- 税抜合計の合計
                  ,SUM(D.Tax) Tax                                               -- 内税の合計
                  ,SUM(D.OutsideTax) OutsideTax                                 -- 外税の合計
                  ,SUM(D.ConsumptionTax) ConsumptionTax                         -- 消費税計の合計
                  ,SUM(D.TaxIncludedTotal) TaxIncludedTotal                     -- 税込合計の合計
              FROM (
                    SELECT history.DepositNO                                    -- 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate    -- 登録日
                          ,CASE history.RecoredKBN WHEN 1 THEN salesDetails.SalesGaku * (-1) ELSE salesDetails.SalesGaku END TaxableAmount                       -- 内税分販売額
                          ,0 ForeignTaxableAmount                                                                                                                -- 外税分販売額
                          ,0 TaxExemptionAmount                                                                                                                  -- 非課税分販売額
                          ,CASE history.RecoredKBN WHEN 1 THEN salesDetails.SalesHontaiGaku * (-1) ELSE salesDetails.SalesHontaiGaku END TotalWithoutTax         -- 税抜合計
                          ,CASE history.RecoredKBN WHEN 1 THEN salesDetails.SalesTax * (-1) ELSE salesDetails.SalesTax END Tax                                   -- 内税
                          ,0 OutsideTax                                                                                                                          -- 外税
                          ,CASE history.RecoredKBN WHEN 1 THEN salesDetails.SalesTax * (-1) ELSE salesDetails.SalesTax END ConsumptionTax                        -- 消費税計
                          ,CASE history.RecoredKBN WHEN 1 THEN salesDetails.SalesGaku * (-1) ELSE salesDetails.SalesGaku END TaxIncludedTotal                    -- 税込合計
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_SalesDetails AS salesDetails ON salesDetails.SalesNO = history.Number
                                                                 AND salesDetails.SalesRows = history.[Rows]
                      LEFT OUTER JOIN D_Sales AS sales ON sales.SalesNO = salesDetails.SalesNO
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND salesDetails.DeleteDateTime IS NULL
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D13;

    -- 【精算処理】ワークテーブル１４作成
    SELECT * 
      INTO #Temp_D_DepositHistory14
      FROM (
            SELECT D.RegistDate                                                                                      -- 登録日
                  ,MAX(CASE D.DenominationCD WHEN  1 THEN D.DenominationName  ELSE null END) AS denominationName1    -- 金種区分名1
                  ,MAX(CASE D.DenominationCD WHEN  1 THEN D.Kingaku           ELSE null END) AS Kingaku1             -- 金額1
                  ,MAX(CASE d.DenominationCD WHEN  2 THEN D.DenominationName  ELSE null END) AS denominationName2    -- 金種区分名2
                  ,MAX(CASE d.DenominationCD WHEN  2 THEN D.Kingaku           ELSE null END) AS Kingaku2             -- 金額2
                  ,MAX(CASE d.DenominationCD WHEN  3 THEN D.DenominationName  ELSE null END) AS denominationName3    -- 金種区分名3
                  ,MAX(CASE d.DenominationCD WHEN  3 THEN D.Kingaku           ELSE null END) AS Kingaku3             -- 金額3
                  ,MAX(CASE d.DenominationCD WHEN  4 THEN D.DenominationName  ELSE null END) AS denominationName4    -- 金種区分名4
                  ,MAX(CASE d.DenominationCD WHEN  4 THEN D.Kingaku           ELSE null END) AS Kingaku4             -- 金額4
                  ,MAX(CASE d.DenominationCD WHEN  5 THEN D.DenominationName  ELSE null END) AS denominationName5    -- 金種区分名5
                  ,MAX(CASE d.DenominationCD WHEN  5 THEN D.Kingaku           ELSE null END) AS Kingaku5             -- 金額5
                  ,MAX(CASE d.DenominationCD WHEN  6 THEN D.DenominationName  ELSE null END) AS denominationName6    -- 金種区分名6
                  ,MAX(CASE d.DenominationCD WHEN  6 THEN D.Kingaku           ELSE null END) AS Kingaku6             -- 金額6
                  ,MAX(CASE d.DenominationCD WHEN  7 THEN D.DenominationName  ELSE null END) AS denominationName7    -- 金種区分名7
                  ,MAX(CASE d.DenominationCD WHEN  7 THEN D.Kingaku           ELSE null END) AS Kingaku7             -- 金額7
                  ,MAX(CASE d.DenominationCD WHEN  8 THEN D.DenominationName  ELSE null END) AS denominationName8    -- 金種区分名8
                  ,MAX(CASE d.DenominationCD WHEN  8 THEN D.Kingaku           ELSE null END) AS Kingaku8             -- 金額8
                  ,MAX(CASE d.DenominationCD WHEN  9 THEN D.DenominationName  ELSE null END) AS denominationName9    -- 金種区分名9
                  ,MAX(CASE d.DenominationCD WHEN  9 THEN D.Kingaku           ELSE null END) AS Kingaku9             -- 金額9
                  ,MAX(CASE d.DenominationCD WHEN 10 THEN D.DenominationName  ELSE null END) AS denominationName10   -- 金種区分名10
                  ,MAX(CASE d.DenominationCD WHEN 10 THEN D.Kingaku           ELSE null END) AS Kingaku10            -- 金額10
                  ,MAX(CASE d.DenominationCD WHEN 11 THEN D.DenominationName  ELSE null END) AS denominationName11   -- 金種区分名11
                  ,MAX(CASE d.DenominationCD WHEN 11 THEN D.Kingaku           ELSE null END) AS Kingaku11            -- 金額11
                  ,MAX(CASE d.DenominationCD WHEN 12 THEN D.DenominationName  ELSE null END) AS denominationName12   -- 金種区分名12
                  ,MAX(CASE d.DenominationCD WHEN 12 THEN D.Kingaku           ELSE null END) AS Kingaku12            -- 金額12
                  ,MAX(CASE d.DenominationCD WHEN 13 THEN D.DenominationName  ELSE null END) AS denominationName13   -- 金種区分名13
                  ,MAX(CASE d.DenominationCD WHEN 13 THEN D.Kingaku           ELSE null END) AS Kingaku13            -- 金額13
                  ,MAX(CASE d.DenominationCD WHEN 14 THEN D.DenominationName  ELSE null END) AS denominationName14   -- 金種区分名14
                  ,MAX(CASE d.DenominationCD WHEN 14 THEN D.Kingaku           ELSE null END) AS Kingaku14            -- 金額14
                  ,MAX(CASE d.DenominationCD WHEN 15 THEN D.DenominationName  ELSE null END) AS denominationName15   -- 金種区分名15
                  ,MAX(CASE d.DenominationCD WHEN 15 THEN D.Kingaku           ELSE null END) AS Kingaku15            -- 金額15
                  ,MAX(CASE d.DenominationCD WHEN 16 THEN D.DenominationName  ELSE null END) AS denominationName16   -- 金種区分名16
                  ,MAX(CASE d.DenominationCD WHEN 16 THEN D.Kingaku           ELSE null END) AS Kingaku16            -- 金額16
                  ,MAX(CASE d.DenominationCD WHEN 17 THEN D.DenominationName  ELSE null END) AS denominationName17   -- 金種区分名17
                  ,MAX(CASE d.DenominationCD WHEN 17 THEN D.Kingaku           ELSE null END) AS Kingaku17            -- 金額17
                  ,MAX(CASE d.DenominationCD WHEN 18 THEN D.DenominationName  ELSE null END) AS denominationName18   -- 金種区分名18
                  ,MAX(CASE d.DenominationCD WHEN 18 THEN D.Kingaku           ELSE null END) AS Kingaku18            -- 金額18
                  ,MAX(CASE d.DenominationCD WHEN 19 THEN D.DenominationName  ELSE null END) AS denominationName19   -- 金種区分名19
                  ,MAX(CASE d.DenominationCD WHEN 19 THEN D.Kingaku           ELSE null END) AS Kingaku19            -- 金額19
                  ,MAX(CASE d.DenominationCD WHEN 20 THEN D.DenominationName  ELSE null END) AS denominationName20   -- 金種区分名20
                  ,MAX(CASE d.DenominationCD WHEN 20 THEN D.Kingaku           ELSE null END) AS Kingaku20            -- 金額20
              FROM (
                    SELECT CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,denominationKbn.DenominationCD 
                          ,MAX(CASE WHEN denominationKbn.SystemKBN = 2 THEN multiPorpose.IDName
                                    ELSE denominationKbn.DenominationName 
                               END) DenominationName
                          ,SUM(CASE history.RecoredKBN WHEN 1 THEN history.DepositGaku * (-1) ELSE history.DepositGaku END) Kingaku
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales AS sales ON sales.SalesNO = history.number
                      LEFT OUTER JOIN M_DenominationKBN AS denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                      LEFT OUTER JOIN M_MultiPorpose AS multiporpose ON multiporpose.id = 303
                                                                 AND multiporpose.[key] = denominationKbn.CardCompany 
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 1
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                     GROUP BY CONVERT(DATE, history.DepositDateTime)
                             ,denominationKbn.DenominationCD
                             ,denominationKbn.CardCompany
                   ) D
             GROUP BY D.RegistDate
           ) D14;

    -- 【精算処理】ワークテーブル１５作成
    SELECT * 
      INTO #Temp_D_DepositHistory15
      FROM (
            SELECT D.RegistDate
                  ,SUM(DepositTransfer) DepositTransfer      -- 入金 振込
                  ,SUM(DepositCash) DepositCash              -- 入金 現金
                  ,SUM(DepositCheck) DepositCheck            -- 入金 小切手
                  ,SUM(DepositBill) DepositBill              -- 入金 手形
                  ,SUM(DepositOffset) DepositOffset          -- 入金 相殺⇒電子決済
                  ,SUM(DepositAdjustment) DepositAdjustment  -- 入金 調整⇒その他
                  ,SUM(PaymentTransfer) PaymentTransfer      -- 支払 振込
                  ,SUM(PaymentCash) PaymentCash              -- 支払 現金
                  ,SUM(PaymentCheck) PaymentCheck            -- 支払 小切手
                  ,SUM(PaymentBill) PaymentBill              -- 支払 手形
                  ,SUM(PaymentOffset) PaymentOffset          -- 支払 相殺⇒電子決済
                  ,SUM(PaymentAdjustment) PaymentAdjustment  -- 支払 調整⇒その他
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 5 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS DepositTransfer    -- 入金 振込
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 1 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS DepositCash        -- 入金 現金
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 6 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS DepositCheck       -- 入金 小切手
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 11 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS DepositBill        -- 入金 手形
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 10 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS DepositOffset      -- 入金 相殺
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN NOT IN (5,1,6,11,10) THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS DepositAdjustment  -- 入金 調整
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 5 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS PaymentTransfer    -- 支払 振込
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 1 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS PaymentCash        -- 支払 現金
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 6 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS PaymentCheck       -- 支払 小切手
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 11 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS PaymentBill        -- 支払 手形
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 10 THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS PaymentOffset      -- 支払 相殺
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN NOT IN (5,1,6,11,10) THEN CASE history.RecoredKBN WHEN 1 THEN  history.DepositGaku * (-1) ELSE history.DepositGaku END
                                ELSE 0
                           END AS PaymentAdjustment  -- 支払 調整
                      FROM #Temp_D_DepositHistory0 AS history
                      LEFT OUTER JOIN M_DenominationKBN AS denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                   ) D
             GROUP BY D.RegistDate
           ) D15;

    -- 【精算処理】ワークテーブル１６作成
    SELECT * 
      INTO #Temp_D_DepositHistory16
      FROM (
            SELECT RegistDate                                                              -- 登録日
                  ,SUM(OtherAmountReturns) OtherAmountReturns                              -- 他現金 返品
                  --,SUM(OtherAmountDiscount) OtherAmountDiscount                            -- 他現金 値引
                  ,SUM(OtherAmountCancel) OtherAmountCancel                                -- 他現金 取消
                  ,SUM(OtherAmountDelivery) OtherAmountDelivery                            -- 他現金 配達
              FROM (
                    SELECT history.DepositNO 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate               -- 登録日
                          ,CASE WHEN history.CancelKBN = 2 THEN history.DepositGaku * (-1)
                                ELSE 0
                           END AS OtherAmountReturns                                       -- 他現金 返品
                          ,0 OtherAmountDiscount                                           -- 他現金 値引
                          ,CASE WHEN history.CancelKBN = 1 THEN history.DepositGaku
                                ELSE 0
                           END AS OtherAmountCancel                                        -- 他現金 値引
                          ,0 OtherAmountDelivery                                           -- 他現金 配達
                      FROM #Temp_D_DepositHistory0 AS history
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.CancelKBN IN (1, 2)
                       AND history.RecoredKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D16;

    -- 【精算処理】ワークテーブル１６-２作成
    SELECT * 
      INTO #Temp_D_DepositHistory162
      FROM (
            SELECT CONVERT(DATE, history.DepositDateTime) RegistDate                                                                             -- 登録日
                  ,SUM(CASE history.RecoredKBN WHEN 1 THEN history.DepositGaku * (-1) ELSE history.DepositGaku END) OtherAmountDiscount          -- 他現金 値引                  
              FROM #Temp_D_DepositHistory0 AS history
              LEFT OUTER JOIN M_DenominationKBN AS M
                ON M.DenominationCD = history.DenominationCD
             WHERE history.DataKBN = 3
               AND history.DepositKBN = 1
               AND M.SystemKBN = 8
             GROUP BY CONVERT(DATE, history.DepositDateTime)
           ) D162;
           
    -- 【精算処理】ワークテーブル１７作成
    SELECT * 
      INTO #Temp_D_DepositHistory17
      FROM (
            SELECT RegistDate                                                              -- 登録日
                  ,SUM(ByTimeZoneTaxIncluded_0000_0100) ByTimeZoneTaxIncluded_0000_0100    -- 時間帯別(税込) 00:00〜01:00
                  ,SUM(ByTimeZoneTaxIncluded_0100_0200) ByTimeZoneTaxIncluded_0100_0200    -- 時間帯別(税込) 01:00〜02:00
                  ,SUM(ByTimeZoneTaxIncluded_0200_0300) ByTimeZoneTaxIncluded_0200_0300    -- 時間帯別(税込) 02:00〜03:00
                  ,SUM(ByTimeZoneTaxIncluded_0300_0400) ByTimeZoneTaxIncluded_0300_0400    -- 時間帯別(税込) 03:00〜04:00
                  ,SUM(ByTimeZoneTaxIncluded_0400_0500) ByTimeZoneTaxIncluded_0400_0500    -- 時間帯別(税込) 04:00〜05:00
                  ,SUM(ByTimeZoneTaxIncluded_0500_0600) ByTimeZoneTaxIncluded_0500_0600    -- 時間帯別(税込) 05:00〜06:00
                  ,SUM(ByTimeZoneTaxIncluded_0600_0700) ByTimeZoneTaxIncluded_0600_0700    -- 時間帯別(税込) 06:00〜07:00
                  ,SUM(ByTimeZoneTaxIncluded_0700_0800) ByTimeZoneTaxIncluded_0700_0800    -- 時間帯別(税込) 07:00〜08:00
                  ,SUM(ByTimeZoneTaxIncluded_0800_0900) ByTimeZoneTaxIncluded_0800_0900    -- 時間帯別(税込) 08:00〜09:00
                  ,SUM(ByTimeZoneTaxIncluded_0900_1000) ByTimeZoneTaxIncluded_0900_1000    -- 時間帯別(税込) 09:00〜10:00
                  ,SUM(ByTimeZoneTaxIncluded_1000_1100) ByTimeZoneTaxIncluded_1000_1100    -- 時間帯別(税込) 10:00〜11:00
                  ,SUM(ByTimeZoneTaxIncluded_1100_1200) ByTimeZoneTaxIncluded_1100_1200    -- 時間帯別(税込) 11:00〜12:00
                  ,SUM(ByTimeZoneTaxIncluded_1200_1300) ByTimeZoneTaxIncluded_1200_1300    -- 時間帯別(税込) 12:00〜13:00
                  ,SUM(ByTimeZoneTaxIncluded_1300_1400) ByTimeZoneTaxIncluded_1300_1400    -- 時間帯別(税込) 13:00〜14:00
                  ,SUM(ByTimeZoneTaxIncluded_1400_1500) ByTimeZoneTaxIncluded_1400_1500    -- 時間帯別(税込) 14:00〜15:00
                  ,SUM(ByTimeZoneTaxIncluded_1500_1600) ByTimeZoneTaxIncluded_1500_1600    -- 時間帯別(税込) 15:00〜16:00
                  ,SUM(ByTimeZoneTaxIncluded_1600_1700) ByTimeZoneTaxIncluded_1600_1700    -- 時間帯別(税込) 16:00〜17:00
                  ,SUM(ByTimeZoneTaxIncluded_1700_1800) ByTimeZoneTaxIncluded_1700_1800    -- 時間帯別(税込) 17:00〜18:00
                  ,SUM(ByTimeZoneTaxIncluded_1800_1900) ByTimeZoneTaxIncluded_1800_1900    -- 時間帯別(税込) 18:00〜19:00
                  ,SUM(ByTimeZoneTaxIncluded_1900_2000) ByTimeZoneTaxIncluded_1900_2000    -- 時間帯別(税込) 19:00〜20:00
                  ,SUM(ByTimeZoneTaxIncluded_2000_2100) ByTimeZoneTaxIncluded_2000_2100    -- 時間帯別(税込) 20:00〜21:00
                  ,SUM(ByTimeZoneTaxIncluded_2100_2200) ByTimeZoneTaxIncluded_2100_2200    -- 時間帯別(税込) 21:00〜22:00
                  ,SUM(ByTimeZoneTaxIncluded_2200_2300) ByTimeZoneTaxIncluded_2200_2300    -- 時間帯別(税込) 22:00〜23:00
                  ,SUM(ByTimeZoneTaxIncluded_2300_2400) ByTimeZoneTaxIncluded_2300_2400    -- 時間帯別(税込) 23:00〜24:00
                  ,COUNT(ByTimeZoneSalesNO_0000_0100) ByTimeZoneSalesNO_0000_0100          -- 時間帯別(売上番号) 00:00〜01:00
                  ,COUNT(ByTimeZoneSalesNO_0100_0200) ByTimeZoneSalesNO_0100_0200          -- 時間帯別(売上番号) 01:00〜02:00
                  ,COUNT(ByTimeZoneSalesNO_0200_0300) ByTimeZoneSalesNO_0200_0300          -- 時間帯別(売上番号) 02:00〜03:00
                  ,COUNT(ByTimeZoneSalesNO_0300_0400) ByTimeZoneSalesNO_0300_0400          -- 時間帯別(売上番号) 03:00〜04:00
                  ,COUNT(ByTimeZoneSalesNO_0400_0500) ByTimeZoneSalesNO_0400_0500          -- 時間帯別(売上番号) 04:00〜05:00
                  ,COUNT(ByTimeZoneSalesNO_0500_0600) ByTimeZoneSalesNO_0500_0600          -- 時間帯別(売上番号) 05:00〜06:00
                  ,COUNT(ByTimeZoneSalesNO_0600_0700) ByTimeZoneSalesNO_0600_0700          -- 時間帯別(売上番号) 06:00〜07:00
                  ,COUNT(ByTimeZoneSalesNO_0700_0800) ByTimeZoneSalesNO_0700_0800          -- 時間帯別(売上番号) 07:00〜08:00
                  ,COUNT(ByTimeZoneSalesNO_0800_0900) ByTimeZoneSalesNO_0800_0900          -- 時間帯別(売上番号) 08:00〜09:00
                  ,COUNT(ByTimeZoneSalesNO_0900_1000) ByTimeZoneSalesNO_0900_1000          -- 時間帯別(売上番号) 09:00〜10:00
                  ,COUNT(ByTimeZoneSalesNO_1000_1100) ByTimeZoneSalesNO_1000_1100          -- 時間帯別(売上番号) 10:00〜11:00
                  ,COUNT(ByTimeZoneSalesNO_1100_1200) ByTimeZoneSalesNO_1100_1200          -- 時間帯別(売上番号) 11:00〜12:00
                  ,COUNT(ByTimeZoneSalesNO_1200_1300) ByTimeZoneSalesNO_1200_1300          -- 時間帯別(売上番号) 12:00〜13:00
                  ,COUNT(ByTimeZoneSalesNO_1300_1400) ByTimeZoneSalesNO_1300_1400          -- 時間帯別(売上番号) 13:00〜14:00
                  ,COUNT(ByTimeZoneSalesNO_1400_1500) ByTimeZoneSalesNO_1400_1500          -- 時間帯別(売上番号) 14:00〜15:00
                  ,COUNT(ByTimeZoneSalesNO_1500_1600) ByTimeZoneSalesNO_1500_1600          -- 時間帯別(売上番号) 15:00〜16:00
                  ,COUNT(ByTimeZoneSalesNO_1600_1700) ByTimeZoneSalesNO_1600_1700          -- 時間帯別(売上番号) 16:00〜17:00
                  ,COUNT(ByTimeZoneSalesNO_1700_1800) ByTimeZoneSalesNO_1700_1800          -- 時間帯別(売上番号) 17:00〜18:00
                  ,COUNT(ByTimeZoneSalesNO_1800_1900) ByTimeZoneSalesNO_1800_1900          -- 時間帯別(売上番号) 18:00〜19:00
                  ,COUNT(ByTimeZoneSalesNO_1900_2000) ByTimeZoneSalesNO_1900_2000          -- 時間帯別(売上番号) 19:00〜20:00
                  ,COUNT(ByTimeZoneSalesNO_2000_2100) ByTimeZoneSalesNO_2000_2100          -- 時間帯別(売上番号) 20:00〜21:00
                  ,COUNT(ByTimeZoneSalesNO_2100_2200) ByTimeZoneSalesNO_2100_2200          -- 時間帯別(売上番号) 21:00〜22:00
                  ,COUNT(ByTimeZoneSalesNO_2200_2300) ByTimeZoneSalesNO_2200_2300          -- 時間帯別(売上番号) 22:00〜23:00
                  ,COUNT(ByTimeZoneSalesNO_2300_2400) ByTimeZoneSalesNO_2300_2400          -- 時間帯別(売上番号) 23:00〜24:00
              FROM (
                    SELECT --history.DepositNO 
                          --,
                          CONVERT(DATE, history.DepositDateTime) RegistDate  -- 登録日
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '00:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '01:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0000_0100  -- 時間帯別(税込) 00:00〜01:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '01:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '02:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0100_0200  -- 時間帯別(税込) 01:00〜02:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '02:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '03:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0200_0300  -- 時間帯別(税込) 02:00〜03:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '03:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '04:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0300_0400  -- 時間帯別(税込) 03:00〜04:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '04:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '05:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0400_0500  -- 時間帯別(税込) 04:00〜05:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '05:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '06:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0500_0600  -- 時間帯別(税込) 05:00〜06:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '06:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '07:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0600_0700  -- 時間帯別(税込) 06:00〜07:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '07:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '08:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0700_0800  -- 時間帯別(税込) 07:00〜08:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '08:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '09:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0800_0900  -- 時間帯別(税込) 08:00〜09:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '09:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '10:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_0900_1000  -- 時間帯別(税込) 09:00〜10:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '10:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '11:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1000_1100  -- 時間帯別(税込) 10:00〜11:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '11:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '12:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1100_1200  -- 時間帯別(税込) 11:00〜12:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '12:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '13:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1200_1300  -- 時間帯別(税込) 12:00〜13:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '13:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '14:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1300_1400  -- 時間帯別(税込) 13:00〜14:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '14:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '15:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1400_1500  -- 時間帯別(税込) 14:00〜15:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '15:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '16:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1500_1600  -- 時間帯別(税込) 15:00〜16:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '16:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '17:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1600_1700  -- 時間帯別(税込) 16:00〜17:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '17:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '18:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1700_1800  -- 時間帯別(税込) 17:00〜18:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '18:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '19:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1800_1900  -- 時間帯別(税込) 18:00〜19:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '19:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '20:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_1900_2000  -- 時間帯別(税込) 19:00〜20:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '20:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '21:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_2000_2100  -- 時間帯別(税込) 20:00〜21:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '21:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '22:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_2100_2200  -- 時間帯別(税込) 21:00〜22:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '22:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '23:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_2200_2300  -- 時間帯別(税込) 22:00〜23:00
                          ,SUM(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '23:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '24:00' THEN CASE WHEN history.RecoredKBN = 1 OR history.CancelKBN = 2 THEN history.TotalGaku * (-1) ELSE history.TotalGaku END
                                ELSE 0
                           END) AS ByTimeZoneTaxIncluded_2300_2400  -- 時間帯別(税込) 23:00〜24:00
                           -- ----------------------------------------------------------------------------------------------------------------------------------------
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '00:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '01:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0000_0100  -- 時間帯別(売上番号) 00:00〜01:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '01:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '02:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0100_0200  -- 時間帯別(売上番号) 01:00〜02:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '02:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '03:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0200_0300  -- 時間帯別(売上番号) 02:00〜03:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '03:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '04:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0300_0400  -- 時間帯別(売上番号) 03:00〜04:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '04:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '05:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0400_0500  -- 時間帯別(売上番号) 04:00〜05:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '05:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '06:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0500_0600  -- 時間帯別(売上番号) 05:00〜06:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '06:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '07:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0600_0700  -- 時間帯別(売上番号) 06:00〜07:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '07:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '08:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0700_0800  -- 時間帯別(売上番号) 07:00〜08:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '08:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '09:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0800_0900  -- 時間帯別(売上番号) 08:00〜09:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '09:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '10:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_0900_1000  -- 時間帯別(売上番号) 09:00〜10:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '10:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '11:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1000_1100  -- 時間帯別(売上番号) 10:00〜11:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '11:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '12:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1100_1200  -- 時間帯別(売上番号) 11:00〜12:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '12:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '13:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1200_1300  -- 時間帯別(売上番号) 12:00〜13:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '13:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '14:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1300_1400  -- 時間帯別(売上番号) 13:00〜14:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '14:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '15:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1400_1500  -- 時間帯別(売上番号) 14:00〜15:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '15:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '16:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1500_1600  -- 時間帯別(売上番号) 15:00〜16:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '16:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '17:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1600_1700  -- 時間帯別(売上番号) 16:00〜17:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '17:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '18:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1700_1800  -- 時間帯別(売上番号) 17:00〜18:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '18:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '19:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1800_1900  -- 時間帯別(売上番号) 18:00〜19:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '19:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '20:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_1900_2000  -- 時間帯別(売上番号) 19:00〜20:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '20:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '21:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_2000_2100  -- 時間帯別(売上番号) 20:00〜21:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '21:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '22:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_2100_2200  -- 時間帯別(売上番号) 21:00〜22:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '22:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '23:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_2200_2300  -- 時間帯別(売上番号) 22:00〜23:00
                          ,MAX(CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '23:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '24:00' THEN sales.SalesNO
                                ELSE NULL
                           END) AS ByTimeZoneSalesNO_2300_2400  -- 時間帯別(売上番号) 23:00〜24:00
                      FROM #Temp_D_DepositHistory0 AS history
                      LEFT OUTER JOIN D_Sales AS sales ON sales.SalesNO = history.Number
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                     group by CONVERT(DATE, history.DepositDateTime), sales.SalesNO
                   ) D
             GROUP BY D.RegistDate
           ) D17;

    -- 【精算処理】ワークテーブル８作成
    SELECT * 
      INTO #Temp_D_DepositHistory8
      FROM (
            SELECT storeCalculation.CalculationDate RegistDate    -- 登録日
                  ,7 DisplayOrder                                 -- 明細表示順位
                  ,storeCalculation.[10000yenNum]                 -- 現金残高10,000枚数
                  ,storeCalculation.[5000yenNum]                  -- 現金残高5,000枚数
                  ,storeCalculation.[2000yenNum]                  -- 現金残高2,000枚数
                  ,storeCalculation.[1000yenNum]                  -- 現金残高1,000枚数
                  ,storeCalculation.[500yenNum]                   -- 現金残高500枚数
                  ,storeCalculation.[100yenNum]                   -- 現金残高100枚数
                  ,storeCalculation.[50yenNum]                    -- 現金残高50枚数
                  ,storeCalculation.[10yenNum]                    -- 現金残高10枚数
                  ,storeCalculation.[5yenNum]                     -- 現金残高5枚数
                  ,storeCalculation.[1yenNum]                     -- 現金残高1枚数
                  ,storeCalculation.[10000yenGaku]                -- 現金残高10,000金額
                  ,storeCalculation.[5000yenGaku]                 -- 現金残高5,000金額
                  ,storeCalculation.[2000yenGaku]                 -- 現金残高2,000金額
                  ,storeCalculation.[1000yenGaku]                 -- 現金残高1,000金額
                  ,storeCalculation.[500yenGaku]                  -- 現金残高500金額
                  ,storeCalculation.[100yenGaku]                  -- 現金残高100金額
                  ,storeCalculation.[50yenGaku]                   -- 現金残高50金額
                  ,storeCalculation.[10yenGaku]                   -- 現金残高10金額
                  ,storeCalculation.[5yenGaku]                    -- 現金残高5金額
                  ,storeCalculation.[1yenGaku]                    -- 現金残高1金額
                  ,storeCalculation.Etcyen                        -- その他金額
                  ,storeCalculation.Change                        -- 釣銭準備金
                  ,tempHistory9.DepositGaku                       -- 現金残高 現金売上(+)
                  ,tempHistory10.DepositGaku CashDeposit          -- 現金残高 現金入金(+)
                  ,tempHistory11.DepositGaku CashPayment          -- 現金残高 現金支払(-) 
                  ,storeCalculation.[10000yenGaku]
                    + storeCalculation.[5000yenGaku]
                    + storeCalculation.[2000yenGaku]
                    + storeCalculation.[1000yenGaku]
                    + storeCalculation.[500yenGaku]
                    + storeCalculation.[100yenGaku]
                    + storeCalculation.[50yenGaku]
                    + storeCalculation.[10yenGaku]
                    + storeCalculation.[5yenGaku]
                    + storeCalculation.[1yenGaku]
                    + storeCalculation.Etcyen
                   AS CashBalance                                 -- 現金残高 現金残高10,000金額〜その他金額までの合計
                  ,storeCalculation.Change
                    + tempHistory9.DepositGaku
                    + tempHistory10.DepositGaku
                    - tempHistory11.DepositGaku
                  AS ComputerTotal                               -- ｺﾝﾋﾟｭｰﾀ計 釣銭準備金〜現金残高 現金支払(-)までの合計
                  ,(
                    storeCalculation.[10000yenGaku]
                     + storeCalculation.[5000yenGaku]
                     + storeCalculation.[2000yenGaku]
                     + storeCalculation.[1000yenGaku]
                     + storeCalculation.[500yenGaku]
                     + storeCalculation.[100yenGaku]
                     + storeCalculation.[50yenGaku]
                     + storeCalculation.[10yenGaku]
                     + storeCalculation.[5yenGaku]
                     + storeCalculation.[1yenGaku]
                     + storeCalculation.Etcyen
                   ) - (
                    storeCalculation.Change
                     + tempHistory9.DepositGaku
                     + tempHistory10.DepositGaku
                     - tempHistory11.DepositGaku
                  ) AS CashShortage                              -- 現金過不足 現金残高-ｺﾝﾋﾟｭｰﾀ計
                  ,tempHistory12.SalesNOCount                     -- 総売 伝票数
                  ,tempHistory12.CustomerCDCount                  -- 総売 客数(人)
                  ,tempHistory12.SalesSUSum                       -- 総売 売上数量
                  ,tempHistory12.TotalGakuSum                     -- 総売 売上金額
                  ,tempHistory13.ForeignTaxableAmount             -- 取引別 外税対象額
                  ,tempHistory13.TaxableAmount                    -- 取引別 内税対象額
                  ,tempHistory13.TaxExemptionAmount               -- 取引別 非課税対象額
                  ,tempHistory13.TotalWithoutTax                  -- 取引別 税抜合計
                  ,tempHistory13.Tax                              -- 取引別 内税
                  ,tempHistory13.OutsideTax                       -- 取引別 外税
                  ,tempHistory13.ConsumptionTax                   -- 取引別 消費税計
                  ,tempHistory13.TaxIncludedTotal                 -- 取引別 税込合計
                  ,tempHistory14.DenominationName1                -- 決済別 金種区分名1
                  ,tempHistory14.Kingaku1                         -- 決済別 金額1
                  ,tempHistory14.DenominationName2                -- 決済別 金種区分名2
                  ,tempHistory14.Kingaku2                         -- 決済別 金額2
                  ,tempHistory14.DenominationName3                -- 決済別 金種区分名3
                  ,tempHistory14.Kingaku3                         -- 決済別 金額3
                  ,tempHistory14.DenominationName4                -- 決済別 金種区分名4
                  ,tempHistory14.Kingaku4                         -- 決済別 金額4
                  ,tempHistory14.DenominationName5                -- 決済別 金種区分名5
                  ,tempHistory14.Kingaku5                         -- 決済別 金額5
                  ,tempHistory14.DenominationName6                -- 決済別 金種区分名6
                  ,tempHistory14.Kingaku6                         -- 決済別 金額6
                  ,tempHistory14.DenominationName7                -- 決済別 金種区分名7
                  ,tempHistory14.Kingaku7                         -- 決済別 金額7
                  ,tempHistory14.DenominationName8                -- 決済別 金種区分名8
                  ,tempHistory14.Kingaku8                         -- 決済別 金額8
                  ,tempHistory14.DenominationName9                -- 決済別 金種区分名9
                  ,tempHistory14.Kingaku9                         -- 決済別 金額9
                  ,tempHistory14.DenominationName10               -- 決済別 金種区分名10
                  ,tempHistory14.Kingaku10                        -- 決済別 金額10
                  ,tempHistory14.DenominationName11               -- 決済別 金種区分名11
                  ,tempHistory14.Kingaku11                        -- 決済別 金額11
                  ,tempHistory14.DenominationName12               -- 決済別 金種区分名12
                  ,tempHistory14.Kingaku12                        -- 決済別 金額12
                  ,tempHistory14.DenominationName13               -- 決済別 金種区分名13
                  ,tempHistory14.Kingaku13                        -- 決済別 金額13
                  ,tempHistory14.DenominationName14               -- 決済別 金種区分名14
                  ,tempHistory14.Kingaku14                        -- 決済別 金額14
                  ,tempHistory14.DenominationName15               -- 決済別 金種区分名15
                  ,tempHistory14.Kingaku15                        -- 決済別 金額15
                  ,tempHistory14.DenominationName16               -- 決済別 金種区分名16
                  ,tempHistory14.Kingaku16                        -- 決済別 金額16
                  ,tempHistory14.DenominationName17               -- 決済別 金種区分名17
                  ,tempHistory14.Kingaku17                        -- 決済別 金額17
                  ,tempHistory14.DenominationName18               -- 決済別 金種区分名18
                  ,tempHistory14.Kingaku18                        -- 決済別 金額18
                  ,tempHistory14.DenominationName19               -- 決済別 金種区分名19
                  ,tempHistory14.Kingaku19                        -- 決済別 金額19
                  ,tempHistory14.DenominationName20               -- 決済別 金種区分名20
                  ,tempHistory14.Kingaku20                        -- 決済別 金額20
                  ,tempHistory15.DepositTransfer                  -- 入金支払計 入金 振込
                  ,tempHistory15.DepositCash                      -- 入金支払計 入金 現金
                  ,tempHistory15.DepositCheck                     -- 入金支払計 入金 小切手
                  ,tempHistory15.DepositBill                      -- 入金支払計 入金 手形
                  ,tempHistory15.DepositOffset                    -- 入金支払計 入金 相殺
                  ,tempHistory15.DepositAdjustment                -- 入金支払計 入金 調整
                  ,tempHistory15.PaymentTransfer                  -- 入金支払計 支払 振込
                  ,tempHistory15.PaymentCash                      -- 入金支払計 支払 現金
                  ,tempHistory15.PaymentCheck                     -- 入金支払計 支払 小切手
                  ,tempHistory15.PaymentBill                      -- 入金支払計 支払 手形
                  ,tempHistory15.PaymentOffset                    -- 入金支払計 支払 相殺
                  ,tempHistory15.PaymentAdjustment                -- 入金支払計 支払 調整
                  ,tempHistory16.OtherAmountReturns               -- 他金額 返品
                  ,tempHistory162.OtherAmountDiscount             -- 他金額 値引
                  ,tempHistory16.OtherAmountCancel                -- 他金額 取消
                  ,tempHistory16.OtherAmountDelivery              -- 他金額 配達
                  ,tempHistory7.ExchangeCount                     -- 両替回数
                  ,tempHistory17.ByTimeZoneTaxIncluded_0000_0100  -- 時間帯別(税込) 00:00〜01:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0100_0200  -- 時間帯別(税込) 01:00〜02:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0200_0300  -- 時間帯別(税込) 02:00〜03:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0300_0400  -- 時間帯別(税込) 03:00〜04:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0400_0500  -- 時間帯別(税込) 04:00〜05:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0500_0600  -- 時間帯別(税込) 05:00〜06:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0600_0700  -- 時間帯別(税込) 06:00〜07:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0700_0800  -- 時間帯別(税込) 07:00〜08:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0800_0900  -- 時間帯別(税込) 08:00〜09:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0900_1000  -- 時間帯別(税込) 09:00〜10:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1000_1100  -- 時間帯別(税込) 10:00〜11:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1100_1200  -- 時間帯別(税込) 11:00〜12:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1200_1300  -- 時間帯別(税込) 12:00〜13:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1300_1400  -- 時間帯別(税込) 13:00〜14:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1400_1500  -- 時間帯別(税込) 14:00〜15:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1500_1600  -- 時間帯別(税込) 15:00〜16:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1600_1700  -- 時間帯別(税込) 16:00〜17:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1700_1800  -- 時間帯別(税込) 17:00〜18:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1800_1900  -- 時間帯別(税込) 18:00〜19:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1900_2000  -- 時間帯別(税込) 19:00〜20:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2000_2100  -- 時間帯別(税込) 20:00〜21:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2100_2200  -- 時間帯別(税込) 21:00〜22:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2200_2300  -- 時間帯別(税込) 22:00〜23:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2300_2400  -- 時間帯別(税込) 23:00〜24:00
                  ,tempHistory17.ByTimeZoneSalesNO_0000_0100      -- 時間帯別件数 00:00〜01:00
                  ,tempHistory17.ByTimeZoneSalesNO_0100_0200      -- 時間帯別件数 01:00〜02:00
                  ,tempHistory17.ByTimeZoneSalesNO_0200_0300      -- 時間帯別件数 02:00〜03:00
                  ,tempHistory17.ByTimeZoneSalesNO_0300_0400      -- 時間帯別件数 03:00〜04:00
                  ,tempHistory17.ByTimeZoneSalesNO_0400_0500      -- 時間帯別件数 04:00〜05:00
                  ,tempHistory17.ByTimeZoneSalesNO_0500_0600      -- 時間帯別件数 05:00〜06:00
                  ,tempHistory17.ByTimeZoneSalesNO_0600_0700      -- 時間帯別件数 06:00〜07:00
                  ,tempHistory17.ByTimeZoneSalesNO_0700_0800      -- 時間帯別件数 07:00〜08:00
                  ,tempHistory17.ByTimeZoneSalesNO_0800_0900      -- 時間帯別件数 08:00〜09:00
                  ,tempHistory17.ByTimeZoneSalesNO_0900_1000      -- 時間帯別件数 09:00〜10:00
                  ,tempHistory17.ByTimeZoneSalesNO_1000_1100      -- 時間帯別件数 10:00〜11:00
                  ,tempHistory17.ByTimeZoneSalesNO_1100_1200      -- 時間帯別件数 11:00〜12:00
                  ,tempHistory17.ByTimeZoneSalesNO_1200_1300      -- 時間帯別件数 12:00〜13:00
                  ,tempHistory17.ByTimeZoneSalesNO_1300_1400      -- 時間帯別件数 13:00〜14:00
                  ,tempHistory17.ByTimeZoneSalesNO_1400_1500      -- 時間帯別件数 14:00〜15:00
                  ,tempHistory17.ByTimeZoneSalesNO_1500_1600      -- 時間帯別件数 15:00〜16:00
                  ,tempHistory17.ByTimeZoneSalesNO_1600_1700      -- 時間帯別件数 16:00〜17:00
                  ,tempHistory17.ByTimeZoneSalesNO_1700_1800      -- 時間帯別件数 17:00〜18:00
                  ,tempHistory17.ByTimeZoneSalesNO_1800_1900      -- 時間帯別件数 18:00〜19:00
                  ,tempHistory17.ByTimeZoneSalesNO_1900_2000      -- 時間帯別件数 19:00〜20:00
                  ,tempHistory17.ByTimeZoneSalesNO_2000_2100      -- 時間帯別件数 20:00〜21:00
                  ,tempHistory17.ByTimeZoneSalesNO_2100_2200      -- 時間帯別件数 21:00〜22:00
                  ,tempHistory17.ByTimeZoneSalesNO_2200_2300      -- 時間帯別件数 22:00〜23:00
                  ,tempHistory17.ByTimeZoneSalesNO_2300_2400      -- 時間帯別件数 23:00〜24:00
                  ,tempHistory12.DiscountGaku                     -- 値引額
              FROM #Temp_D_StoreCalculation1 AS storeCalculation
              LEFT OUTER JOIN #Temp_D_DepositHistory7   AS tempHistory7    ON tempHistory7.RegistDate   = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory9   AS tempHistory9    ON tempHistory9.RegistDate   = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory10  AS tempHistory10   ON tempHistory10.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory11  AS tempHistory11   ON tempHistory11.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory12  AS tempHistory12   ON tempHistory12.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory13  AS tempHistory13   ON tempHistory13.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory14  AS tempHistory14   ON tempHistory14.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory15  AS tempHistory15   ON tempHistory15.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory16  AS tempHistory16   ON tempHistory16.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory162 AS tempHistory162  ON tempHistory162.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory17  AS tempHistory17   ON tempHistory17.RegistDate  = storeCalculation.CalculationDate
           ) D8;


    -- 最終
    SELECT MSI.Picture AS Logo                                   -- ロゴ
          ,MSI.CompanyName                                       -- 会社名
          ,MSI.StoreName                                         -- 店舗名
          ,A.CalendarDate                                        -- 日付
          ,A.Address1                                            -- 住所１
          ,A.Address2                                            -- 住所２
          ,A.TelephoneNO                                         -- 電話番号
          ,A.IssueDate                                           -- 発行日時
          ,REPLACE(CONVERT(VARCHAR,A.IssueDate,120),'-','/') AS BreakIssueDate    -- ブレイク判断用発行日時
          ,A.DepositDate                                         -- 発行日
          ,ROW_NUMBER() OVER(
               PARTITION BY A.StoreCD 
                   ORDER BY A.IssueDate, A.DepositNO             -- レシートと順番を同じにする
           ) AS DetailOrder                                      -- 明細表示順
          ,A.DepositNO
		  ,CASE A.CancelKBN WHEN 0 THEN ' ' 
		                    WHEN 1 THEN '取消'
							WHEN 2 THEN '返品'
							WHEN 3 THEN '訂正'
							ELSE ' '
		   END AS CancelKBN                                      -- 取消区分(1:取消 2:返品 3:訂正)
          ,CASE A.RecoredKBN WHEN 0 THEN 1 WHEN 1 THEN 0 END AS RecoredKBN    -- 赤黒区分(0:黒、1:赤　→　OrderByの為に反転させる)
          ,A.JanCD                                               -- JANCD
          ,A.SKUShortName                                        -- 商品名
          ,A.SalesUnitPrice                                      -- 単価
          ,A.SalesSU                                             -- 数量
          ,A.kakaku                                              -- 価格
          ,A.SalesTax                                            -- 税額
          ,A.SalesTaxRate                                        -- 税率
          ,A.TotalGaku                                           -- 販売合計額
          ,A.SumSalesSU                                          -- 小計数量
          ,A.Subtotal                                            -- 小計金額
          ,A.TargetAmount8                                       -- 8％対象額
          ,A.ConsumptionTax8                                     -- 外税8％
          ,A.TargetAmount10                                      -- 10％対象額
          ,A.ConsumptionTax10                                    -- 外税10％
          ,A.Total                                               -- 合計
          --
          ,tempHistory2.PaymentName1                             -- 支払方法名1
          ,tempHistory2.AmountPay1                               -- 支払方法額1
          ,tempHistory2.PaymentName2                             -- 支払方法名2
          ,tempHistory2.AmountPay2                               -- 支払方法額2
          ,tempHistory2.PaymentName3                             -- 支払方法名3
          ,tempHistory2.AmountPay3                               -- 支払方法額3
          ,tempHistory2.PaymentName4                             -- 支払方法名4
          ,tempHistory2.AmountPay4                               -- 支払方法額4
          ,tempHistory2.PaymentName5                             -- 支払方法名5
          ,tempHistory2.AmountPay5                               -- 支払方法額5
          ,tempHistory2.PaymentName6                             -- 支払方法名6
          ,tempHistory2.AmountPay6                               -- 支払方法額6
          ,tempHistory2.PaymentName7                             -- 支払方法名7
          ,tempHistory2.AmountPay7                               -- 支払方法額7
          ,tempHistory2.PaymentName8                             -- 支払方法名8
          ,tempHistory2.AmountPay8                               -- 支払方法額8
          ,tempHistory2.PaymentName9                             -- 支払方法名9
          ,tempHistory2.AmountPay9                               -- 支払方法額9
          ,tempHistory2.PaymentName10                            -- 支払方法名10
          ,tempHistory2.AmountPay10                              -- 支払方法額10
          --
          ,tempHistory3.Refund                                   -- 釣銭
          ,tempHistory3.DiscountGaku                             -- 値引額
          --
          ,A.StaffReceiptPrint                                   -- 担当CD
          ,A.StoreReceiptPrint                                   -- 店舗CD
          ,A.SalesNO + convert(varchar,A.IssueDate,126) + (case A.RecoredKBN when 0 then '1' when 1 then '0' end)  AS SalesNO  -- 売上番号(Report側ブレイク判断用)
          ,A.SalesNO AS DispSalesNO                              -- 表示用売上番号

          --
          ,tempHistory4.RegistDate ChangePreparationRegistDate   -- 登録日
          ,tempHistory4.ChangePreparationDate1                   -- 釣銭準備日1
          ,tempHistory4.ChangePreparationName1                   -- 釣銭準備名1
          ,tempHistory4.ChangePreparationAmount1                 -- 釣銭準備額1
          ,tempHistory4.ChangePreparationDate2                   -- 釣銭準備日2
          ,tempHistory4.ChangePreparationName2                   -- 釣銭準備名2
          ,tempHistory4.ChangePreparationAmount2                 -- 釣銭準備額2
          ,tempHistory4.ChangePreparationDate3                   -- 釣銭準備日3
          ,tempHistory4.ChangePreparationName3                   -- 釣銭準備名3
          ,tempHistory4.ChangePreparationAmount3                 -- 釣銭準備額3
          ,tempHistory4.ChangePreparationDate4                   -- 釣銭準備日4
          ,tempHistory4.ChangePreparationName4                   -- 釣銭準備名4
          ,tempHistory4.ChangePreparationAmount4                 -- 釣銭準備額4
          ,tempHistory4.ChangePreparationDate5                   -- 釣銭準備日5
          ,tempHistory4.ChangePreparationName5                   -- 釣銭準備名5
          ,tempHistory4.ChangePreparationAmount5                 -- 釣銭準備額5
          ,tempHistory4.ChangePreparationDate6                   -- 釣銭準備日6
          ,tempHistory4.ChangePreparationName6                   -- 釣銭準備名6
          ,tempHistory4.ChangePreparationAmount6                 -- 釣銭準備額6
          ,tempHistory4.ChangePreparationDate7                   -- 釣銭準備日7
          ,tempHistory4.ChangePreparationName7                   -- 釣銭準備名7
          ,tempHistory4.ChangePreparationAmount7                 -- 釣銭準備額7
          ,tempHistory4.ChangePreparationDate8                   -- 釣銭準備日8
          ,tempHistory4.ChangePreparationName8                   -- 釣銭準備名8
          ,tempHistory4.ChangePreparationAmount8                 -- 釣銭準備額8
          ,tempHistory4.ChangePreparationDate9                   -- 釣銭準備日9
          ,tempHistory4.ChangePreparationName9                   -- 釣銭準備名9
          ,tempHistory4.ChangePreparationAmount9                 -- 釣銭準備額9
          ,tempHistory4.ChangePreparationDate10                  -- 釣銭準備日10
          ,tempHistory4.ChangePreparationName10                  -- 釣銭準備名10
          ,tempHistory4.ChangePreparationAmount10                -- 釣銭準備額10
          ,tempHistory4.ChangePreparationRemark                  -- 釣銭準備備考
          --
          ,tempHistory5.RegistDate MiscDepositRegistDate         -- 登録日
          ,tempHistory5.MiscDepositDate1                         -- 雑入金日1
          ,tempHistory5.MiscDepositName1                         -- 雑入金名1
          ,tempHistory5.MiscDepositAmount1                       -- 雑入金額1
          ,tempHistory5.MiscDepositRemark                        -- 雑入金備考
          --
          ,tempHistory51.RegistDate DepositRegistDate            -- 登録日
          ,tempHistory51.CustomerCD                              -- 入金元CD
          ,tempHistory51.CustomerName                            -- 入金元名
          ,tempHistory51.DepositDate1                            -- 入金日1
          ,tempHistory51.DepositName1                            -- 入金名1
          ,tempHistory51.DepositAmount1                          -- 入金額1
          ,tempHistory51.DepositRemark                           -- 入金備考
          --
          ,tempHistory6.RegistDate MiscPaymentRegistDate         -- 登録日
          ,tempHistory6.MiscPaymentDate1                         -- 雑支払日1
          ,tempHistory6.MiscPaymentName1                         -- 雑支払名1
          ,tempHistory6.MiscPaymentAmount1                       -- 雑支払額1
          ,tempHistory6.MiscPaymentRemark                        -- 雑支払備考
          --
          ,tempHistory7.RegistDate ExchangeRegistDate            -- 登録日
          ,tempHistory7.ExchangeDate1                            -- 両替日1
          ,tempHistory7.ExchangeName1                            -- 両替名1
          ,tempHistory7.ExchangeAmount1                          -- 両替額1
          ,tempHistory7.ExchangeDenomination1                    -- 両替紙幣1
          ,tempHistory7.ExchangeCount1                           -- 両替枚数1
          ,tempHistory7.ExchangeRemark                           -- 両替備考
          --
          ,tempHistory8.RegistDate CashBalanceRegistDate         -- 登録日
          ,tempHistory8.[10000yenNum]                            --【精算処理】現金残高　10,000　枚数
          ,tempHistory8.[5000yenNum]                             --【精算処理】現金残高　5,000　枚数
          ,tempHistory8.[2000yenNum]                             --【精算処理】現金残高　2,000　枚数
          ,tempHistory8.[1000yenNum]                             --【精算処理】現金残高　1,000　枚数
          ,tempHistory8.[500yenNum]                              --【精算処理】現金残高　500　枚数
          ,tempHistory8.[100yenNum]                              --【精算処理】現金残高　100　枚数
          ,tempHistory8.[50yenNum]                               --【精算処理】現金残高　50　枚数
          ,tempHistory8.[10yenNum]                               --【精算処理】現金残高　10　枚数
          ,tempHistory8.[5yenNum]                                --【精算処理】現金残高　5　枚数
          ,tempHistory8.[1yenNum]                                --【精算処理】現金残高　1　枚数
          ,tempHistory8.[10000yenGaku]                           --【精算処理】現金残高　10,000　金額
          ,tempHistory8.[5000yenGaku]                            --【精算処理】現金残高　5,000　金額
          ,tempHistory8.[2000yenGaku]                            --【精算処理】現金残高　2,000　金額
          ,tempHistory8.[1000yenGaku]                            --【精算処理】現金残高　1,000　金額
          ,tempHistory8.[500yenGaku]                             --【精算処理】現金残高　500　金額
          ,tempHistory8.[100yenGaku]                             --【精算処理】現金残高　100　金額
          ,tempHistory8.[50yenGaku]                              --【精算処理】現金残高　50　金額
          ,tempHistory8.[10yenGaku]                              --【精算処理】現金残高　10　金額
          ,tempHistory8.[5yenGaku]                               --【精算処理】現金残高　5　金額
          ,tempHistory8.[1yenGaku]                               --【精算処理】現金残高　1　金額
          ,tempHistory8.Etcyen                                   --【精算処理】その他金額
          ,tempHistory8.Change                                   --【精算処理】釣銭準備金
          ,tempHistory8.DepositGaku                              --【精算処理】現金残高 現金売上(+)
          ,tempHistory8.CashDeposit                              --【精算処理】現金残高 現金入金(+)
          ,tempHistory8.CashPayment                              --【精算処理】現金残高 現金支払(-)
          ,tempHistory8.CashBalance                              --【精算処理】現金残高 その他金額〜現金残高現金支払(-)までの合計
          ,tempHistory8.ComputerTotal                            --【精算処理】ｺﾝﾋﾟｭｰﾀ計 現金残高 10,000　金額〜現金残高　1　金額までの合計
          ,tempHistory8.CashShortage                             --【精算処理】現金残高 現金過不足
          ,tempHistory8.SalesNOCount                             --【精算処理】総売　伝票数
          ,tempHistory8.CustomerCDCount                          --【精算処理】総売　客数(人)
          ,tempHistory8.SalesSUSum                               --【精算処理】総売　売上数量
          ,tempHistory8.TotalGakuSum                             --【精算処理】総売　売上金額
          ,tempHistory8.ForeignTaxableAmount                     --【精算処理】取引別　外税対象額
          ,tempHistory8.TaxableAmount                            --【精算処理】取引別　内税対象額
          ,tempHistory8.TaxExemptionAmount                       --【精算処理】取引別　非課税対象額
          ,tempHistory8.TotalWithoutTax                          --【精算処理】取引別　税抜合計
          ,tempHistory8.Tax                                      --【精算処理】取引別　内税
          ,tempHistory8.OutsideTax                               --【精算処理】取引別　外税
          ,tempHistory8.ConsumptionTax                           --【精算処理】取引別　消費税計
          ,tempHistory8.TaxIncludedTotal                         --【精算処理】取引別　税込合計
          ,tempHistory8.DiscountGaku                             --【精算処理】取引別　値引額
          ,tempHistory8.DenominationName1                        --【精算処理】決済別  金種区分名1
          ,tempHistory8.Kingaku1                                 --【精算処理】決済別  金額1
          ,tempHistory8.DenominationName2                        --【精算処理】決済別  金種区分名2
          ,tempHistory8.Kingaku2                                 --【精算処理】決済別  金額2
          ,tempHistory8.DenominationName3                        --【精算処理】決済別  金種区分名3
          ,tempHistory8.Kingaku3                                 --【精算処理】決済別  金額3
          ,tempHistory8.DenominationName4                        --【精算処理】決済別  金種区分名4
          ,tempHistory8.Kingaku4                                 --【精算処理】決済別  金額4
          ,tempHistory8.DenominationName5                        --【精算処理】決済別  金種区分名5
          ,tempHistory8.Kingaku5                                 --【精算処理】決済別  金額5
          ,tempHistory8.DenominationName6                        --【精算処理】決済別  金種区分名6
          ,tempHistory8.Kingaku6                                 --【精算処理】決済別  金額6
          ,tempHistory8.DenominationName7                        --【精算処理】決済別  金種区分名7
          ,tempHistory8.Kingaku7                                 --【精算処理】決済別  金額7
          ,tempHistory8.DenominationName8                        --【精算処理】決済別  金種区分名8
          ,tempHistory8.Kingaku8                                 --【精算処理】決済別  金額8
          ,tempHistory8.DenominationName9                        --【精算処理】決済別  金種区分名9
          ,tempHistory8.Kingaku9                                 --【精算処理】決済別  金額9
          ,tempHistory8.DenominationName10                       --【精算処理】決済別  金種区分名10
          ,tempHistory8.Kingaku10                                --【精算処理】決済別  金額10
          ,tempHistory8.DenominationName11                       --【精算処理】決済別  金種区分名11
          ,tempHistory8.Kingaku11                                --【精算処理】決済別  金額11
          ,tempHistory8.DenominationName12                       --【精算処理】決済別  金種区分名12
          ,tempHistory8.Kingaku12                                --【精算処理】決済別  金額12
          ,tempHistory8.DenominationName13                       --【精算処理】決済別  金種区分名13
          ,tempHistory8.Kingaku13                                --【精算処理】決済別  金額13
          ,tempHistory8.DenominationName14                       --【精算処理】決済別  金種区分名14
          ,tempHistory8.Kingaku14                                --【精算処理】決済別  金額14
          ,tempHistory8.DenominationName15                       --【精算処理】決済別  金種区分名15
          ,tempHistory8.Kingaku15                                --【精算処理】決済別  金額15
          ,tempHistory8.DenominationName16                       --【精算処理】決済別  金種区分名16
          ,tempHistory8.Kingaku16                                --【精算処理】決済別  金額16
          ,tempHistory8.DenominationName17                       --【精算処理】決済別  金種区分名17
          ,tempHistory8.Kingaku17                                --【精算処理】決済別  金額17
          ,tempHistory8.DenominationName18                       --【精算処理】決済別  金種区分名18
          ,tempHistory8.Kingaku18                                --【精算処理】決済別  金額18
          ,tempHistory8.DenominationName19                       --【精算処理】決済別  金種区分名19
          ,tempHistory8.Kingaku19                                --【精算処理】決済別  金額19
          ,tempHistory8.DenominationName20                       --【精算処理】決済別  金種区分名20
          ,tempHistory8.Kingaku20                                --【精算処理】決済別  金額20
          ,tempHistory8.DepositTransfer                          --【精算処理】入金支払計 入金 振込
          ,tempHistory8.DepositCash                              --【精算処理】入金支払計 入金 現金
          ,tempHistory8.DepositCheck                             --【精算処理】入金支払計 入金 小切手
          ,tempHistory8.DepositBill                              --【精算処理】入金支払計 入金 手形
          ,tempHistory8.DepositOffset                            --【精算処理】入金支払計 入金 相殺
          ,tempHistory8.DepositAdjustment                        --【精算処理】入金支払計 入金 調整
          ,tempHistory8.PaymentTransfer                          --【精算処理】入金支払計 支払 振込
          ,tempHistory8.PaymentCash                              --【精算処理】入金支払計 支払 現金
          ,tempHistory8.PaymentCheck                             --【精算処理】入金支払計 支払 小切手
          ,tempHistory8.PaymentBill                              --【精算処理】入金支払計 支払 手形
          ,tempHistory8.PaymentOffset                            --【精算処理】入金支払計 支払 相殺
          ,tempHistory8.PaymentAdjustment                        --【精算処理】入金支払計 支払 調整
          ,tempHistory8.OtherAmountReturns                       --【精算処理】他金額 返品
          ,tempHistory8.OtherAmountDiscount                      --【精算処理】他金額 値引
          ,tempHistory8.OtherAmountCancel                        --【精算処理】他金額 取消
          ,tempHistory8.OtherAmountDelivery                      --【精算処理】他金額 配達
          ,tempHistory8.ExchangeCount                            --【精算処理】両替回数
          ,tempHistory8.ByTimeZoneTaxIncluded_0000_0100          --【精算処理】時間帯別(税込) 00:00〜01:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0100_0200          --【精算処理】時間帯別(税込) 01:00〜02:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0200_0300          --【精算処理】時間帯別(税込) 02:00〜03:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0300_0400          --【精算処理】時間帯別(税込) 03:00〜04:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0400_0500          --【精算処理】時間帯別(税込) 04:00〜05:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0500_0600          --【精算処理】時間帯別(税込) 05:00〜06:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0600_0700          --【精算処理】時間帯別(税込) 06:00〜07:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0700_0800          --【精算処理】時間帯別(税込) 07:00〜08:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0800_0900          --【精算処理】時間帯別(税込) 08:00〜09:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0900_1000          --【精算処理】時間帯別(税込) 09:00〜10:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1000_1100          --【精算処理】時間帯別(税込) 10:00〜11:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1100_1200          --【精算処理】時間帯別(税込) 11:00〜12:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1200_1300          --【精算処理】時間帯別(税込) 12:00〜13:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1300_1400          --【精算処理】時間帯別(税込) 13:00〜14:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1400_1500          --【精算処理】時間帯別(税込) 14:00〜15:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1500_1600          --【精算処理】時間帯別(税込) 15:00〜16:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1600_1700          --【精算処理】時間帯別(税込) 16:00〜17:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1700_1800          --【精算処理】時間帯別(税込) 17:00〜18:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1800_1900          --【精算処理】時間帯別(税込) 18:00〜19:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1900_2000          --【精算処理】時間帯別(税込) 19:00〜20:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2000_2100          --【精算処理】時間帯別(税込) 20:00〜21:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2100_2200          --【精算処理】時間帯別(税込) 21:00〜22:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2200_2300          --【精算処理】時間帯別(税込) 22:00〜23:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2300_2400          --【精算処理】時間帯別(税込) 23:00〜24:00
          ,tempHistory8.ByTimeZoneSalesNO_0000_0100              --【精算処理】時間帯別件数 00:00〜01:00
          ,tempHistory8.ByTimeZoneSalesNO_0100_0200              --【精算処理】時間帯別件数 01:00〜02:00
          ,tempHistory8.ByTimeZoneSalesNO_0200_0300              --【精算処理】時間帯別件数 02:00〜03:00
          ,tempHistory8.ByTimeZoneSalesNO_0300_0400              --【精算処理】時間帯別件数 03:00〜04:00
          ,tempHistory8.ByTimeZoneSalesNO_0400_0500              --【精算処理】時間帯別件数 04:00〜05:00
          ,tempHistory8.ByTimeZoneSalesNO_0500_0600              --【精算処理】時間帯別件数 05:00〜06:00
          ,tempHistory8.ByTimeZoneSalesNO_0600_0700              --【精算処理】時間帯別件数 06:00〜07:00
          ,tempHistory8.ByTimeZoneSalesNO_0700_0800              --【精算処理】時間帯別件数 07:00〜08:00
          ,tempHistory8.ByTimeZoneSalesNO_0800_0900              --【精算処理】時間帯別件数 08:00〜09:00
          ,tempHistory8.ByTimeZoneSalesNO_0900_1000              --【精算処理】時間帯別件数 09:00〜10:00
          ,tempHistory8.ByTimeZoneSalesNO_1000_1100              --【精算処理】時間帯別件数 10:00〜11:00
          ,tempHistory8.ByTimeZoneSalesNO_1100_1200              --【精算処理】時間帯別件数 11:00〜12:00
          ,tempHistory8.ByTimeZoneSalesNO_1200_1300              --【精算処理】時間帯別件数 12:00〜13:00
          ,tempHistory8.ByTimeZoneSalesNO_1300_1400              --【精算処理】時間帯別件数 13:00〜14:00
          ,tempHistory8.ByTimeZoneSalesNO_1400_1500              --【精算処理】時間帯別件数 14:00〜15:00
          ,tempHistory8.ByTimeZoneSalesNO_1500_1600              --【精算処理】時間帯別件数 15:00〜16:00
          ,tempHistory8.ByTimeZoneSalesNO_1600_1700              --【精算処理】時間帯別件数 16:00〜17:00
          ,tempHistory8.ByTimeZoneSalesNO_1700_1800              --【精算処理】時間帯別件数 17:00〜18:00
          ,tempHistory8.ByTimeZoneSalesNO_1800_1900              --【精算処理】時間帯別件数 18:00〜19:00
          ,tempHistory8.ByTimeZoneSalesNO_1900_2000              --【精算処理】時間帯別件数 19:00〜20:00
          ,tempHistory8.ByTimeZoneSalesNO_2000_2100              --【精算処理】時間帯別件数 20:00〜21:00
          ,tempHistory8.ByTimeZoneSalesNO_2100_2200              --【精算処理】時間帯別件数 21:00〜22:00
          ,tempHistory8.ByTimeZoneSalesNO_2200_2300              --【精算処理】時間帯別件数 22:00〜23:00
          ,tempHistory8.ByTimeZoneSalesNO_2300_2400              --【精算処理】時間帯別件数 23:00〜24:00
      FROM (
            SELECT calendar.CalendarDate                                           -- 日付
                  ,@StoreCD AS StoreCD
                  ,store.StoreName                                                 -- 店舗名
                  ,store.Address1                                                  -- 住所１
                  ,store.Address2                                                  -- 住所２
                  ,store.TelephoneNO                                               -- 電話番号
                  ,CASE 
                       WHEN tempHistory1.RegistDate IS NOT NULL THEN tempHistory1.RegistDate
                       --ELSE CONCAT(calendar.CalendarDate, ' 00:00:00.000')
                       ELSE tempHistory0.DepositDateTime
                   END IssueDate                                                   -- 発行日時
                  ,CASE 
                       WHEN tempHistory1.DepositDate IS NOT NULL THEN tempHistory1.DepositDate
                       ELSE calendar.CalendarDate
                   END DepositDate                                                 -- 発行日
                  ,tempHistory1.SalesNO
                  ,tempHistory1.JanCD                                              -- JANCD
                  ,tempHistory1.SKUShortName                                       -- 商品名
                  ,tempHistory1.SalesUnitPrice                                     -- 単価
                  ,tempHistory1.SalesSU                                            -- 数量
                  ,tempHistory1.kakaku                                             -- 価格
                  ,tempHistory1.SalesTax                                           -- 税額
                  ,tempHistory1.SalesTaxRate                                       -- 税率
                  ,tempHistory1.TotalGaku                                          -- 販売合計額
                  --
                  ,(SELECT SUM(CASE 
                                   WHEN SalesSU IS NULL THEN 1 
                                   ELSE SalesSU 
                               END)
                      FROM #Temp_D_DepositHistory1 t
                     WHERE t.SalesNO= tempHistory1.SalesNO
                     AND   t.RegistDate = tempHistory1.RegistDate
                     AND   t.RecoredKBN = tempHistory1.RecoredKBN
                    ) SumSalesSU                                                   -- 小計数量
                  ,(SELECT SUM(kakaku) 
                      FROM #Temp_D_DepositHistory1 t 
                     WHERE t.SalesNO = tempHistory1.SalesNO
                     AND   t.RegistDate = tempHistory1.RegistDate
                     AND   t.RecoredKBN = tempHistory1.RecoredKBN
                    ) Subtotal                                                     -- 小計金額
                  ,tempHistory1.TargetAmount8                                      -- 8％対象額
                  ,tempHistory1.SalesTax8 ConsumptionTax8                          -- 外税8％
                  ,tempHistory1.TargetAmount10                                     -- 10％対象額
                  ,tempHistory1.SalesTax10 ConsumptionTax10                        -- 外税10％
                  ,(SELECT SUM(TotalGaku) 
                      FROM #Temp_D_DepositHistory1 t 
                     WHERE t.SalesNO = tempHistory1.SalesNO
                     AND   t.RegistDate = tempHistory1.RegistDate
                     AND   t.RecoredKBN = tempHistory1.RecoredKBN
                    ) Total                                                        -- 合計
                  --
                  ,ISNULL(tempHistory1.StaffReceiptPrint
                         ,(SELECT top 1 staff.ReceiptPrint
                             FROM F_Staff(CONVERT(DATE, GETDATE())) AS staff
                            WHERE staff.StaffCD = tempHistory0.InsertOperator
                              AND staff.DeleteFlg = 0
                            ORDER BY staff.ChangeDate DESC
                            )) AS StaffReceiptPrint                                -- 担当CD
                  ,store.ReceiptPrint StoreReceiptPrint                            -- 店舗CD
                  ,tempHistory0.DepositNO
                  ,tempHistory0.CancelKBN											--取消区分(1:取消、2:返品、3:訂正
                  ,tempHistory0.RecoredKBN
              FROM M_Calendar AS calendar
             INNER JOIN F_Store(CONVERT(DATE, GETDATE())) AS store
                ON store.StoreCD = @StoreCD
               AND store.DeleteFlg = 0
             INNER JOIN #Temp_D_DepositHistory0 AS tempHistory0 ON tempHistory0.StoreCD = store.StoreCD
                                                               AND tempHistory0.AccountingDate = calendar.CalendarDate
              LEFT OUTER JOIN #Temp_D_DepositHistory1 AS tempHistory1 ON tempHistory1.DepositNO = tempHistory0.DepositNO
             WHERE calendar.CalendarDate >= convert(date, @DateFrom)
               AND calendar.CalendarDate <= convert(date, @DateTo)
            --      )
           ) A
      LEFT OUTER JOIN #Temp_D_DepositHistory2 tempHistory2   ON tempHistory2.SalesNO = A.SalesNO
                                                            AND tempHistory2.RecoredKBN = A.RecoredKBN
                                                            AND tempHistory2.DepositDateTime = A.DepositDate
      LEFT OUTER JOIN #Temp_D_DepositHistory3 tempHistory3   ON tempHistory3.SalesNO = A.SalesNO
      
      LEFT OUTER JOIN #Temp_D_DepositHistory4 tempHistory4   ON tempHistory4.DepositNO = A.DepositNO
      LEFT OUTER JOIN #Temp_D_DepositHistory5 tempHistory5   ON tempHistory5.DepositNO = A.DepositNO
      LEFT OUTER JOIN #Temp_D_DepositHistory51 tempHistory51 ON tempHistory51.DepositNO = A.DepositNO
      LEFT OUTER JOIN #Temp_D_DepositHistory6 tempHistory6   ON tempHistory6.DepositNO = A.DepositNO
      LEFT OUTER JOIN #Temp_D_DepositHistory7 tempHistory7   ON tempHistory7.DepositNO = A.DepositNO
      
      LEFT OUTER JOIN #Temp_D_DepositHistory8 tempHistory8   ON tempHistory8.RegistDate = A.CalendarDate
      LEFT OUTER JOIN M_StoreImage MSI ON MSI.StoreCD = @StoreCD

     ORDER BY DetailOrder ASC
         ;
    
    -- ワークテーブルを削除
        DROP TABLE #Temp_D_StoreCalculation1;
        DROP TABLE #Temp_D_DepositHistory0;
        DROP TABLE #Temp_D_DepositHistory1;
        DROP TABLE #Temp_D_DepositHistory2;
        DROP TABLE #Temp_D_DepositHistory3;
        DROP TABLE #Temp_D_DepositHistory4;
        DROP TABLE #Temp_D_DepositHistory5;
        DROP TABLE #Temp_D_DepositHistory51;
        DROP TABLE #Temp_D_DepositHistory6;
        DROP TABLE #Temp_D_DepositHistory7;
        DROP TABLE #Temp_D_DepositHistory8;
        DROP TABLE #Temp_D_DepositHistory9;
        DROP TABLE #Temp_D_DepositHistory10;
        DROP TABLE #Temp_D_DepositHistory11;
        DROP TABLE #Temp_D_DepositHistory12;
        DROP TABLE #Temp_D_DepositHistory13;
        DROP TABLE #Temp_D_DepositHistory14;
        DROP TABLE #Temp_D_DepositHistory15;
        DROP TABLE #Temp_D_DepositHistory16;
        DROP TABLE #Temp_D_DepositHistory162;
        DROP TABLE #Temp_D_DepositHistory17;

END
