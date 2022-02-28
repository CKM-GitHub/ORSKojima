BEGIN TRY 
    Drop Procedure dbo.[M_Customer_SelectForTenzikai]
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
Create PROCEDURE [dbo].[M_Customer_SelectForTenzikai]
	-- Add the parameters for the stored procedure here
	@CustomerCD  varchar(13),
    @ChangeDate varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * 
	From M_Customer
	Where CustomerCD = @CustomerCD 
	and ChangeDate <= @ChangeDate
	and DeleteFLG =	0

END
GO


