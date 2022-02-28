 BEGIN TRY 
 Drop Procedure [dbo].[M_Souko_BindForHacchuuNyuuryoku] 
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
CREATE PROCEDURE [dbo].[M_Souko_BindForHacchuuNyuuryoku] 
	-- Add the parameters for the stored procedure here
    @ChangeDate as varchar(10),
	@StoreCD as varchar(4)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT SoukoCD,SoukoName
	FROM F_Souko(@ChangeDate)
	WHERE DeleteFlg =0
	AND StoreCD=@StoreCD
	AND SoukoType IN(1,3)
	ORDER BY SoukoCD
END
GO
