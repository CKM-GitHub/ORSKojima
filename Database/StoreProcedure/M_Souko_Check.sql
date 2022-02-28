BEGIN TRY 
 Drop Procedure [dbo].[M_Souko_Check]
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
CREATE PROCEDURE [dbo].[M_Souko_Check]
	-- Add the parameters for the stored procedure here
	 @StoreCD as varchar(4),
	@SoukoCD as varchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select SoukoCD from M_Souko
	where StoreCD=@StoreCD
	and DeleteFlg=0
	and SoukoType=3
	and SoukoCD <> @SoukoCD

END
GO
