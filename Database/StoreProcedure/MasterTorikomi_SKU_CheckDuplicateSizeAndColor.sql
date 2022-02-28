 BEGIN TRY 
 DROP PROCEDURE [dbo].[MasterTorikomi_SKU_CheckDuplicateSizeAndColor]
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
CREATE PROCEDURE [dbo].[MasterTorikomi_SKU_CheckDuplicateSizeAndColor]
    @AdminNO    int,
    @ITemCD     varchar(30),
    @SizeNO     int,
    @ColorNO    int,
    @ChangeDate date
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 1 FROM M_SKU
    WHERE ITemCD = @ITemCD
    AND SizeNO = @SizeNO
    AND ColorNO = @ColorNO
    AND ChangeDate = @ChangeDate
    AND AdminNO <> @AdminNO

END