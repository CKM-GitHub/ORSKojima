IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'M_StorePoint_SelectForTempRegiPoint')
  DROP PROCEDURE [dbo].[M_StorePoint_SelectForTempRegiPoint]
GO

--  ======================================================================
--       Program Call    店舗レジ ポイント引換券印刷
--       Program ID      TempoRegiPoint
--    ======================================================================
CREATE PROCEDURE [dbo].[M_StorePoint_SelectForTempRegiPoint]
(
     @StoreCD varchar(4)
)AS
BEGIN
    SET NOCOUNT ON;

    SELECT ExpirationDate
      FROM (SELECT ROW_NUMBER() OVER(PARTITION BY StoreCD ORDER BY ChangeDate DESC) RANK
                  ,ExpirationDate
              FROM M_StorePoint
             WHERE StoreCD = @StoreCD
               AND ChangeDate <= CONVERT (date, GETDATE())
               AND DeleteFlg = 0) storePoint
     WHERE storePoint.RANK = 1
         ;
END
