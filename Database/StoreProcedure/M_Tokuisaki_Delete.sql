BEGIN TRY 
	Drop Procedure dbo.[M_Tokuisaki_Delete]
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
CREATE PROCEDURE [dbo].[M_Tokuisaki_Delete] 
	-- Add the parameters for the stored procedure here
	@TokuisakiCD as varchar(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
	DELETE FROM M_Tokuisaki
	WHERE TokuisakiCD = @TokuisakiCD
			
	
END

