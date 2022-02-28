 BEGIN TRY 
 Drop Procedure dbo.[M_SKU_SelectForSKUCheck]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[M_SKU_SelectForSKUCheck]
	-- Add the parameters for the stored procedure here
		
		@ExhibitionCommomCD as varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SELECT	*																	
		FROM F_SKU(getdate()) 																		
		WHERE DeleteFlg	=	0							
		AND		ExhibitionCommonCD=	@ExhibitionCommomCD					

END
