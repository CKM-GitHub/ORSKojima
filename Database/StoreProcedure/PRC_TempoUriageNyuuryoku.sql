 BEGIN TRY 
 Drop Procedure dbo.[PRC_TempoUriageNyuuryoku]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
GO
DROP TYPE [dbo].[T_TempoUriage]
GO

/****** Object:  UserDefinedTableType [dbo].[T_TempoUriage]    Script Date: 2022/01/25 6:04:47 PM ******/
Create TYPE [dbo].[T_TempoUriage] AS TABLE(
	[DenNo] [varchar](11) NULL,
	[DenRows] [int] NULL,
	[SalesSU] [int] NULL,
	[CommentOutStore] [varchar](80) Null,
	[UpdateFlg] [tinyint] NULL
)
GO

--  ======================================================================
--       Program Call    店舗レジ 売上入力
--       Program ID      TempoUriageNyuuryoku
--       Create date:    2020.3.19
--    ======================================================================

CREATE PROCEDURE [PRC_TempoUriageNyuuryoku]
    (@OperateMode   int,                 -- 処理区分（1:新規 2:修正 3:削除）
    @StoreCD        varchar(4),
    @SalesDate      varchar(10),
    @BillingType    tinyint,

    @Table          T_TempoUriage READONLY,
    @Operator       varchar(10),
    @PC             varchar(30),
    @OutSalesNO     varchar(11) OUTPUT
)AS
BEGIN
    DECLARE @PROGRAME_NAME  varchar(100) = 'TempoUriageNyuuryoku'
    DECLARE @W_ERR          tinyint = 0
    DECLARE @SYSDATETIME    datetime = SYSDATETIME()
    DECLARE @OperateModeNm  varchar(10)
    DECLARE @KeyItem        varchar(100)

    DECLARE @curNumber      varchar(11),    
            @curCustomerBillingCD   varchar(13),
            @curCustomerBillingType tinyint

    DECLARE @SalesNO        varchar(11),
            @InstructionNO  varchar(11),
            @ShippingNO     varchar(11),
            @BillingNO      varchar(11),
            @FirstCollectPlanDate   varchar(10)


    
    IF @OperateMode = 1
    BEGIN
		SET @OperateModeNm = '新規'

        --Table転送仕様Ａ
        UPDATE D_Reserve
           SET ShippingSu = D_Reserve.ShippingSu + D_Reserve.ReserveSu
              ,UpdateOperator = @Operator  
              ,UpdateDateTime = @SYSDATETIME
         FROM @Table tbl
         WHERE D_Reserve.Number = tbl.DenNO
         AND D_Reserve.NumberRows = tbl.DenRows
         AND D_Reserve.DeleteDateTime IS NULL
         
		--Table転送仕様Ｂ
        UPDATE D_Stock
           SET StockSu = D_Stock.StockSu - A.ReserveSu
              ,ReserveSu = D_Stock.ReserveSu - A.ReserveSu
              ,ShippingSu = D_Stock.ShippingSu + A.ReserveSu
              ,UpdateOperator = @Operator
              ,UpdateDateTime = @SYSDATETIME
         FROM @Table AS tbl
         INNER JOIN D_Reserve AS A
         ON A.Number = tbl.DenNO
         AND A.NumberRows = tbl.DenRows
         AND A.DeleteDateTime IS NULL
         WHERE D_Stock.StockNO = A.StockNO
         AND D_Stock.DeleteDateTime IS NULL



        DECLARE CUR_BBB CURSOR FOR
        SELECT tbl.DenNO, customer.BillingCD, customer.BillingType
        FROM @Table AS tbl
        CROSS APPLY(
                    SELECT TOP 1 M.BillingCD, M.BillingType
                    FROM D_Juchuu JH
                    INNER JOIN M_Customer AS M ON M.CustomerCD = JH.CustomerCD AND M.DeleteFlg = 0 AND M.ChangeDate < CONVERT(date, @SalesDate) 
                    WHERE JH.JuchuuNO = tbl.DenNO
                    AND JH.DeleteDateTime IS NULL
                    ORDER BY M.ChangeDate DESC
                    ) customer
        GROUP BY tbl.DenNO, customer.BillingCD, customer.BillingType


        OPEN CUR_BBB
        FETCH NEXT FROM CUR_BBB
        INTO @curNumber, @curCustomerBillingCD, @curCustomerBillingType


        WHILE @@FETCH_STATUS = 0
        BEGIN
            --L_Log
            SET @KeyItem = @curNumber
                
            EXEC L_Log_Insert_SP
                @SYSDATETIME,
                @Operator,
                @PROGRAME_NAME,
                @PC,
                @OperateModeNm,
                @KeyItem
		        

            ----------------------------------------
            --D_Instruction, D_InstructionDetails
            ----------------------------------------
            EXEC Fnc_GetNumber
                14,                 --inSeqKBN 14:InstructionNO
                @SalesDate,         --inChangeDate
                @StoreCD,
                @Operator,
                @InstructionNO OUTPUT
                
            IF ISNULL(@InstructionNO,'') = ''
            BEGIN
                SET @W_ERR = 1
                RETURN @W_ERR
            END

            --Table転送仕様Ｃ
            INSERT INTO D_Instruction
                (InstructionNO
                ,DeliveryPlanNO
                ,InstructionKBN
                ,InstructionDate
                ,DeliveryPlanDate
                ,FromSoukoCD
                ,DeliveryName
                ,DeliverySoukoCD
                ,DeliveryZip1CD
                ,DeliveryZip2CD
                ,DeliveryAddress1
                ,DeliveryAddress2
                ,DeliveryMailAddress
                ,DeliveryTelphoneNO
                ,DeliveryFaxNO
                ,DecidedDeliveryDate
                ,DecidedDeliveryTime
                ,CarrierCD
                ,CashOnDelivery
                ,CashOnAmount
                ,CashOnIncludeTax
                ,PaymentMethodCD
                ,CommentOutStore
                ,CommentInStore
                ,InvoiceNO
                ,OntheDayFLG
                ,ExpressFLG
                ,PrintDate
                ,PrintStaffCD
                ,InsertOperator
                ,InsertDateTime
                ,UpdateOperator
                ,UpdateDateTime
                ,DeleteOperator
                ,DeleteDateTime)
            SELECT
                @InstructionNO
                ,NULL               --DeliveryPlanNO
                ,3                  --InstructionKBN
                ,CONVERT(date, @SalesDate)  --InstructionDate
                ,CONVERT(date, @SalesDate)  --DeliveryPlanDate
                ,MAX(R.SoukoCD)
                ,MAX(JH.DeliveryName)
                ,NULL               --DeliverySoukoCD
                ,MAX(JH.DeliveryZipCD1)
                ,MAX(JH.DeliveryZipCD2)
                ,MAX(JH.DeliveryAddress1)
                ,MAX(JH.DeliveryAddress2)
                ,NULL               --DeliveryMailAddress
                ,MAX(ISNULL(JH.DeliveryTel11,'')) + '-' + MAX(ISNULL(JH.DeliveryTel12,'')) + '-' + MAX(ISNULL(JH.DeliveryTel13,''))
                ,NULL               --DeliveryFaxNO
                ,NULL               --DecidedDeliveryDate
                ,NULL               --DecidedDeliveryTime
                ,NULL               --CarrierCD
                ,0                  --CashOnDelivery
                ,0                  --CashOnAmount
                ,0                  --CashOnIncludeTax
                ,NULL               --PaymentMethodCD
                ,NULL               --CommentOutStore
                ,NULL               --CommentInStore
                ,NULL               --InvoiceNO
                ,0                  --OntheDayFLG
                ,0                  --ExpressFLG
                ,NULL               --PrintDate
                ,NULL               --PrintStaffCD
                ,@Operator          --InsertOperator
                ,@SYSDATETIME       --InsertDateTime
                ,@Operator          --UpdateOperator
                ,@SYSDATETIME       --UpdateDateTime
                ,NULL               --DeleteOperator
                ,NULL               --DeleteDateTime
            FROM D_JuchuuDetails JD

            INNER JOIN @Table tbl
            ON tbl.DenNo = @curNumber
            AND tbl.DenNo = JD.JuchuuNO
            AND tbl.DenRows = JD.JuchuuRows

            INNER JOIN D_Juchuu JH
            ON JH.JuchuuNO = JD.JuchuuNO
            AND JH.DeleteDateTime IS NULL

            INNER JOIN D_Reserve R
            ON R.Number = JD.JuchuuNO
            AND R.NumberRows = JD.JuchuuRows
            AND R.DeleteDateTime IS NULL

            WHERE JD.JuchuuNO = @curNumber
            AND JD.DeleteDateTime IS NULL
            --GROUP BY JD.JuchuuNO, JD.SoukoCD
            GROUP BY JD.JuchuuNO

            --Table転送仕様Ｄ
            INSERT INTO D_InstructionDetails
               (InstructionNO
               ,InstructionRows
               ,InstructionKBN
               ,ReserveNO
               ,SKUCD
               ,AdminNO
               ,JanCD
               ,CommentOutStore
               ,CommentInStore
               ,InstructionSu
               ,InsertOperator
               ,InsertDateTime
               ,UpdateOperator
               ,UpdateDateTime
               ,DeleteOperator
               ,DeleteDateTime)
            SELECT
                @InstructionNO AS InstructionNO
               ,ROW_NUMBER() OVER(ORDER BY JD.JuchuuNO, JD.JuchuuRows, R.ReserveNO) --InstructionRows
               ,3                   --InstructionKBN
               ,R.ReserveNO
               ,R.SKUCD
               ,R.AdminNO
               ,R.JanCD
               ,NULL                --CommentOutStore
               ,NULL                --CommentInStore
               ,R.ShippingSu        --InstructionSu
               ,@Operator
               ,@SYSDATETIME
               ,@Operator
               ,@SYSDATETIME
               ,NULL                --DeleteOperator
               ,NULL                --DeleteDateTime
            FROM D_JuchuuDetails JD

            INNER JOIN @Table tbl
            ON tbl.DenNo = @curNumber
            AND tbl.DenNo = JD.JuchuuNO
            AND tbl.DenRows = JD.JuchuuRows

            INNER JOIN D_Reserve R
            ON R.Number = JD.JuchuuNO
            AND R.NumberRows = JD.JuchuuRows
            AND R.DeleteDateTime IS NULL

            WHERE JD.JuchuuNO = @curNumber
            AND   JD.DeleteDateTime IS NULL


            ----------------------------------------
            --D_Shipping, D_ShippingDetails
            ----------------------------------------
            EXEC Fnc_GetNumber
                6,                  --inSeqKBN 6:ShippingNO
                @SalesDate,         --inChangeDate
                @StoreCD,
                @Operator,
                @ShippingNO OUTPUT

            IF ISNULL(@ShippingNO,'') = ''
            BEGIN
                SET @W_ERR = 1
                RETURN @W_ERR
            END

            --Table転送仕様Ｅ
            INSERT INTO D_Shipping
                (ShippingNO
                ,SoukoCD
                ,ShippingKBN
                ,InstructionNO
                ,CarrierCD
                ,DecidedDeliveryDate
                ,DecidedDeliveryTime
                ,ShippingDate
                ,InputDateTime
                ,StaffCD
                ,UnitsCount
                ,BoxSize
                ,PrintDate
                ,PrintStaffCD
                ,LinkageDateTime
                ,LinkageStaffCD
                ,InvoiceNO
                ,InvNOLinkDateTime
                ,ReceiveStaffCD
                ,InsertOperator
                ,InsertDateTime
                ,UpdateOperator
                ,UpdateDateTime
                ,DeleteOperator
                ,DeleteDateTime)
            SELECT
                @ShippingNO
                ,MAX(R.SoukoCD)
                ,3                  --ShippingKBN
                ,@InstructionNO     --InstructionNO
                ,NULL               --CarrierCD
                ,NULL               --DecidedDeliveryDate
                ,NULL               --DecidedDeliveryTime
                ,CONVERT(date, @SalesDate)  --ShippingDate
                ,@SYSDATETIME       --InputDateTime
                ,@Operator          --StaffCD
                ,1                  --UnitsCount
                ,NULL               --BoxSize
                ,NULL               --PrintDate
                ,NULL               --PrintStaffCD
                ,NULL               --LinkageDateTime
                ,NULL               --LinkageStaffCD
                ,NULL               --InvoiceNO
                ,NULL               --InvNOLinkDateTime
                ,NULL               --ReceiveStaffCD
                ,@Operator
                ,@SYSDATETIME
                ,@Operator
                ,@SYSDATETIME
                ,NULL               --DeleteOperator
                ,NULL               --DeleteDateTime
            FROM D_JuchuuDetails JD

            INNER JOIN @Table tbl
            ON tbl.DenNo = @curNumber
            AND tbl.DenNo = JD.JuchuuNO
            AND tbl.DenRows = JD.JuchuuRows

            INNER JOIN D_Juchuu JH
            ON JH.JuchuuNO = JD.JuchuuNO
            AND JH.DeleteDateTime IS NULL

            INNER JOIN D_Reserve R
            ON R.Number = JD.JuchuuNO
            AND R.NumberRows = JD.JuchuuRows
            AND R.DeleteDateTime IS NULL

            WHERE JD.JuchuuNO = @curNumber
            AND   JD.DeleteDateTime IS NULL
            --GROUP BY JD.JuchuuNO, JD.SoukoCD
            GROUP BY JD.JuchuuNO

            --Table転送仕様Ｆ
            INSERT INTO D_ShippingDetails
               (ShippingNO
               ,ShippingRows
               ,ShippingKBN
               ,Number
               ,NumberRows
               ,JanCD
               ,AdminNO
               ,SKUCD
               ,SKUName
               ,ColorName
               ,SizeName
               ,ShippingSu
               ,InstructionNO
               ,InstructionRows
               ,InsertOperator
               ,InsertDateTime
               ,UpdateOperator
               ,UpdateDateTime
               ,DeleteOperator
               ,DeleteDateTime)
            SELECT
                @ShippingNO
               ,ROW_NUMBER() OVER(ORDER BY R.ReserveNO)
               ,3                   --ShippingKBN
               ,JD.JuchuuNO
               ,JD.JuchuuRows
               ,R.JanCD
               ,R.AdminNO
               ,R.SKUCD
               ,JD.SKUName
               ,JD.ColorName
               ,JD.SizeName
               ,R.ShippingSu
               ,ID.InstructionNO
               ,ID.InstructionRows
               ,@Operator
               ,@SYSDATETIME
               ,@Operator
               ,@SYSDATETIME
               ,NULL                --DeleteOperator
               ,NULL                --DeleteDateTime
            FROM D_JuchuuDetails AS JD

            INNER JOIN @Table tbl
            ON tbl.DenNo = @curNumber
            AND tbl.DenNo = JD.JuchuuNO
            AND tbl.DenRows = JD.JuchuuRows

            INNER JOIN D_Reserve R
            ON R.Number = JD.JuchuuNO
            AND R.NumberRows = JD.JuchuuRows
            AND R.DeleteDateTime IS NULL

            INNER JOIN D_InstructionDetails ID
            ON ID.InstructionNO = @InstructionNO
            AND ID.ReserveNO = R.ReserveNO
            AND ID.DeleteDateTime IS NULL

            WHERE JD.JuchuuNO = @curNumber
            AND   JD.DeleteDateTime IS NULL


            ----------------------------------------
            --D_Sales, D_SalesDetails
            ----------------------------------------
            EXEC Fnc_GetNumber
                3,                  --inSeqKBN 3:SalesNO
                @SalesDate,         --inChangeDate
                @StoreCD,
                @Operator,
                @SalesNO OUTPUT
                    
            IF ISNULL(@SalesNO,'') = ''
            BEGIN
                SET @W_ERR = 1
                RETURN @W_ERR
            END
                
            --Table転送仕様Ｇ
            INSERT INTO D_Sales
                (SalesNO
                ,StoreCD
                ,SalesDate
                ,ShippingNO
                ,CustomerCD
                ,CustomerName
                ,CustomerName2
                ,BillingType
                ,Age
                ,SalesHontaiGaku
                ,SalesHontaiGaku0
                ,SalesHontaiGaku8
                ,SalesHontaiGaku10
                ,SalesTax
                ,SalesTax8
                ,SalesTax10
                ,SalesGaku
                ,LastPoint
                ,WaitingPoint
                ,StaffCD
                ,PrintDate
                ,PrintStaffCD
                ,Discount
                ,Discount8
                ,Discount10
                ,DiscountTax
                ,DiscountTax8
                ,DiscountTax10                   
                ,CostGaku
                ,ProfitGaku
                ,PurchaseNO
                ,SalesEntryKBN
                ,NouhinsyoComment
                ,InsertOperator
                ,InsertDateTime
                ,UpdateOperator
                ,UpdateDateTime
                ,DeleteOperator
                ,DeleteDateTime)
            SELECT
                @SalesNO
                ,@StoreCD
                ,CONVERT(date, @SalesDate)
                ,@ShippingNO
                ,MAX(JH.CustomerCD)
                ,MAX(JH.CustomerName)
                ,MAX(JH.CustomerName2)
                ,CASE WHEN @BillingType = 1 THEN 1 ELSE @curCustomerBillingType END
                ,5 AS Age	        --5:その他
                ,SUM(JD.JuchuuHontaiGaku)                                                   --SalesHontaiGaku
                ,SUM(CASE WHEN JD.JuchuuTaxRitsu = 0 THEN JD.JuchuuHontaiGaku ELSE 0 END)   --SalesHontaiGaku0
                ,SUM(CASE WHEN JD.JuchuuTaxRitsu = 8 THEN JD.JuchuuHontaiGaku ELSE 0 END)   --SalesHontaiGaku8
                ,SUM(CASE WHEN JD.JuchuuTaxRitsu = 10 THEN JD.JuchuuHontaiGaku ELSE 0 END)  --SalesHontaiGaku10
                ,SUM(JD.JuchuuTax)                                                          --SalesTax
                ,SUM(CASE WHEN JD.JuchuuTaxRitsu = 8 THEN JD.JuchuuTax ELSE 0 END)          --SalesTax8
                ,SUM(CASE WHEN JD.JuchuuTaxRitsu = 10 THEN JD.JuchuuTax ELSE 0 END)         --SalesTax10
                ,SUM(JD.JuchuuHontaiGaku) + SUM(JD.JuchuuTax) AS SalesGaku
                ,0	                --LastPoint
                ,0 	                --WaitingPoint
                ,@Operator          --StaffCD
                ,NULL               --PrintDate
                ,NULL               --PrintStaffCD
                ,0 As Discount
                ,0 As Discount8
                ,0 As Discount10
                ,0 As DiscountTax
                ,0 As DiscountTax8
                ,0 As DiscountTax10
                ,0 AS CostGaku
                ,0 AS ProfitGaku
                ,NULL AS PurchaseNO
                ,3 AS SalesEntryKBN
                ,NULL AS NouhinsyoComment
                ,@Operator
                ,@SYSDATETIME
                ,@Operator
                ,@SYSDATETIME
                ,NULL               --DeleteOperator
                ,NULL               --DeleteDateTime
            FROM D_JuchuuDetails AS JD

            INNER JOIN @Table tbl
            ON tbl.DenNo = @curNumber
            AND tbl.DenNo = JD.JuchuuNO
            AND tbl.DenRows = JD.JuchuuRows

            INNER JOIN D_Juchuu AS JH
            ON JH.JuchuuNO = JD.JuchuuNO
            AND JH.DeleteDateTime IS NULL

            WHERE JD.JuchuuNO = @curNumber
            AND JD.DeleteDateTime IS NULL
            GROUP BY JD.JuchuuNO

            --Table転送仕様Ｈ
            INSERT INTO D_SalesDetails
               (SalesNO
               ,SalesRows
               ,JuchuuNO
               ,JuchuuRows
               ,NotPrintFLG
               ,AddSalesRows
               ,ShippingNO
               ,AdminNO
               ,SKUCD
               ,JanCD
               ,SKUName
               ,ColorName
               ,SizeName
               ,SalesSU
               ,SalesUnitPrice
               ,TaniCD
               ,SalesHontaiGaku
               ,SalesTax
               ,SalesGaku
               ,SalesTaxRitsu
               ,ProperGaku
               ,DiscountGaku
               ,CostUnitPrice
               ,CostGaku
               ,ProfitGaku
               ,CommentOutStore
               ,CommentInStore
               ,IndividualClientName
               ,DeliveryNoteFLG
               ,BillingPrintFLG
               ,PurchaseNO
               ,PurchaseRows
               ,InsertOperator
               ,InsertDateTime
               ,UpdateOperator
               ,UpdateDateTime
               ,DeleteOperator
               ,DeleteDateTime)
            SELECT
                @SalesNO
               ,ROW_NUMBER() OVER(ORDER BY JD.JuchuuRows)
               ,JD.JuchuuNO
               ,JD.JuchuuRows
               ,JD.NotPrintFLG
               ,0                   --AddSalesRows
               ,@ShippingNO
               ,JD.AdminNO
               ,JD.SKUCD
               ,JD.JanCD
               ,JD.SKUName
               ,JD.ColorName
               ,JD.SizeName
               ,JD.JuchuuSuu		--SalesSU
               ,JD.JuchuuUnitPrice  --SalesUnitPrice
               ,JD.TaniCD
               ,JD.JuchuuHontaiGaku --SalesHontaiGaku
               ,JD.JuchuuTax 		--vSalesTax
               ,JD.JuchuuGaku		--SalesGaku
               ,JD.JuchuuTaxRitsu   --SalesTaxRitsu
               ,JD.JuchuuGaku       --ProperGaku
               ,0                   --DiscountGaku
               ,0                   --CostUnitPrice
               ,0                   --CostGaku
               ,0                   --ProfitGaku
               ,tbl.CommentOutStore             --CommentOutaStore
               ,NULL                --CommentInStore
               ,JD.IndividualClientName --IndividualClientName
               ,0   	            --DeliveryNoteFLG
               ,0		            --BillingPrintFLG
               ,NULL                --PurchaseNO
               ,0                   --PurchaseRows
               ,@Operator
               ,@SYSDATETIME
               ,@Operator
               ,@SYSDATETIME
               ,NULL                --DeleteOperator
               ,NULL                --DeleteDate
            FROM D_JuchuuDetails AS JD

            INNER JOIN @Table tbl
            ON tbl.DenNo = @curNumber
            AND tbl.DenNo = JD.JuchuuNO
            AND tbl.DenRows = JD.JuchuuRows

            INNER JOIN D_Juchuu AS JH
            ON JH.JuchuuNO = JD.JuchuuNO
            AND JH.DeleteDateTime IS NULL

            WHERE JD.JuchuuNO = @curNumber
            AND JD.DeleteDateTime IS NULL


            ----------------------------------------
            --D_CollectPlan, D_CollectPlanDetails
            ----------------------------------------
            --Form.請求ボタン＝「即請求」の場合のみ
            IF @BillingType = 1
            BEGIN
                --請求番号（回収予定データに請求番号を更新するため先に取得する）
                EXEC Fnc_GetNumber
                    15,                 --inSeqKBN 15:BillingNO
                    @SalesDate,         --inChangeDate
                    @StoreCD,
                    @Operator,
                    @BillingNO OUTPUT

                IF ISNULL(@BillingNO,'') = ''
                BEGIN
                    SET @W_ERR = 1
                    RETURN @W_ERR
                END
            END

            --回収予定日
            EXEC Fnc_PlanDate_SP
                0,                          --0:回収,1:支払
                @curCustomerBillingCD,      --in請求先CD
                @SalesDate,                 --inChangeDate
                0,                          --帳端区分
                @FirstCollectPlanDate OUTPUT

            --Table転送仕様Ｉ
            INSERT INTO D_CollectPlan
                (--CollectPlanNO IDENTITY
                SalesNO
                ,JuchuuNO
                ,JuchuuKBN
                ,StoreCD
                ,CustomerCD
                ,HontaiGaku
                ,HontaiGaku0
                ,HontaiGaku8
                ,HontaiGaku10
                ,Tax
                ,Tax8
                ,Tax10
                ,CollectPlanGaku
                ,AdjustTax8
                ,AdjustTax10
                ,BillingType
                ,BillingDate
                ,BillingNO
                ,MonthlyBillingNO
                ,PaymentMethodCD
                ,CardProgressKBN
                ,PaymentProgressKBN
                ,InvalidFLG
                ,BillingCloseDate
                ,FirstCollectPlanDate
                ,ReminderFLG
                ,NoReminderDate
                ,NextCollectPlanDate
                ,ActionCD
                ,NextActionCD
                ,LastReminderNO
                ,Program
                ,BillingConfirmFlg
                ,InsertOperator
                ,InsertDateTime
                ,UpdateOperator
                ,UpdateDateTime
                ,DeleteOperator
                ,DeleteDateTime)
            SELECT
                --CollectPlanNO IDENTITY
                @SalesNO
                ,JH.JuchuuNO
                ,JH.JuchuuKBN
                ,SH.StoreCD
                ,@curCustomerBillingCD                     
                ,SH.SalesHontaiGaku     --HontaiGaku
                ,SH.SalesHontaiGaku0    --HontaiGaku0
                ,SH.SalesHontaiGaku8    --HontaiGaku8
                ,SH.SalesHontaiGaku10   --HontaiGaku10
                ,SH.SalesTax            --Tax
                ,SH.SalesTax8           --Tax8
                ,SH.SalesTax10          --Tax10
                ,SH.SalesGaku           --CollectPlanGaku
                ,0                      --AdjustTax8
                ,0                      --AdjustTax10
                ,CASE WHEN @BillingType = 1 THEN 1 ELSE @curCustomerBillingType END --BillingType
                ,CASE WHEN @BillingType = 1 THEN SH.SalesDate ELSE NULL END --BillingDate
                ,CASE WHEN @BillingType = 1 THEN @BillingNO ELSE NULL END
                ,NULL	                --MonthlyBillingNO
                ,JH.PaymentMethodCD
                ,0                      --CardProgressKBN
                ,0                      --PaymentProgressKBN
                ,0                      --InvalidFLG
                ,NULL                   --BillingCloseDate
                ,CONVERT(date, @FirstCollectPlanDate)
                ,0                      --ReminderFLG
                ,NULL                   --NoReminderDate
                ,NULL                   --NextCollectPlanDate
                ,NULL                   --ActionCD
                ,NULL                   --NextActionCD
                ,NULL                   --LastReminderNO
                ,@PROGRAME_NAME         --Program
                ,CASE WHEN @BillingType = 1 THEN 1 ELSE 0 END   --BillingConfirmFlg
                ,@Operator
                ,@SYSDATETIME
                ,@Operator
                ,@SYSDATETIME
                ,NULL                   --DeleteOperator
                ,NULL                   --DeleteDateTime
            FROM D_Sales AS SH

            INNER JOIN D_Juchuu JH
            ON JH.JuchuuNO = @curNumber
            AND JH.DeleteDateTime IS NULL
            
            WHERE SH.SalesNO = @SalesNO
            AND SH.DeleteDateTime IS NULL

            --Table転送仕様Ｊ
            INSERT INTO D_CollectPlanDetails
                (CollectPlanNO
                ,CollectPlanRows
                ,SalesNO
                ,SalesRows
                ,JuchuuNO
                ,JuchuuRows
                ,JuchuuKBN
                ,HontaiGaku
                ,Tax
                ,CollectPlanGaku
                ,TaxRitsu
                ,FirstCollectPlanDate
                ,PaymentProgressKBN
                ,BillingPrintFLG
                ,AdjustTax
                ,InsertOperator
                ,InsertDateTime
                ,UpdateOperator
                ,UpdateDateTime
                ,DeleteOperator
                ,DeleteDateTime)
            SELECT
                SCOPE_IDENTITY()        --CollectPlanNO
                ,ROW_NUMBER() OVER(ORDER BY SD.SalesRows) --CollectPlanRows
                ,SD.SalesNO
                ,SD.SalesRows
                ,SD.JuchuuNO
                ,SD.JuchuuRows
                ,JH.JuchuuKBN
                ,SD.SalesHontaiGaku     --HontaiGaku
                ,SD.SalesTax            --Tax
                ,SD.SalesGaku           --CollectPlanGaku
                ,SD.SalesTaxRitsu       --TaxRitsu
                ,CONVERT(date, @FirstCollectPlanDate)
                ,0                      --PaymentProgressKBN
                ,0                      --BillingPrintFLG
                ,0	                    --AdjustTax
                ,@Operator
                ,@SYSDATETIME
                ,@Operator
                ,@SYSDATETIME
                ,NULL                   --DeleteOperator
                ,NULL                   --DeleteDateTime
            FROM D_SalesDetails AS SD

            INNER JOIN D_Juchuu AS JH
            ON JH.JuchuuNO = SD.JuchuuNO
            AND JH.DeleteDateTime IS NULL
            
            WHERE SD.SalesNO = @SalesNO
            AND SD.JuchuuNO = @curNumber
            AND SD.DeleteDateTime IS NULL
            

            ----------------------------------------
            --D_Billing, D_BillingDetails
            ----------------------------------------
            --Form.請求ボタン＝「即請求」の場合のみ
            IF @BillingType = 1
            BEGIN
                --Table転送仕様Ｋ
                INSERT INTO D_Billing
                        (BillingNO
                        ,BillingType
                        ,StoreCD
                        ,BillingCloseDate
                        ,CollectPlanDate
                        ,BillingCustomerCD
                        ,ProcessingNO
                        ,SumBillingHontaiGaku
                        ,SumBillingHontaiGaku0
                        ,SumBillingHontaiGaku8
                        ,SumBillingHontaiGaku10
                        ,SumBillingTax
                        ,SumBillingTax8
                        ,SumBillingTax10
                        ,SumBillingGaku
                        ,AdjustHontaiGaku0
                        ,AdjustHontaiGaku8
                        ,AdjustHontaiGaku10
                        ,AdjustTax8
                        ,AdjustTax10
                        ,TotalBillingHontaiGaku
                        ,TotalBillingHontaiGaku0
                        ,TotalBillingHontaiGaku8
                        ,TotalBillingHontaiGaku10
                        ,TotalBillingTax
                        ,TotalBillingTax8
                        ,TotalBillingTax10
                        ,BillingGaku
                        ,PrintDateTime
                        ,PrintStaffCD
                        ,CollectDate
                        ,LastCollectDate
                        ,CollectStaffCD
                        ,CollectGaku
                        ,LastBillingGaku
                        ,LastCollectGaku
                        ,BillingConfirmFlg
                        ,InsertOperator
                        ,InsertDateTime
                        ,UpdateOperator
                        ,UpdateDateTime
                        ,DeleteOperator
                        ,DeleteDateTime)
                    SELECT
                        @BillingNO
                        ,1                      --BillingType
                        ,SH.StoreCD
                        ,SH.SalesDate
                        ,CONVERT(date, @FirstCollectPlanDate)
                        ,@curCustomerBillingCD
                        ,NULL                   --ProcessingNO
                        ,SH.SalesHontaiGaku     --SumBillingHontaiGaku 
                        ,SH.SalesHontaiGaku0    --SumBillingHontaiGaku0 
                        ,SH.SalesHontaiGaku8    --SumBillingHontaiGaku8 
                        ,SH.SalesHontaiGaku10   --SumBillingHontaiGaku10 
                        ,SH.SalesTax            --SumBillingTax 
                        ,SH.SalesTax8           --SumBillingTax8 
                        ,SH.SalesTax10          --SumBillingTax10 
                        ,SH.SalesGaku           --SumBillingGaku
                        ,0                      --AdjustHontaiGaku0
                        ,0                      --AdjustHontaiGaku8 
                        ,0                      --AdjustHontaiGaku10 
                        ,0                      --AdjustTax8 
                        ,0                      --AdjustTax10 
                        ,SH.SalesHontaiGaku        
                        ,SH.SalesHontaiGaku0
                        ,SH.SalesHontaiGaku8
                        ,SH.SalesHontaiGaku10
                        ,SH.SalesTax
                        ,SH.SalesTax8
                        ,SH.SalesTax10
                        ,SH.SalesGaku
                        ,NULL                   --PrintDateTime
                        ,NULL                   --PrintStaffCD
                        ,NULL                   --CollectDate
                        ,NULL                   --LastCollectDate
                        ,NULL                   --CollectStaffCD
                        ,0                      --CollectGaku
                        ,0                      --LastBillingGaku
                        ,0                      --LastCollectGaku 
                        ,1                      -- BillingConfirmFlg
                        ,@Operator  
                        ,@SYSDATETIME
                        ,@Operator  
                        ,@SYSDATETIME
                        ,NULL                  
                        ,NULL
                    FROM D_Sales AS SH
                    WHERE SH.SalesNO = @SalesNO
                    AND SH.DeleteDateTime IS NULL

                --Table転送仕様Ｌ
                INSERT INTO D_BillingDetails
                       (BillingNO
                       ,BillingType
                       ,BillingRows
                       ,StoreCD
                       ,BillingCloseDate
                       ,CustomerCD
                       ,SalesNO
                       ,SalesRows
                       ,CollectPlanNO
                       ,CollectPlanRows
                       ,BillingHontaiGaku
                       ,BillingTax
                       ,BillingGaku
                       ,TaxRitsu
                       ,InvoiceFLG
                       ,InsertOperator
                       ,InsertDateTime
                       ,UpdateOperator
                       ,UpdateDateTime
                       ,DeleteOperator
                       ,DeleteDateTime)
                 SELECT
                       @BillingNO
                       ,1                   --BillingType
                       ,ROW_NUMBER() OVER(ORDER BY SD.SalesRows) AS BillingRows
                       ,SH.StoreCD
                       ,SH.SalesDate        --BillingCloseDate
                       ,SH.CustomerCD
                       ,SD.SalesNO
                       ,SD.SalesRows 
                       ,CD.CollectPlanNO 
                       ,CD.CollectPlanRows 
                       ,SD.SalesHontaiGaku 
                       ,SD.SalesTax 
                       ,SD.SalesGaku        --CollectPlanGaku 
                       ,SD.SalesTaxRitsu 
                       ,0                   --InvoiceFLG 
                       ,@Operator  
                       ,@SYSDATETIME
                       ,@Operator  
                       ,@SYSDATETIME
                       ,NULL                  
                       ,NULL
                       
                    FROM D_SalesDetails AS SD
                    
                    LEFT OUTER JOIN D_CollectPlanDetails AS CD
                    ON CD.SalesNO = SD.SalesNO
                    AND CD.SalesRows = SD.SalesRows
                    AND CD.DeleteDateTime IS Null
                    
                    LEFT OUTER JOIN D_Sales AS SH
                    ON SH.SalesNO = SD.SalesNO
                    AND SH.DeleteDateTime IS Null

                    WHERE SD.SalesNO = @SalesNO  
                    AND SD.DeleteDateTime IS NULL
            END
                

            ----------------------------------------
            --D_JuchuuDetails
            ----------------------------------------
            --Table転送仕様Ｍ
            UPDATE D_JuchuuDetails
            SET  SalesDate = CONVERT(date, @SalesDate)
                ,SalesNO = @SalesNO
                ,UpdateOperator = @Operator
                ,UpdateDateTime = @SYSDATETIME
            WHERE JuchuuNO = @curNumber
            AND DeleteDateTime IS NULL
            AND EXISTS (SELECT * FROM @Table tbl WHERE tbl.DenNo = JuchuuNO AND tbl.DenRows = JuchuuRows)

            
            ----------------------------------------
            --D_Warehousing
            ----------------------------------------
            --Table転送仕様Ｎ(入出庫履歴)
            INSERT INTO D_Warehousing
                (--WarehousingNO IDENTITY
                WarehousingDate
                ,SoukoCD
                ,RackNO
                ,StockNO
                ,JanCD
                ,AdminNO
                ,SKUCD
                ,WarehousingKBN
                ,DeleteFlg
                ,Number
                ,NumberRow
                ,VendorCD
                ,ToStoreCD
                ,ToSoukoCD
                ,ToRackNO
                ,ToStockNO
                ,FromStoreCD
                ,FromSoukoCD
                ,FromRackNO
                ,CustomerCD
                ,Quantity
                ,UnitPrice
                ,Amount
                ,Program
                ,InsertOperator
                ,InsertDateTime
                ,UpdateOperator
                ,UpdateDateTime
                ,DeleteOperator
                ,DeleteDateTime)
            SELECT
                --WarehousingNO IDENTITY
                 CONVERT(date, @SalesDate)   --WarehousingDate
                ,DS.SoukoCD
                ,DS.RackNO
                ,DS.StockNO
                ,SHD.JanCD
                ,SHD.AdminNO
                ,SHD.SKUCD
                ,5                          --WarehousingKBN 5：出荷売上
                ,0                          --DeleteFlg
                ,SHD.ShippingNO
                ,SHD.ShippingRows
                ,NULL                       --VendorCD
                ,NULL                       --ToStoreCD
                ,NULL                       --ToSoukoCD
                ,NULL                       --ToRackNO
                ,NULL                       --ToStockNO
                ,NULL                       --FromStoreCD
                ,NULL                       --FromSoukoCD
                ,NULL                       --FromRackNO
                ,JH.CustomerCD
                ,SHD.ShippingSu             --Quantity
                ,0                          --UnitPrice
                ,0                          --Amount
                ,@PROGRAME_NAME
                ,@Operator
                ,@SYSDATETIME
                ,@Operator
                ,@SYSDATETIME
                ,NULL                       --DeleteOperator
                ,NULL                       --DeleteDateTime
            FROM D_ShippingDetails AS SHD

            INNER JOIN D_InstructionDetails ID
            ON ID.InstructionNO = SHD.InstructionNO
            AND ID.InstructionRows = SHD.InstructionRows

            INNER JOIN D_Reserve AS R 
            ON R.ReserveNO = ID.ReserveNO
            AND R.DeleteDateTime IS NULL

            INNER JOIN D_Stock AS DS
            ON DS.StockNO = R.StockNO
            AND DS.DeleteDateTime IS NULL

            INNER JOIN D_Juchuu AS JH
            ON JH.JuchuuNO = SHD.Number
            AND JH.DeleteDateTime IS NULL

            WHERE SHD.ShippingNO = @ShippingNO
            AND SHD.Number = @curNumber
            AND SHD.DeleteDateTime IS NULL
            ORDER BY SHD.ShippingNO, SHD.ShippingRows
            

            ----------------------------------------
            --D_SalesTran, D_SalesTranDetails
            ----------------------------------------
            --Table転送仕様Ｏ(売上履歴-黒)
            INSERT INTO D_SalesTran
                (--DataNO IDENTITY
                ProcessKBN
                ,RecoredKBN
                ,SalesNO
                ,StoreCD
                ,SalesDate
                ,ShippingNO
                ,CustomerCD
                ,CustomerName
                ,CustomerName2
                ,BillingType
                ,SalesHontaiGaku
                ,SalesHontaiGaku0
                ,SalesHontaiGaku8
                ,SalesHontaiGaku10
                ,SalesTax
                ,SalesTax8
                ,SalesTax10
                ,SalesGaku
                ,LastPoint
                ,WaitingPoint
                ,StaffCD
                ,PrintDate
                ,PrintStaffCD
                ,StoreSalesUpdateFLG
                ,StoreSalesUpdatetime
                ,Discount
                ,Discount8
                ,Discount10
                ,DiscountTax
                ,DiscountTax8
                ,DiscountTax10
                ,PurchaseAmount
                ,TaxAmount
                ,DiscountAmount
                ,BillingAmount
                ,PointAmount
                ,CardDenominationCD
                ,CardAmount
                ,CashAmount
                ,DepositAmount
                ,RefundAmount
                ,CreditAmount
                ,Denomination1CD
                ,Denomination1Amount
                ,Denomination2CD
                ,Denomination2Amount
                ,AdvanceAmount
                ,TotalAmount
                ,InsertOperator
                ,InsertDateTime)
            SELECT
                --DataNO IDENTITY
                1                   --ProcessKBN
                ,0 	                --RecoredKBN
                ,SH.SalesNO
                ,SH.StoreCD
                ,SH.SalesDate
                ,SH.ShippingNO
                ,SH.CustomerCD
                ,SH.CustomerName
                ,SH.CustomerName2
                ,SH.BillingType
                ,SH.SalesHontaiGaku
                ,SH.SalesHontaiGaku0
                ,SH.SalesHontaiGaku8
                ,SH.SalesHontaiGaku10
                ,SH.SalesTax
                ,SH.SalesTax8
                ,SH.SalesTax10
                ,SH.SalesGaku
                ,SH.LastPoint
                ,SH.WaitingPoint
                ,SH.StaffCD
                ,SH.PrintDate
                ,SH.PrintStaffCD
                ,9	                    --StoreSalesUpdateFLG
                ,@SYSDATETIME	        --StoreSalesUpdatetime
                ,SH.Discount
                ,SH.Discount8
                ,SH.Discount10
                ,SH.DiscountTax
                ,SH.DiscountTax8
                ,SH.DiscountTax10
                ,SH.SalesGaku            --PurchaseAmount
                ,SH.SalesTax             --TaxAmount
                ,SH.Discount             --DiscountAmount
                ,SH.SalesGaku            --BillingAmount
                ,0                       --PointAmount
                ,NULL                    --CardDenominationCD
                ,0                       --CardAmount
                ,0                       --CashAmount
                ,0                       --DepositAmount
                ,0                       --RefundAmount
                ,0                       --CreditAmount
                ,NULL                    --Denomination1CD
                ,0                       --Denomination1Amount
                ,NULL                    --Denomination2CD
                ,0                       --Denomination2Amount
                ,0                       --AdvanceAmount
                ,0                       --TotalAmount
                ,@Operator	            --InsertOperator
                ,@SYSDATETIME	        --InsertDateTime
            FROM D_Sales AS SH
            WHERE SH.SalesNO = @SalesNO
            AND SH.DeleteDateTime IS NULL
           
            --Table転送仕様Ｐ(売上明細履歴-黒)
            INSERT INTO D_SalesDetailsTran
                (DataNo
                ,DataRows
                ,ProcessKBN
                ,RecoredKBN
                ,SalesNO
                ,SalesRows
                ,JuchuuNO
                ,JuchuuRows
                ,NotPrintFLG
                ,AddSalesRows
                ,ShippingNO
                ,SKUCD
                ,AdminNO
                ,JanCD
                ,SKUName
                ,ColorName
                ,SizeName
                ,SalesSU
                ,SalesUnitPrice
                ,TaniCD
                ,SalesHontaiGaku
                ,SalesTax
                ,SalesGaku
                ,SalesTaxRitsu
                ,CommentOutStore
                ,CommentInStore
                ,ProperGaku
                ,DiscountGaku
                ,IndividualClientName
                ,DeliveryNoteFLG
                ,BillingPrintFLG
                ,DeleteOperator
                ,DeleteDateTime
                ,InsertOperator
                ,InsertDateTime)
            SELECT
                (SELECT SCOPE_IDENTITY())
                ,SD.SalesRows	        --DataRows
                ,1	                    --ProcessKBN
                ,0	                    --RecoredKBN
                ,SD.SalesNO
                ,SD.SalesRows
                ,SD.JuchuuNO
                ,SD.JuchuuRows
                ,SD.NotPrintFLG
                ,SD.AddSalesRows
                ,SD.ShippingNO
                ,SD.SKUCD
                ,SD.AdminNO
                ,SD.JanCD
                ,SD.SKUName
                ,SD.ColorName
                ,SD.SizeName
                ,SD.SalesSU
                ,SD.SalesUnitPrice
                ,SD.TaniCD
                ,SD.SalesHontaiGaku
                ,SD.SalesTax
                ,SD.SalesGaku
                ,SD.SalesTaxRitsu
                ,SD.CommentOutStore
                ,SD.CommentInStore
                ,SD.ProperGaku
                ,SD.DiscountGaku
                ,SD.IndividualClientName
                ,SD.DeliveryNoteFLG
                ,SD.BillingPrintFLG
                ,SD.DeleteOperator
                ,SD.DeleteDateTime
                ,@Operator
                ,@SYSDATETIME
            FROM D_SalesDetails AS SD
            WHERE SD.SalesNO = @SalesNO
            AND SD.DeleteDateTime IS NULL


            FETCH NEXT FROM CUR_BBB
            INTO @curNumber, @curCustomerBillingCD, @curCustomerBillingType
        END
        
        CLOSE CUR_BBB
        DEALLOCATE CUR_BBB
        
    END --END of IF @OperateMode = 1



    ELSE IF @OperateMode = 3 --削除--
    BEGIN
        SET @OperateModeNm = '削除'

        DECLARE CUR_AAA CURSOR FOR
        SELECT tbl.DenNO
        FROM @Table tbl
        GROUP BY tbl.DenNO
            
        OPEN CUR_AAA

        FETCH NEXT FROM CUR_AAA
        INTO @curNumber
        
        --データの行数分ループ処理を実行する
        WHILE @@FETCH_STATUS = 0
        BEGIN
            --処理履歴データへ更新
            SET @KeyItem = @curNumber
                
            EXEC L_Log_Insert_SP
                @SYSDATETIME,
                @Operator,
                @PROGRAME_NAME,
                @PC,
                @OperateModeNm,
                @KeyItem


            --Table転送仕様Ｎ②
            INSERT INTO D_Warehousing
                (--WarehousingNO
                WarehousingDate
                ,SoukoCD
                ,RackNO
                ,StockNO
                ,JanCD
                ,AdminNO
                ,SKUCD
                ,WarehousingKBN
                ,DeleteFlg
                ,Number
                ,NumberRow
                ,VendorCD
                ,ToStoreCD
                ,ToSoukoCD
                ,ToRackNO
                ,ToStockNO
                ,FromStoreCD
                ,FromSoukoCD
                ,FromRackNO
                ,CustomerCD
                ,Quantity
                ,Program
                ,InsertOperator
                ,InsertDateTime
                ,UpdateOperator
                ,UpdateDateTime
                ,DeleteOperator
                ,DeleteDateTime)
            SELECT
                --WarehousingNO
                CONVERT(date, @SYSDATETIME) --WarehousingDate
                ,DS.SoukoCD
                ,DS.RackNO
                ,DS.StockNO
                ,SHD.JanCD
                ,SHD.AdminNO
                ,SHD.SKUCD
                ,5                          --WarehousingKBN 5：出荷売上
                ,1                          --DeleteFlg
                ,SHD.ShippingNO
                ,SHD.ShippingRows
                ,NULL                       --VendorCD
                ,NULL                       --ToStoreCD
                ,NULL                       --ToSoukoCD
                ,NULL                       --ToRackNO
                ,NULL                       --ToStockNO
                ,NULL                       --FromStoreCD
                ,NULL                       --FromSoukoCD
                ,NULL                       --FromRackNO
                ,SH.CustomerCD
                ,(-1) * SHD.ShippingSu      --Quantity
                ,@PROGRAME_NAME
                ,@Operator
                ,@SYSDATETIME
                ,@Operator
                ,@SYSDATETIME
                ,NULL                       --DeleteOperator
                ,NULL                       --DeleteDateTime
            FROM D_Sales AS SH

            INNER JOIN D_ShippingDetails AS SHD 
            ON SHD.ShippingNO = SH.ShippingNO
            AND SHD.DeleteDateTime IS NULL

            INNER JOIN D_InstructionDetails ID
            ON ID.InstructionNO = SHD.InstructionNO
            AND ID.InstructionRows = SHD.InstructionRows

            INNER JOIN D_Reserve AS R 
            ON R.ReserveNO = ID.ReserveNO
            AND R.DeleteDateTime IS NULL

            INNER JOIN D_Stock AS DS 
            ON DS.StockNO = R.StockNO
            AND DS.DeleteDateTime IS NULL

            WHERE SH.SalesNO = @curNumber
            AND SH.DeleteDateTime IS NULL
            ORDER BY SHD.ShippingNO, SHD.ShippingRows


            --Table転送仕様Ｂ②
            UPDATE D_Stock
            SET  StockSu = D_Stock.StockSu + R.ReserveSu
                ,ReserveSu = D_Stock.ReserveSu + R.ReserveSu
                ,ShippingSu = D_Stock.ShippingSu - R.ReserveSu
                ,UpdateOperator = @Operator
                ,UpdateDateTime = @SYSDATETIME
            FROM D_Sales AS SH

            INNER JOIN D_Shipping AS SHH
            ON SHH.ShippingNO = SH.ShippingNO
            AND SHH.DeleteDateTime IS NULL

            INNER JOIN D_InstructionDetails AS ID
            ON ID.InstructionNO = SHH.InstructionNO
            AND ID.DeleteDateTime IS NULL

            INNER JOIN D_Reserve AS R
            ON R.ReserveNO = ID.ReserveNO
            AND R.DeleteDateTime IS NULL

            WHERE D_Stock.StockNO = R.StockNO
            AND D_Stock.DeleteDateTime IS NULL
            AND SH.SalesNO = @curNumber
            AND SH.DeleteDateTime IS NULL


            --Table転送仕様Ａ②
            UPDATE D_Reserve
            SET  UpdateOperator = @Operator  
                ,UpdateDateTime = @SYSDATETIME
                ,ShippingSu = ShippingSu - ReserveSu
            FROM D_Sales AS SH

            INNER JOIN D_Shipping AS SHH
            ON SHH.ShippingNO = SH.ShippingNO
            AND SHH.DeleteDateTime IS NULL

            INNER JOIN D_InstructionDetails AS ID
            ON ID.InstructionNO = SHH.InstructionNO
            AND ID.DeleteDateTime IS NULL

            WHERE D_Reserve.ReserveNO = ID.ReserveNO
            AND D_Reserve.DeleteDateTime IS NULL
            AND SH.SalesNO = @curNumber
            AND SH.DeleteDateTime IS NULL


            --Table転送仕様Ｏ(売上履歴 -赤)
            INSERT INTO D_SalesTran
                (--DataNO IDENTITY
                 ProcessKBN
                ,RecoredKBN
                ,SalesNO
                ,StoreCD
                ,SalesDate
                ,ShippingNO
                ,CustomerCD
                ,CustomerName
                ,CustomerName2
                ,BillingType
                ,SalesHontaiGaku
                ,SalesHontaiGaku0
                ,SalesHontaiGaku8
                ,SalesHontaiGaku10
                ,SalesTax
                ,SalesTax8
                ,SalesTax10
                ,SalesGaku
                ,LastPoint
                ,WaitingPoint
                ,StaffCD
                ,PrintDate
                ,PrintStaffCD
                ,StoreSalesUpdateFLG
                ,StoreSalesUpdatetime
                ,Discount
                ,Discount8
                ,Discount10
                ,DiscountTax
                ,DiscountTax8
                ,DiscountTax10
                ,PurchaseAmount
                ,TaxAmount
                ,DiscountAmount
                ,BillingAmount
                ,PointAmount
                ,CardDenominationCD
                ,CardAmount
                ,CashAmount
                ,DepositAmount
                ,RefundAmount
                ,CreditAmount
                ,Denomination1CD
                ,Denomination1Amount
                ,Denomination2CD
                ,Denomination2Amount
                ,AdvanceAmount
                ,TotalAmount
                ,InsertOperator
                ,InsertDateTime)
            SELECT
                --DataNO IDENTITY
                 3 AS ProcessKBN
                ,1 AS RecoredKBN
                ,SH.SalesNO
                ,SH.StoreCD
                ,SH.SalesDate
                ,SH.ShippingNO
                ,SH.CustomerCD
                ,SH.CustomerName
                ,SH.CustomerName2
                ,SH.BillingType
                ,(-1) * SH.SalesHontaiGaku
                ,(-1) * SH.SalesHontaiGaku0
                ,(-1) * SH.SalesHontaiGaku8
                ,(-1) * SH.SalesHontaiGaku10
                ,(-1) * SH.SalesTax
                ,(-1) * SH.SalesTax8
                ,(-1) * SH.SalesTax10
                ,(-1) * SH.SalesGaku
                ,SH.LastPoint
                ,SH.WaitingPoint
                ,SH.StaffCD
                ,SH.PrintDate
                ,SH.PrintStaffCD
                ,9                              --StoreSalesUpdateFLG
                ,@SYSDATETIME                   --StoreSalesUpdatetime
                ,(-1) * SH.Discount
                ,(-1) * SH.Discount8
                ,(-1) * SH.Discount10
                ,(-1) * SH.DiscountTax
                ,(-1) * SH.DiscountTax8
                ,(-1) * SH.DiscountTax10
                ,(-1) * SH.SalesGaku            --PurchaseAmount
                ,(-1) * SH.SalesTax             --TaxAmount
                ,(-1) * SH.Discount             --DiscountAmount
                ,(-1) * SH.SalesGaku            --BillingAmount
                ,0                              --PointAmount
                ,NULL                           --CardDenominationCD
                ,0                              --CardAmount
                ,0                              --CashAmount
                ,0                              --DepositAmount
                ,0                              --RefundAmount
                ,0                              --CreditAmount
                ,NULL                           --Denomination1CD
                ,0                              --Denomination1Amount
                ,NULL                           --Denomination2CD
                ,0                              --Denomination2Amount
                ,0                              --AdvanceAmount
                ,0                              --TotalAmount
                ,@Operator                      --InsertOperator
                ,@SYSDATETIME                   --InsertDateTime
            FROM D_Sales AS SH
            WHERE SH.SalesNO = @curNumber
            AND SH.DeleteDateTime IS NULL


            --Table転送仕様Ｐ(売上明細履歴-赤)
            INSERT INTO D_SalesDetailsTran
                (DataNo
                ,DataRows
                ,ProcessKBN
                ,RecoredKBN
                ,SalesNO
                ,SalesRows
                ,JuchuuNO
                ,JuchuuRows
                ,ShippingNO
                ,SKUCD
                ,AdminNO
                ,JanCD
                ,SKUName
                ,ColorName
                ,SizeName
                ,SalesSU
                ,SalesUnitPrice
                ,TaniCD
                ,SalesHontaiGaku
                ,SalesTax
                ,SalesGaku
                ,SalesTaxRitsu
                ,ProperGaku
                ,DiscountGaku
                ,CommentOutStore
                ,CommentInStore
                ,IndividualClientName
                ,DeliveryNoteFLG
                ,BillingPrintFLG
                ,DeleteOperator
                ,DeleteDateTime
                ,InsertOperator
                ,InsertDateTime)
            SELECT
                SCOPE_IDENTITY()
                ,SD.SalesRows           --DataRows
                ,3                      --ProcessKBN
                ,1                      --RecoredKBN
                ,SD.SalesNO
                ,SD.SalesRows
                ,SD.JuchuuNO
                ,SD.JuchuuRows
                ,SD.ShippingNO
                ,SD.SKUCD
                ,SD.AdminNO
                ,SD.JanCD
                ,SD.SKUName
                ,SD.ColorName
                ,SD.SizeName
                ,(-1) * SD.SalesSU
                ,SD.SalesUnitPrice
                ,SD.TaniCD
                ,(-1) * SD.SalesHontaiGaku
                ,(-1) * SD.SalesTax
                ,(-1) * SD.SalesGaku
                ,SD.SalesTaxRitsu
                ,(-1) * SD.ProperGaku
                ,(-1) * SD.DiscountGaku
                ,SD.CommentOutStore
                ,SD.CommentInStore
                ,SD.IndividualClientName
                ,SD.DeliveryNoteFLG
                ,SD.BillingPrintFLG
                ,SD.DeleteOperator
                ,SD.DeleteDateTime
                ,@Operator
                ,@SYSDATETIME
            FROM D_SalesDetails AS SD
            WHERE SD.SalesNO = @curNumber
            AND SD.DeleteDateTime IS NULL    


            --Table転送仕様Ｍ②
            UPDATE D_JuchuuDetails
            SET  SalesDate = NULL
                ,SalesNO = NULL
                ,UpdateOperator = @Operator
                ,UpdateDateTime = @SYSDATETIME
            FROM D_SalesDetails AS SD
            WHERE D_JuchuuDetails.JuchuuNO = SD.JuchuuNO
            AND D_JuchuuDetails.JuchuuRows = SD.JuchuuRows
            AND D_JuchuuDetails.DeleteDateTime IS NULL
            AND SD.SalesNO = @curNumber
            AND SD.DeleteDateTime IS NULL

                
            --出荷指示明細
            DELETE FROM D_InstructionDetails
            WHERE EXISTS(SELECT 1
                FROM D_Sales AS SH
                INNER JOIN D_Shipping AS SHH ON SHH.ShippingNO = SH.ShippingNO AND SHH.DeleteDatetime IS NULL
                WHERE SH.SalesNO = @curNumber
                AND   SH.DeleteDateTime IS NULL
                AND   SHH.InstructionNO = D_InstructionDetails.InstructionNO
                )
                 
            --出荷指示
            DELETE FROM D_Instruction
            WHERE EXISTS(SELECT 1
                FROM D_Sales AS SH
                INNER JOIN D_Shipping AS SHH ON SHH.ShippingNO = SH.ShippingNO AND SHH.DeleteDatetime IS NULL
                WHERE SH.SalesNO = @curNumber
                AND   SH.DeleteDateTime IS NULL
                AND   SHH.InstructionNO = D_Instruction.InstructionNO
                )
                 
            --出荷明細
            DELETE FROM D_ShippingDetails
            WHERE EXISTS(SELECT 1
                FROM D_Sales AS SH
                WHERE SH.SalesNO = @curNumber
                AND   SH.DeleteDateTime IS NULL
                AND   SH.ShippingNO = D_ShippingDetails.ShippingNO
                )
                 
            --出荷
            DELETE FROM D_Shipping
            WHERE EXISTS(SELECT 1
                FROM D_Sales AS SH
                WHERE SH.SalesNO = @curNumber
                AND   SH.DeleteDateTime IS NULL
                AND   SH.ShippingNO = D_Shipping.ShippingNO
                )

            --回収予定明細
            DELETE FROM D_CollectPlanDetails
            WHERE SalesNO = @curNumber
            AND DeleteDateTime IS NULL

            --回収予定
            DELETE FROM D_CollectPlan
            WHERE SalesNO = @curNumber
            AND DeleteDateTime IS NULL
                 
            --請求
            DELETE BH
            FROM D_Billing AS BH
            INNER JOIN D_BillingDetails AS BD ON BD.BillingNO = BH.BillingNO AND BD.DeleteDateTime IS NULL
            WHERE BD.SalesNO = @curNumber
                
            --請求明細
            DELETE FROM D_BillingDetails
            WHERE SalesNO = @curNumber
            AND DeleteDateTime IS NULL

            --売上明細        
            DELETE FROM D_SalesDetails
            WHERE SalesNO = @curNumber
            AND DeleteDateTime IS NULL
                 
            --売上
            DELETE FROM D_Sales
            WHERE SalesNO = @curNumber
            AND DeleteDateTime IS NULL
                 

            FETCH NEXT FROM CUR_AAA
            INTO @curNumber

        END
        
        --カーソルを閉じる
        CLOSE CUR_AAA
        DEALLOCATE CUR_AAA
    END


    SET @OutSalesNO = @SalesNO
    
--<<OWARI>>
  return @W_ERR

END


