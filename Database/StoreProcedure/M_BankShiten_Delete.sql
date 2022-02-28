 BEGIN TRY 
 Drop Procedure dbo.[M_BankShiten_Delete]
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
CREATE PROCEDURE [dbo].[M_BankShiten_Delete]
	-- Add the parameters for the stored procedure here
	@BankCD as varchar(4),
	@BranchCD as varchar(3),
	@ChangeDate date,
	@Operator varchar(10),
	@Program as varchar(30),
	@PC as varchar(30),
	@OperateMode as varchar(10),
	@KeyItem as varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from M_BankBranch
			where BankCD = @BankCD
			and   BranchCD=@BranchCD
			and ChangeDate = @ChangeDate


	exec dbo.L_Log_Insert @Operator,@Program,@PC,@OperateMode,@KeyItem
END

