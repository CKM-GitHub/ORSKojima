 BEGIN TRY 
 Drop Function dbo.[Fnc_M_Souko_SelectLatest]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fnc_M_Souko_SelectLatest](  
    @ChangeDate varchar(10)  
)
RETURNS TABLE  
AS  
/*    
***************************************************************************************************    
**  機能：M_Soukoから最新のレコード取得
**    
**************************************************************************************************************************   
*/    
RETURN(
  SELECT main.SoukoCD
      ,CONVERT(varchar,main.ChangeDate,111) AS ChangeDate  
      ,main.SoukoName
      ,main.StoreCD
      ,main.HikiateOrder
      ,main.SoukoType
      ,main.UnitPriceCalcKBN
      ,main.MakerCD
      ,main.IdouCount
      ,main.StoreIdouCount
      ,main.ZipCD1
      ,main.ZipCD2
      ,main.Address1
      ,main.Address2
      ,main.TelephoneNO
      ,main.FaxNO
      ,main.Remarks
      ,main.DeleteFlg
      ,main.UsedFlg
      ,main.InsertOperator
      ,CONVERT(varchar,main.InsertDateTime) AS InsertDateTime  
      ,main.UpdateOperator
      ,CONVERT(varchar,main.UpdateDateTime) AS UpdateDateTime  
    FROM M_Souko main
    INNER JOIN (SELECT StoreCD,SoukoCD  
                      ,MAX(ChangeDate) AS ChangeDate      
                  FROM M_Souko   
                  WHERE ChangeDate <= CAST(@ChangeDate AS date)
                    AND DeleteFlg = 0
                  GROUP BY StoreCD,SoukoCD)  AS sub  
      ON  main.StoreCD = sub.StoreCD  
	  AND main.SoukoCD = sub.SoukoCD
      AND main.ChangeDate = sub.ChangeDate
    WHERE main.DeleteFlg = 0
  )   

