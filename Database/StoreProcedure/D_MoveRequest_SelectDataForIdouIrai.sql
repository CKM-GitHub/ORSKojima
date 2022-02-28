BEGIN TRY 
    Drop Procedure dbo.[D_MoveRequest_SelectDataForIdouIrai]
END TRY
BEGIN CATCH END CATCH

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--  ======================================================================
--       Program Call    在庫移動依頼入力
--       Program ID      ZaikoIdouIraiNyuuryoku
--       Create date:    2019.12.11
--    ======================================================================
CREATE PROCEDURE [dbo].[D_MoveRequest_SelectDataForIdouIrai]
    (@RequestNO varchar(11)
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

--        IF @OperateMode = 2   --修正時
--        BEGIN
    SELECT DH.RequestNO
          ,DH.StoreCD
          ,CONVERT(varchar,DH.RequestDate,111) AS RequestDate
          ,DH.MovePurposeKBN
          ,DH.FromStoreCD
          ,DH.FromSoukoCD
          ,DH.ToStoreCD
          ,DH.ToSoukoCD
          ,DH.StaffCD
          ,DH.AnswerDateTime
          ,DH.AnswerStaffCD
          ,DH.InsertOperator
          ,CONVERT(varchar,DH.InsertDateTime) AS InsertDateTime
          ,DH.UpdateOperator
          ,CONVERT(varchar,DH.UpdateDateTime) AS UpdateDateTime
          ,DH.DeleteOperator
          ,CONVERT(varchar,DH.DeleteDateTime) AS DeleteDateTime
                  
          ,DM.RequestRows
          ,DM.SKUCD
          ,DM.AdminNO
          ,DM.JanCD
          ,(SELECT top 1 M.SKUName 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.RequestDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS SKUName
          ,(SELECT top 1 M.ColorName 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.RequestDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS ColorName
          ,(SELECT top 1 M.SizeName 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.RequestDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS SizeName
          
          ,DM.RequestSu
          ,CONVERT(varchar,DM.ExpectedDate,111) AS ExpectedDate
          ,DM.CommentInStore

      FROM D_MoveRequest DH
      LEFT OUTER JOIN D_MoveRequestDetailes AS DM 
      ON DH.RequestNO = DM.RequestNO 
      AND DM.DeleteDateTime IS NULL                     
      
      WHERE DH.RequestNO = @RequestNO           
      AND DH.DeleteDateTime IS Null
      ORDER BY DM.RequestRows
      ;
      
END

GO


