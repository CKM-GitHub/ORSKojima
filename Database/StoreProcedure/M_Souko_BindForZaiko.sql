BEGIN TRY 
 Drop Procedure dbo.[M_Souko_BindForZaiko]
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
CREATE PROCEDURE [dbo].[M_Souko_BindForZaiko] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select SoukoCD,SoukoName
	From F_Souko(GETDATE()) ms
	Where DeleteFlg=0
	AND ms.SoukoType IN (3,4)
	Order by StoreCD,SoukoCD
END
GO
