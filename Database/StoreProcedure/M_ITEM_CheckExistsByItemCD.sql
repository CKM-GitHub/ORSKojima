IF EXISTS (select * from sys.objects where name = 'M_ITEM_CheckExistsByItemCD')
BEGIN
    DROP PROCEDURE M_ITEM_CheckExistsByItemCD
END
GO

CREATE PROCEDURE M_ITEM_CheckExistsByItemCD(
    @ITemCD varchar(30)
)AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 ITemCD
    FROM M_ITEM
    WHERE ITemCD = @ITemCD
    ;
END

