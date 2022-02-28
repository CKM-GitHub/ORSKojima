BEGIN TRY 
 Drop Procedure dbo.[D_SelectData_ForTempoRegiRyousyuusyo]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[D_SelectData_ForTempoRegiRyousyuusyo]
    (
     @SalesNO varchar(11),
     @PrintDate varchar(10)
    )AS
    
--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    SELECT sales.SalesNO
          ,CASE
             WHEN @PrintDate IS NULL THEN sales.InsertDateTime
             ELSE @PrintDate
           END AS UriageDateTime
          ,NULL AS AiteName
          ,CAST(FLOOR(sales.SalesGaku) AS decimal) SalesGaku
          --,CAST(FLOOR(sales.SalesTax) AS decimal) SalesTax
		  ,'(うち消費税'+'  '+'\'+Cast(CAST(FLOOR(sales.SalesTax) AS decimal)as varchar)+')' SalesTax
          ,fs.Print7
          ,fs.Print8
		  ,fs.ReceiptPrint + '-' + mstaff.ReceiptPrint as ReceiptPrint
          ,multiPorpose.Char1
          ,multiPorpose.Char2
          ,ctrl.MainKey
          ,sales.StoreCD
          ,fs.ChangeDate
          ,sales.SalesDate
       FROM D_Sales sales
      LEFT OUTER JOIN M_Control ctrl ON ctrl.MainKey = 1
	  LEFT OUTER JOIN F_Store(GETDATE()) fs on fs.StoreCD=sales.StoreCD 
	  LEFT OUTER JOIN F_Staff(Getdate()) mstaff ON mstaff.StaffCD=sales.StaffCD
      LEFT OUTER JOIN M_multiPorpose multiPorpose 
      ON multiPorpose.ID = 305
      AND multiPorpose.[Key] = fs.StoreCD
      WHERE sales.DeleteDateTime IS NULL
        AND sales.SalesNo = @SalesNO
        ;
END
