BEGIN TRY 
 Drop Procedure dbo.[CheckBillingDateForTempoUriage]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE CheckBillingDateForTempoUriage
    (@StoreCD varchar(4),
     @CustomerCD varchar(13),
     @BillingDate varchar(10)
    )AS
    
--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    --締処理済チェック D_BillingProcessing 下記のSelectができたらエラー）
    --その店舗、請求先でその売上日を含む期間ですでに請求処理が済んでいる

    SELECT Bil.ProcessingNO
    FROM D_BillingProcessing Bil
    INNER JOIN 
    (
        SELECT BillingCD
        FROM   F_Customer(convert(datetime,@BillingDate))
        WHERE  customerCD = @CustomerCD
    ) Cus 
    ON  Cus.BillingCD = Bil.CustomerCD

    WHERE Bil.StoreCD = @StoreCD
    AND Bil.ProcessingKBN IN (1, 3)
    AND Bil.BillingDate >= CONVERT(date,@BillingDate)
    AND Bil.DeleteDateTime IS NULL

    UNION


    SELECT Bil.ProcessingNO
    FROM   D_BillingPRocessing Bil
    WHERE  Bil.StoreCD = @StoreCD
    AND    Bil.CustomerCD IS NULL
    AND    Bil.BillingDate >= CONVERT(date,@BillingDate)
    AND    Bil.ProcessingKBN IN (1, 3)





    ;

END

