BEGIN TRY 
    Drop Procedure dbo.[INSERT_UPDATE_D_MailAddress]
END TRY
BEGIN CATCH END CATCH

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[INSERT_UPDATE_D_MailAddress]
(
    @KBN tinyint,
    @MailAddress  varchar(100),
    @Rows int,
    @MailCounter  int
)AS
--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN

    IF @KBN = 1
    BEGIN
        --【D_MailAddress】メール連絡宛先　Table転送仕様Ｄ
        INSERT INTO [D_MailAddress]
           ([MailCounter]
           ,[AddressRows]
           ,[AddressKBN]
           ,[Address])
        VALUES(
            @MailCounter
           ,@Rows   --AddressRows
           ,1   --AddressKBN
           ,@MailAddress  --Address
           );
    END
    
    ELSE IF @KBN = 2
    BEGIN
        UPDATE [D_MailAddress]
        SET [AddressKBN] = 1
           ,[Address] = @MailAddress
        WHERE MailCounter = @MailCounter
        AND AddressRows = @Rows
        ;  
    END

END


GO


