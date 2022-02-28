BEGIN TRY 
 Drop Procedure D_SelectData_ForTempoRegiRyousyuusyo2
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[D_SelectData_ForTempoRegiRyousyuusyo2]
@PrintDate varchar(10),
@SalesGaku  as money,
@StaffCD as varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;  

	Select
          NULL as SalesNO,
             CASE
             WHEN @PrintDate IS NULL THEN GETDATE()
             ELSE @PrintDate
           END AS UriageDateTime,
		   NULL AS AiteName,
           @SalesGaku as SalesGaku,
		   NULL AS SalesTax,
           store.Print7,
           store.Print8,
		   store.ReceiptPrint + '-' + staff.ReceiptPrint as ReceiptPrint,
		   multiPorpose.Char1,
           multiPorpose.Char2,
		   ctrl.MainKey,
           staff.StoreCD,
           store.ChangeDate,
           NULL AS SalesDate
		   
	FROM F_Staff(GETDATE()) staff
	LEFT OUTER JOIN F_Store(GETDATE()) store ON store.StoreCD=staff.StoreCD
	LEFT OUTER JOIN M_Control ctrl ON ctrl.MainKey = 1
	LEFT OUTER JOIN M_multiPorpose multiPorpose 
      ON multiPorpose.ID = 305
	  AND multiPorpose.[Key]=store.StoreCD
    WHERE staff.StaffCD=@StaffCD
END
