 BEGIN TRY 
 DROP PROCEDURE [dbo].[MasterTorikomi_SKU_CheckSKUExists]
END TRY
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MasterTorikomi_SKU_CheckSKUExists]
    @AdminNO    int,
    @SKUCD      varchar(30),
    @ChangeDate date
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 1 FROM M_SKU
    WHERE AdminNO = @AdminNO
    AND SKUCD = @SKUCD
    AND ChangeDate = @ChangeDate

END