
 BEGIN TRY 
 Drop Procedure dbo.[_MenuRemoveExclusiveIdle]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE _MenuRemoveExclusiveIdle
	-- Add the parameters for the stored procedure here
	@OptID as varchar(13) 
	,@PcID as varchar(30)
	,@ProgramID as varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

			Delete d from D_Exclusive d inner join L_Log l on
				 d.operator = l.InsertOperator 
				 and d.Program= l.Program
			--	 and  CAST(l.OperateDate AS date) =  cast (getdate() as date) 
				 and d.PC = l.PC
				 where
				 d.PC= @PcID 
				 and d.operator = @OptID
				 and d.Program = @ProgramID
END