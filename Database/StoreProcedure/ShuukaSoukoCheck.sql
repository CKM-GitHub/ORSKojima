BEGIN TRY
DROP PROCEDURE ShuukaSoukoCheck
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
CREATE PROCEDURE ShuukaSoukoCheck 
	-- Add the parameters for the stored procedure here
	@ChangeDate as Date ,
	@SoukoCD as varchar(13)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		select 1 from M_StoreAuthorizations msa 
							inner join	F_Souko(@ChangeDate )  ms on msa.StoreCD = ms.StoreCD
							where
							 ms.SoukoCD= @SoukoCD
							and 
							ms.ChangeDate <= @ChangeDate
END
GO

