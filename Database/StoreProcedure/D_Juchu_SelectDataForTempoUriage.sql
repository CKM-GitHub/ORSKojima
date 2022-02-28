BEGIN TRY 
 Drop Procedure dbo.[D_Juchu_SelectDataForTempoUriage]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [D_Juchu_SelectDataForTempoUriage]    */
CREATE PROCEDURE [dbo].[D_Juchu_SelectDataForTempoUriage](
    -- Add the parameters for the stored procedure here
    @OperateMode    tinyint,                 -- 処理区分（1:新規 2:修正 3:削除）
    @DateFrom  varchar(10),
    @DateTo  varchar(10),
    @CustomerCD  varchar(13),
    @CustomerName  varchar(80),
    @KanaName varchar(30) ,
    @StoreCD  varchar(4),
    @StaffCD varchar(30)
)AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @Today date = CAST(GETDATE() as date)
    
    IF @OperateMode = 1
    BEGIN
        --画面転送表01
        SELECT DH.JuchuuNO
              , DM.JuchuuRows
              ,CONVERT(varchar,DH.JuchuuDate,111) AS JuchuuDate
              ,DH.CustomerCD
              ,CASE MC.VariousFLG WHEN 1 THEN DH.CustomerName ELSE MC.CustomerName END CustomerName
              ,CASE MC.VariousFLG WHEN 1 THEN DH.CustomerName2 ELSE MC.KanaName END CustomerName2
              ,DM.JanCD
              ,DM.SKUName
              ,DM.ColorName
              ,DM.SizeName
			  ,DM.CommentOutStore
              ,NULL AS SalesNO
              ,NULL As SalesRows
              ,NULL AS SalesDate
              ,DM.ColorName
              ,DM.SizeName
              ,DM.JuchuuSuu
              ,DM.JuchuuSuu AS SalesSu
              ,(SELECT A.Char1 FROM M_MultiPorpose A WHERE A.ID='201' AND A.[Key] = DM.TaniCD) AS TaniName
              ,DM.JuchuuUnitPrice AS UnitPrice
              ,DM.JuchuuGaku AS Kingaku
              ,NULL AS BillingNO

        from D_Juchuu AS DH

        LEFT OUTER JOIN D_JuchuuDetails AS DM 
        ON  DM.JuchuuNO = DH.JuchuuNO
        AND DM.DeleteDateTime IS NULL

        CROSS APPLY(
            SELECT SUM(ReserveSu) AS ReserveSu
            FROM D_Reserve R
            WHERE R.Number = DM.JuchuuNO  
            AND R.NumberRows = DM.JuchuuRows
            AND R.ReserveKBN = 1
            AND R.DeleteDateTime IS Null
            AND R.ShippingSu = 0
			AND R.ShippingPossibleDate IS NOT NULL
			AND R.ShippingPossibleDate <= @Today
        ) DR

        OUTER APPLY(
            SELECT top 1 A.VariousFLG, A.CustomerName, A.KanaName
            FROM M_Customer A 
            WHERE A.CustomerCD = DH.CustomerCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.JuchuuDate
            ORDER BY A.ChangeDate desc
        ) MC 

        WHERE DH.JuchuuDate >= (CASE WHEN @DateFrom <> '' THEN CONVERT(DATE, @DateFrom) ELSE DH.JuchuuDate END)
            AND DH.JuchuuDate <= (CASE WHEN @DateTo <> '' THEN CONVERT(DATE, @DateTo) ELSE DH.JuchuuDate END)
            AND DH.CustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DH.CustomerCD END)
            AND DH.StoreCD = @StoreCD
            AND DH.StaffCD = (CASE WHEN @StaffCD <> '' THEN @StaffCD ELSE DH.StaffCD END)
            AND MC.CustomerName LIKE '%' + (CASE WHEN @CustomerName <> '' THEN @CustomerName ELSE MC.CustomerName END) + '%'
            AND DH.DeleteDateTime IS NULL
            AND DM.JuchuuSuu = DR.ReserveSu     --HikiateSu

        ORDER BY DH.JuchuuNO, DM.JuchuuRows
        ;
    END
    ELSE
    BEGIN
        --画面転送表02
        SELECT DJ.JuchuuNO AS JuchuuNO
              ,NULL AS JuchuuRows
              ,DJ.JuchuuDate AS JuchuuDate
              ,DH.CustomerCD
              ,DH.CustomerName
              ,DH.CustomerName2
              ,DM.JanCD
              ,DM.SKUName
              ,DM.ColorName
              ,DM.SizeName
			  ,DM.CommentOutStore
              ,DH.SalesNO
              ,DM.SalesRows
              ,CONVERT(varchar,DH.SalesDate,111) AS SalesDate
              ,DM.ColorName
              ,DM.SizeName
              ,DM.SalesSu AS JuchuuSuu
              ,DM.SalesSu
              ,(SELECT A.Char1 FROM M_MultiPorpose A WHERE A.ID='201' AND A.[Key] = DM.TaniCD) AS TaniName
              ,DM.SalesUnitPrice AS UnitPrice
              ,DM.SalesGaku AS Kingaku
              ,DC.BillingNO

        from D_Sales AS DH

        LEFT OUTER JOIN D_SalesDetails AS DM 
        ON  DM.SalesNO = DH.SalesNO
        AND DM.DeleteDateTime IS NULL
        
        LEFT OUTER JOIN D_CollectPlanDetails AS DCD 
        ON DCD.SalesNO = DM.SalesNO  
        AND DCD.SalesRows = DM.SalesRows
        AND DCD.DeleteDateTime IS Null
        
        LEFT OUTER JOIN D_CollectPlan AS DC
        ON DC.CollectPlanNO = DCD.CollectPlanNO  
        AND DC.DeleteDateTime IS Null
        
        LEFT OUTER JOIN D_BillingDetails AS DBD
        ON DBD.CollectPlanNO = DCD.CollectPlanNO  
        AND DBD.CollectPlanRows = DCD.CollectPlanRows  
        AND DBD.DeleteDateTime IS Null            
        
        LEFT OUTER JOIN D_Billing AS DB
        ON DB.BillingNO = DBD.BillingNO  
        AND DB.DeleteDateTime IS Null             
                    
        LEFT OUTER JOIN D_BillingControl AS DBC
        ON DBC.ProcessingNO = DB.ProcessingNO
        AND DBC.DeleteDateTime IS Null  
           
		LEFT OUTER JOIN D_Juchuu AS DJ
        ON DJ.JuchuuNO = DM.JuchuuNO

        OUTER APPLY(
            SELECT top 1 A.VariousFLG, A.CustomerName, A.KanaName
            FROM M_Customer A 
            WHERE A.CustomerCD = DH.CustomerCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.SalesDate
            ORDER BY A.ChangeDate desc
        ) MC 
           
        WHERE DH.SalesDate >= (CASE WHEN @DateFrom <> '' THEN CONVERT(DATE, @DateFrom) ELSE DH.SalesDate END)
            AND DH.SalesDate <= (CASE WHEN @DateTo <> '' THEN CONVERT(DATE, @DateTo) ELSE DH.SalesDate END)
            AND DH.CustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DH.CustomerCD END)
            AND DH.StoreCD = @StoreCD
            AND DH.StaffCD = (CASE WHEN @StaffCD <> '' THEN @StaffCD ELSE DH.StaffCD END)
            AND MC.CustomerName LIKE '%' + (CASE WHEN @CustomerName <> '' THEN @CustomerName ELSE MC.CustomerName END) + '%'            
            AND DH.DeleteDateTime IS NULL
            AND DH.SalesEntryKBN = 3
            AND DC.PaymentProgressKBN = 0
            AND ISNULL(DBC.ProcessingKBN,0) <> 3

        ORDER BY DH.SalesNO, DM.SalesRows
        ;

    END
END
