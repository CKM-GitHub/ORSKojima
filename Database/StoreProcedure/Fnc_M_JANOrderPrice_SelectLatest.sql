 BEGIN TRY 
 Drop Function dbo.[Fnc_M_JANOrderPrice_SelectLatest]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE FUNCTION [dbo].[Fnc_M_JANOrderPrice_SelectLatest](    
    @ChangeDate varchar(10)    
)  
RETURNS TABLE    
AS    
/*      
***************************************************************************************************      
**  機能：M_JANOrderPriceから最新のレコード取得  
**      
**************************************************************************************************************************     
*/      
RETURN( 
    SELECT main.VendorCD
          ,main.StoreCD
          ,main.AdminNO
          ,CONVERT(varchar,main.ChangeDate,111) AS ChangeDate    
          ,main.SKUCD
          ,main.Rate
          ,main.PriceWithoutTax
          ,main.Remarks
          ,main.DeleteFlg
          ,main.UsedFlg
          ,main.InsertOperator
          ,CONVERT(varchar,main.InsertDateTime) AS InsertDateTime    
          ,main.UpdateOperator
          ,CONVERT(varchar,main.UpdateDateTime) AS UpdateDateTime    
    FROM M_JANOrderPrice main  
    INNER JOIN (SELECT VendorCD
                      ,StoreCD
                      ,AdminNO
                      ,MAX(ChangeDate) AS ChangeDate        
                  FROM M_JANOrderPrice     
                  WHERE ChangeDate <= CAST(@ChangeDate AS date)  
                    AND DeleteFlg = 0  
                  GROUP BY VendorCD, StoreCD, AdminNO)  AS sub    
      ON  main.VendorCD = sub.VendorCD    
      AND main.StoreCD = sub.StoreCD 
      AND main.AdminNO = sub.AdminNO 
      AND main.ChangeDate = sub.ChangeDate  
    WHERE main.DeleteFlg = 0  
  )     




