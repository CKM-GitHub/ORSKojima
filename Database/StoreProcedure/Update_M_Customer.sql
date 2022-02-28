BEGIN TRY 
 Drop Procedure dbo.[Update_M_Customer]
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
CREATE PROCEDURE [dbo].[Update_M_Customer]
@updateXml as xml
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @hQuantityAdjust AS INT 
	CREATE TABLE #Temp_Main
                (   
                  CustomerCD  varchar(13),
                  LastPoint money,
                  TotalPoint money,
                  LastSalesDate varchar(10)
                )
            EXEC sp_xml_preparedocument @hQuantityAdjust OUTPUT, @updateXml
     INSERT INTO #Temp_Main
                 (CustomerCD
                  ,LastPoint
				  ,TotalPoint
				  ,LastSalesDate
				  )

				  SELECT *
                    FROM OPENXML(@hQuantityAdjust, 'NewDataSet/test')
                    WITH
                    (
                    CustomerCD  varchar(13) 'CustomerCD',
                    LastPoint money 'Lastpoint',
                    TotalPoint money 'TotalPoint',
                    LastSalesDate varchar(10) 'LastSalesDate'
                    )
        EXEC SP_XML_REMOVEDOCUMENT @hQuantityAdjust

   Update mc
   SET LastPoint = TM.LastPoint,
   TotalPoint = TM.TotalPoint,
   LastSalesDate=TM.LastSalesDate
   FROM #Temp_Main TM
   inner join M_Customer mc on mc.CustomerCD=TM.CustomerCD
   where TM.LastSalesDate <> '00000000'
   AND TM.LastPoint <> '0.00'
   AND TM.TotalPoint <> '0.00'

DROP Table #Temp_Main
 
END
