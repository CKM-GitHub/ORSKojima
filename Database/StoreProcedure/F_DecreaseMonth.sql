 BEGIN TRY 
 Drop Function dbo.[F_DecreaseMonth]
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
CREATE FUNCTION [dbo].[F_DecreaseMonth]
(	
	-- Add the parameters for the function here
	@YM as int,
	@NODM as int
)
RETURNS @Output TABLE (
      resultDate int
	  )
AS
	BEGIN
		DECLARE  @newdate AS DATE

		SET @newdate = Dateadd(month, -@NODM,CONVERT(date,convert(varchar(10), @ym ,101) + '01',101))

		INSERT INTO @Output(resultDate)
		SELECT CONVERT(int,Replace(CONVERT(varchar(7),@newdate),'-',''))

		RETURN
	END
	

