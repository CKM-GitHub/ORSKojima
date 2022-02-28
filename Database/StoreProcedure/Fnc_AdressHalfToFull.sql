 BEGIN TRY 
 Drop Function dbo.[Fnc_AdressHalfToFull]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create FUNCTION [dbo].[Fnc_AdressHalfToFull]
(
    @MailAdress varchar(100)
)
RETURNS varchar(120)
AS
BEGIN
    DECLARE @Result varchar(120);
    
--変換①　アルファベット
    SET @MailAdress = REPLACE(@MailAdress, 'A', 'Ａ' );
	SET @MailAdress = REPLACE(@MailAdress, 'B', 'Ｂ' );
	SET @MailAdress = REPLACE(@MailAdress, 'C', 'Ｃ' );
	SET @MailAdress = REPLACE(@MailAdress, 'D', 'Ｄ' );
	SET @MailAdress = REPLACE(@MailAdress, 'E', 'Ｅ' );
	SET @MailAdress = REPLACE(@MailAdress, 'F', 'Ｆ' );
	SET @MailAdress = REPLACE(@MailAdress, 'G', 'Ｇ' );
	SET @MailAdress = REPLACE(@MailAdress, 'H', 'Ｈ' );
	SET @MailAdress = REPLACE(@MailAdress, 'I', 'Ｉ' );
	SET @MailAdress = REPLACE(@MailAdress, 'J', 'Ｊ' );
	SET @MailAdress = REPLACE(@MailAdress, 'K', 'Ｋ' );
	SET @MailAdress = REPLACE(@MailAdress, 'L', 'Ｌ' );
	SET @MailAdress = REPLACE(@MailAdress, 'M', 'Ｍ' );
	SET @MailAdress = REPLACE(@MailAdress, 'N', 'Ｎ' );
	SET @MailAdress = REPLACE(@MailAdress, 'O', 'Ｏ' );
	SET @MailAdress = REPLACE(@MailAdress, 'P', 'Ｐ' );
	SET @MailAdress = REPLACE(@MailAdress, 'Q', 'Ｑ' );
	SET @MailAdress = REPLACE(@MailAdress, 'R', 'Ｒ' );
	SET @MailAdress = REPLACE(@MailAdress, 'S', 'Ｓ' );
	SET @MailAdress = REPLACE(@MailAdress, 'T', 'Ｔ' );
	SET @MailAdress = REPLACE(@MailAdress, 'U', 'Ｕ' );
	SET @MailAdress = REPLACE(@MailAdress, 'V', 'Ｖ' );
	SET @MailAdress = REPLACE(@MailAdress, 'W', 'Ｗ' );
	SET @MailAdress = REPLACE(@MailAdress, 'X', 'Ｘ' );
	SET @MailAdress = REPLACE(@MailAdress, 'Y', 'Ｙ' );
	SET @MailAdress = REPLACE(@MailAdress, 'Z', 'Ｚ' );

--変換②　数字
	SET @MailAdress = REPLACE(@MailAdress, '1', '１' );
	SET @MailAdress = REPLACE(@MailAdress, '2', '２' );
	SET @MailAdress = REPLACE(@MailAdress, '3', '３' );
	SET @MailAdress = REPLACE(@MailAdress, '4', '４' );
	SET @MailAdress = REPLACE(@MailAdress, '5', '５' );
	SET @MailAdress = REPLACE(@MailAdress, '6', '６' );
	SET @MailAdress = REPLACE(@MailAdress, '7', '７' );
	SET @MailAdress = REPLACE(@MailAdress, '8', '８' );
	SET @MailAdress = REPLACE(@MailAdress, '9', '９' );
	SET @MailAdress = REPLACE(@MailAdress, '0', '０' );

--変換②　記号
	SET @MailAdress = REPLACE(@MailAdress, '-', '－' );
	SET @MailAdress = REPLACE(@MailAdress, '_', '＿' );
	

    SET @Result = @MailAdress;
   

--変換結果を返す
    RETURN @Result;

END



