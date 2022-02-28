 BEGIN TRY 
 Drop Procedure dbo.[M_Souko_BindForStoreMainSouko] 
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
CREATE PROCEDURE [dbo].[M_Souko_BindForStoreMainSouko] 
    @StoreCD varchar(4),
    @ChangeDate as date
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ms.SoukoCD, ms.SoukoName 

    FROM F_Souko(cast(@ChangeDate AS varchar(10))) ms 

    WHERE ms.DeleteFlg = 0 
    AND ms.SoukoType = 3
    AND (@StoreCD is NULL OR ms.StoreCD = @StoreCD)

    ORDER BY ms.SoukoCD
END
GO
