BEGIN TRY 
    Drop Procedure dbo.[D_Juchuu_SelectForWebHikiate]
END TRY
BEGIN CATCH END CATCH

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--  ======================================================================
--       Program Call    WEB受注確認 引当画面
--       Program ID      WebJuchuuKakunin
--       Create date:    2021.06.10
--    ======================================================================
CREATE PROCEDURE [dbo].[D_Juchuu_SelectForWebHikiate]
    (    @JuchuuNO     varchar(11),
         @ChangeDate   varchar(10)
    )AS
    
--********************************************--
--                                            --
--                 処理開始・                 --
--                                            --
--********************************************--

BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT DH.OrderCD AS VendorCD
          ,(SELECT FV.VendorName
              FROM F_Vendor(@ChangeDate) AS FV
             WHERE FV.VendorCD = DH.OrderCD
               AND FV.DeleteFlg = 0) AS VendorName 
          ,DO.OrderNO
          ,CONVERT(varchar,DO.ArrivePlanDate,111) AS ArrivePlanDate
          ,DO.SoukoCD
          ,(SELECT M.SoukoName
              FROM F_Souko(@ChangeDate) AS M
             WHERE M.SoukoCD = DO.SoukoCD
               AND M.DeleteFlg = 0) AS SoukoName 
--          ,(CASE WHEN DO.DirectFLG = 1 THEN '〇' ELSE '' END) AS DirectFLG

      FROM D_JuchuuDetails AS DM
      LEFT OUTER JOIN D_OrderDetails AS DO
      ON DO.JuchuuNO = DM.JuchuuNO
      AND DO.JuchuuRows = DM.JuchuuRows
      AND DO.DeleteDateTime IS Null
      LEFT OUTER JOIN D_Order AS DH
      ON DH.OrderNO = DO.OrderNO
      AND DH.DeleteDateTime IS Null
      WHERE DM.JuchuuNO = @JuchuuNO               
      AND DM.DeleteDateTime IS Null
      ORDER BY DM.DisplayRows
      ;
END

GO


