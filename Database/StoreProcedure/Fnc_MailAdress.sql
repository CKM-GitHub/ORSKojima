 BEGIN TRY 
 Drop Function dbo.[Fnc_MailAdress]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create FUNCTION [dbo].[Fnc_MailAdress]
(
    @MailAdress varchar(100)
)
RETURNS varchar(100)
AS
BEGIN
    DECLARE @Result varchar(100);
    
--変換①　アルファベット
    SET @MailAdress = REPLACE(@MailAdress, 'A', 'a' );
	SET @MailAdress = REPLACE(@MailAdress, 'B', 'b' );
	SET @MailAdress = REPLACE(@MailAdress, 'C', 'c' );
	SET @MailAdress = REPLACE(@MailAdress, 'D', 'd' );
	SET @MailAdress = REPLACE(@MailAdress, 'E', 'e' );
	SET @MailAdress = REPLACE(@MailAdress, 'F', 'f' );
	SET @MailAdress = REPLACE(@MailAdress, 'G', 'g' );
	SET @MailAdress = REPLACE(@MailAdress, 'H', 'h' );
	SET @MailAdress = REPLACE(@MailAdress, 'I', 'i' );
	SET @MailAdress = REPLACE(@MailAdress, 'J', 'j' );
	SET @MailAdress = REPLACE(@MailAdress, 'K', 'k' );
	SET @MailAdress = REPLACE(@MailAdress, 'L', 'l' );
	SET @MailAdress = REPLACE(@MailAdress, 'M', 'm' );
	SET @MailAdress = REPLACE(@MailAdress, 'N', 'n' );
	SET @MailAdress = REPLACE(@MailAdress, 'O', 'o' );
	SET @MailAdress = REPLACE(@MailAdress, 'P', 'p' );
	SET @MailAdress = REPLACE(@MailAdress, 'Q', 'q' );
	SET @MailAdress = REPLACE(@MailAdress, 'R', 'r' );
	SET @MailAdress = REPLACE(@MailAdress, 'S', 's' );
	SET @MailAdress = REPLACE(@MailAdress, 'T', 't' );
	SET @MailAdress = REPLACE(@MailAdress, 'U', 'u' );
	SET @MailAdress = REPLACE(@MailAdress, 'V', 'v' );
	SET @MailAdress = REPLACE(@MailAdress, 'W', 'w' );
	SET @MailAdress = REPLACE(@MailAdress, 'X', 'x' );
	SET @MailAdress = REPLACE(@MailAdress, 'Y', 'y' );
	SET @MailAdress = REPLACE(@MailAdress, 'Z', 'z' );

    SET @Result = @MailAdress;
   

--変換結果を返す
    RETURN @Result;

END



