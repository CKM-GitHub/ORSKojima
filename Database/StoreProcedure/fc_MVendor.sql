 BEGIN TRY 
 Drop Function dbo.[fc_MVendor]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fc_MVendor]
    (        
       @p_KijunDate               DATE
    )

RETURNS @retMVendor TABLE
	(
		  [VendorCD]                                       [varchar] (13)                                                
		  ,[ChangeDate]                                           [date]
		  ,[VendorName]                                        [varchar] (50)                                                                                                
		  ,[VendorShortName]                                  [varchar] (20)                                            
		  ,[VendorLongName1]                                         [varchar] (80)                                            
		  ,[VendorLongName2]                                   [varchar] (80)                                            
		  ,[VendorPostName]                                    [varchar] (40)                                            												
		  ,[VendorPositionName]                                [varchar] (40)                                            
		  ,[VendorStaffName]                                   [varchar] (40)                                             
		  ,[VendorKana]                                        [varchar] (20)                                             
		  ,[VendorFlg]                                         [tinyint]                                            
		  ,[PayeeFlg]                                          [tinyint]                                             
		  ,[MoneyPayeeFlg]                                     [tinyint]                                                                                     
		  ,[PayeeCD]                                           [varchar] (13)                                            
		  ,[MoneyPayeeCD]                                      [varchar] (13) 										
	)
	
AS
/*
***************************************************************************************************
**  名称：fc_MVendor
**  機能：改定日直近の仕入先名取得
**  パラメータ        
**      @p_KijunDate               基準日
**
**************************************************************************************************************************
**  履歴
**  ----------------------------------------------------------------------------------------------------------------------
**  2020/07/17   Y.Nishikawa   
**  YYYY/MM/DD   Name          XXXXXXXXXX   改定内容の概要
**
**************************************************************************************************************************
*/
BEGIN
		INSERT INTO @retMVendor
		(
		[VendorCD]
      ,[ChangeDate]
      ,[VendorName]
      ,[VendorShortName]
      ,[VendorLongName1]
      ,[VendorLongName2]
      ,[VendorPostName]
      ,[VendorPositionName]
      ,[VendorStaffName]
      ,[VendorKana]
      ,[VendorFlg]
      ,[PayeeFlg]
      ,[MoneyPayeeFlg]
      ,[PayeeCD]
      ,[MoneyPayeeCD]
		)
		SELECT main.[VendorCD]
      ,main.[ChangeDate]
      ,main.[VendorName]
      ,main.[VendorShortName]
      ,main.[VendorLongName1]
      ,main.[VendorLongName2]
      ,main.[VendorPostName]
      ,main.[VendorPositionName]
      ,main.[VendorStaffName]
      ,main.[VendorKana]
      ,main.[VendorFlg]
      ,main.[PayeeFlg]
      ,main.[MoneyPayeeFlg]
      ,main.[PayeeCD]
      ,main.[MoneyPayeeCD]
  FROM [dbo].[M_Vendor] main
		  INNER JOIN (SELECT VendorCD
                           , MAX(ChangeDate) AS ChangeDate	
		              FROM M_Vendor 
		              WHERE  ChangeDate <= @p_KijunDate
		              GROUP BY VendorCD)  AS sub
		  ON  main.VendorCD = sub.VendorCD
		  AND main.ChangeDate = sub.ChangeDate
    
    RETURN
END




