BEGIN TRY 
 Drop Procedure [dbo].[M_Customer_Select]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [M_Customer_Select]    */
CREATE PROCEDURE [dbo].[M_Customer_Select](
    -- Add the parameters for the stored procedure here
    @CustomerCD  varchar(13),
    @ChangeDate varchar(10)
)AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
     SELECT top 1 fc.[CustomerCD]
          ,CONVERT(varchar, fc.ChangeDate,111) AS ChangeDate
          ,fc.[CustomerName]
          ,fc.[VariousFLG]
          ,fc.[LastName]
          ,fc.[FirstName]
          ,fc.[LongName1]
          ,fc.[LongName2]
          ,fc.[KanaName]
          ,fc.[StoreKBN]
          ,fc.[CustomerKBN]
          ,fc.[StoreTankaKBN]
          ,fc.[AliasKBN]
          ,fc.[BillingType]
          ,fc.[GroupName]
          ,fc.[BillingFLG]
          ,fc.[CollectFLG]
          ,fc.[BillingCD]
          ,fc.[CollectCD]
          ,CONVERT(varchar, fc.Birthdate,111) AS Birthdate
          ,fc.[Sex]
          ,fc.[Tel11]
          ,fc.[Tel12]
          ,fc.[Tel13]
          ,fc.[Tel21]
          ,fc.[Tel22]
          ,fc.[Tel23]
          ,fc.[ZipCD1]
          ,fc.[ZipCD2]
          ,fc.[Address1]
          ,fc.[Address2]
          ,fc.[MailAddress]
          ,fc.[TankaCD]
          ,fc.[PointFLG]
          ,fc.[LastPoint]
          ,fc.[WaitingPoint]
          ,fc.[TotalPoint]
          ,fc.[TotalPurchase]
          ,fc.[UnpaidAmount]
          ,fc.[UnpaidCount]
          ,CONVERT(varchar,fc.[LastSalesDate],111) AS LastSalesDate
		  ,fc.[LastSalesStoreCD]
          ,fs.[StoreName]
          ,fc.[MainStoreCD]
          ,fc.[StaffCD]
          ,fc.[AttentionFLG]
          ,fc.[ConfirmFLG]
          ,fc.[ConfirmComment]
          ,fc.[BillingCloseDate]
          ,fc.[CollectPlanMonth]
          ,fc.[CollectPlanDate]
          ,fc.[HolidayKBN]
          ,fc.[TaxTiming]
          ,fc.[TaxFractionKBN]
          ,fc.[AmountFractionKBN]
          ,fc.[CreditLevel]
          ,fc.[CreditCard]
          ,fc.[CreditInsurance]
          ,fc.[CreditDeposit]
          ,fc.[CreditETC]
          ,fc.[CreditAmount]
          --,[CreditWarningAmount]
          ,fc.[CreditAdditionAmount]
		  ,fc.[CreditCheckKBN]
		  ,fc.[CreditMessage]
		  ,CONVERT(varchar,FORMAT(CONVERT(int,fc.[FareLevel]), 'N0')) AS [FareLevel]
		  ,CONVERT(varchar,FORMAT(convert(int,fc.[Fare]), 'N0')) AS [Fare]
          ,fc.[PaymentMethodCD]
          ,fc.[KouzaCD]
          ,fc.[DisplayOrder]
          ,fc.[PaymentUnit]
          ,fc.[NoInvoiceFlg]
          ,fc.[CountryKBN]
          ,fc.[CountryName]
          ,fc.[RegisteredNumber]
          ,fc.[DMFlg]
          ,fc.[RemarksOutStore]
          ,fc.[RemarksInStore]
          ,fc.[AnalyzeCD1]
          ,fc.[AnalyzeCD2]
          ,fc.[AnalyzeCD3]
	      ,fc.[DeleteFlg]
          ,fc.[UsedFlg]
        ,fc.[InsertOperator]
        ,CONVERT(varchar,fc.[InsertDateTime]) AS InsertDateTime
        ,fc.[UpdateOperator]
        ,CONVERT(varchar,fc.[UpdateDateTime]) AS UpdateDateTime
    FROM F_Customer(@ChangeDate) as fc
	Left Join F_Store(getdate()) as fs on fs.StoreCD=fc.LastSalesStoreCD and fs.ChangeDate<=fc.ChangeDate
    WHERE [CustomerCD] = @CustomerCD
    --AND [ChangeDate] <= CONVERT(DATE, @ChangeDate)
    ORDER BY ChangeDate desc
    ;
END


GO
