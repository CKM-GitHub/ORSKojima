BEGIN TRY 
 Drop Procedure dbo.[M_Sale_ErrorCheck]
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
CREATE PROCEDURE [dbo].[M_Sale_ErrorCheck]
@StoreCD varchar(10),
@ChangeDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from M_Sale 
	where StoreCD=@StoreCD
	And EndDate>=@ChangeDate
END
