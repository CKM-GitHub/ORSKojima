 BEGIN TRY 
 Drop Function dbo.[Fnc_SetCheckdigit]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fnc_SetCheckdigit]
(
    @inJAN12 varchar(12)
)
RETURNS varchar(13)
AS
BEGIN
    DECLARE @Flg int;
    DECLARE @Result varchar(13);
    
    --チェック
    --①inJAN12 値が0～9以外の値が入っていればError
    SET @Flg = (SELECT ISNUMERIC(@inJAN12));
    
    IF @Flg = 0
    BEGIN
        RETURN NULL;
    END
    
    --計算
    --①inJAN12 が、長さ12でなければinJAN12の後ろに"0"を長さ12になるまで追加
    --SET @Result = SUBSTRING(@inJAN12 + '00000000000',1,12);   ////Closed by ETZ for taskNO 2869
	SET @Result = SUBSTRING( '00000000000'+@inJAN12 ,len('00000000000'+@inJAN12)-11,12);  --///Added by ETZ for taskNO 2869
    
    --②すべての偶数桁の数値を加算・・・Ａ
    DECLARE @A int;
    SET @A = CONVERT(int,SUBSTRING(@Result,2,1)) + CONVERT(int,SUBSTRING(@Result,4,1)) + CONVERT(int,SUBSTRING(@Result,6,1)) 
            +CONVERT(int,SUBSTRING(@Result,8,1)) + CONVERT(int,SUBSTRING(@Result,10,1)) + CONVERT(int,SUBSTRING(@Result,12,1));
    
    --すべての奇数桁の数値を加算・・・Ｂ         
    DECLARE @B int;
    SET @B = CONVERT(int,SUBSTRING(@Result,1,1)) + CONVERT(int,SUBSTRING(@Result,3,1)) + CONVERT(int,SUBSTRING(@Result,5,1)) 
            +CONVERT(int,SUBSTRING(@Result,7,1)) + CONVERT(int,SUBSTRING(@Result,9,1)) + CONVERT(int,SUBSTRING(@Result,11,1));

    --Ａ×３＋Ｂの１の位の値をＣとする      
    DECLARE @C int;
    SET @C = (@A*3+@B) % 10;
    
    --１０－Ｃ→Ｄ（※Ｃ＝０の時は、Ｄ＝０とする）Ｄがチェックデジットとなる。
    IF @C = 0
    BEGIN
        RETURN @Result + '0';
    END

    --out番号に、inJAN12    ＆  Ｄ  をセット
    RETURN @Result + CONVERT(varchar,(10-@C));

END



