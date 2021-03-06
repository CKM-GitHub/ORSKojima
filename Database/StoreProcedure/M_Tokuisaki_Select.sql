BEGIN TRY 
	Drop Procedure dbo.[M_Tokuisaki_Select]
END TRY
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
CREATE PROCEDURE [dbo].[M_Tokuisaki_Select] 
	-- Add the parameters for the stored procedure here
	@TokuisakiCD nvarchar(5)
	
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		  Main.TokuisakiCD
		, Main.TokuisakiName
		, Main.ExportName
		, Main.TitleUmuKBN
		, Main.OyaTokuisakiCD
		, Main.Yobi1
		, main.Yobi2
		, Main.Yobi3
		, Main.Yobi4
		, Main.Yobi5
		, Main.Yobi6
		, Main.Yobi7
		, Main.Yobi8
		, Main.Yobi9

	From M_Tokuisaki Main
	Where (@TokuisakiCD is null or(main.TokuisakiCD = @TokuisakiCD))
	;

END



