 BEGIN TRY 
 Drop Procedure dbo.[M_StorePoint_ExpirationDate]
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
CREATE PROCEDURE [dbo].[M_StorePoint_ExpirationDate]
	-- Add the parameters for the stored procedure here
	@StoreCD varchar(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here

		select ExpirationDate
		
		from F_StorePoint(GETDATE()) as msp
		where msp.StoreCD=@StoreCD
		and DeleteFlg=0
END


