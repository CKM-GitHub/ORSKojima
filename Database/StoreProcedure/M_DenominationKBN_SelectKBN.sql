BEGIN TRY 
 Drop Procedure dbo.[M_DenominationKBN_SelectKBN]
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
CREATE PROCEDURE [dbo].[M_DenominationKBN_SelectKBN]
@denominationCD as varchar(3) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select SystemKBN from M_DenominationKBN where DenominationCD=@denominationCD
END
GO
