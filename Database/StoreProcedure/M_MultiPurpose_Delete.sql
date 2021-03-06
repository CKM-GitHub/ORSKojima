BEGIN TRY 
 Drop Procedure dbo.[M_MultiPurpose_Delete]
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
CREATE PROCEDURE [dbo].[M_MultiPurpose_Delete]
	-- Add the parameters for the stored procedure here
	@ID as Int,
	@Key as nvarchar(50),
	@Operator nvarchar(10),
	@Program as nvarchar(30),
	@PC as nvarchar(30),
	@OperateMode as nvarchar(10),
	@KeyItem as nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
			Delete From M_MultiPorpose 
			Where ID = @ID AND [Key] = @Key
			
			exec dbo.L_Log_Insert @Operator,@Program,@PC,@OperateMode,@KeyItem
		
END

