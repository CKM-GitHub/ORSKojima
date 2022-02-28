 BEGIN TRY 
 Drop Function dbo.[Fnc_AdressSpacePullOut]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fnc_AdressSpacePullOut]
(
    @Adress varchar(100)
)
RETURNS varchar(100)
AS
BEGIN
    DECLARE @Result varchar(100);
    
--変換①　アルファベット
    SET @Adress = REPLACE(@Adress, '　', '' );
	SET @Adress = REPLACE(@Adress, ' ', '' );

    SET @Result = @Adress;
   

--変換結果を返す
    RETURN @Result;

END



