BEGIN TRY 
    Drop Procedure dbo.[M_Bank_ChangeDate_Select]
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
CREATE PROCEDURE [dbo].[M_Bank_ChangeDate_Select]
	-- Add the parameters for the stored procedure here
	@ChangeDate as date,
	@BankCD as varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select fb.ChangeDate
		from  F_Bank(cast(@ChangeDate as varchar(10))) fb
		where fb.BankCD=@BankCD 
		and fb.ChangeDate <= @ChangeDate
END
GO


