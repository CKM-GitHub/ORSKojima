 BEGIN TRY 
 Drop Function dbo.[Fnc_M_SalesTax_SelectLatest]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[Fnc_M_SalesTax_SelectLatest](      
    @ChangeDate varchar(10)      
)    
RETURNS TABLE      
AS      
/*        
***************************************************************************************************        
**  讖溯・・哺_SalesTax縺九ｉ譛譁ｰ縺ｮ繝ｬ繧ｳ繝ｼ繝牙叙蠕・   
**        
**************************************************************************************************************************       
*/        
RETURN(   
    SELECT TOP 1  
           main.ChangeDate  
          ,main.TaxRate1  
          ,main.TaxRate2  
          ,main.FractionKBN  
    FROM M_SalesTax main    
    WHERE main.ChangeDate <= CAST(@ChangeDate AS date)    
    ORDER BY main.ChangeDate DESC  
  )       
  
  
  

