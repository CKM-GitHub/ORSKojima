BEGIN TRY 
	Drop Procedure dbo.[PRC_ExhibitInformation_Delete]
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
CREATE PROCEDURE [dbo].[PRC_ExhibitInformation_Delete]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		BEGIN TRANSACTION
			
			DELETE D_ShoppingCart;

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		declare @ErrorNumber INT = ERROR_NUMBER();
		declare @ErrorLine INT = ERROR_LINE();
		declare @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		declare @ErrorSeverity INT = ERROR_SEVERITY();
		declare @ErrorState INT = ERROR_STATE();

		IF @@TRANCOUNT > 0
          rollback transaction;

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END


