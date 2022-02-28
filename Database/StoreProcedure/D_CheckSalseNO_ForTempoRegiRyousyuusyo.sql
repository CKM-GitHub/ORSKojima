BEGIN TRY 
    Drop Procedure dbo.[D_CheckSalseNO_ForTempoRegiRyousyuusyo]
END TRY
BEGIN CATCH END CATCH

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[D_CheckSalseNO_ForTempoRegiRyousyuusyo]
    (
     @SalesNO varchar(11)
    )AS
    
--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(sales.SalesNo) SalesNoCount
      FROM D_Sales sales
     WHERE sales.SalesNo = @SalesNO
         ;
END
GO

