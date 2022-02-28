BEGIN TRY 
    Drop Procedure dbo.[M_ITEM_NormalSelect]
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
Create PROCEDURE [dbo].[M_ITEM_NormalSelect]
	-- Add the parameters for the stored procedure here
	@ITemCD as varchar(30),
	@ChangeDate as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * 
	FROM M_ITEM
	WHERE ITemCD = @ITemCD and ChangeDate = @ChangeDate
END
GO


