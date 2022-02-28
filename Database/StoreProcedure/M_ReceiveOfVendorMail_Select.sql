BEGIN TRY 
    Drop Procedure dbo.[M_ReceiveOfVendorMail_Select]
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
Create PROCEDURE [dbo].[M_ReceiveOfVendorMail_Select] 
	-- Add the parameters for the stored procedure here
	@AddressFrom varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	from M_ReceiveOfVendorMail
	where [Address]=@AddressFrom
END
GO


