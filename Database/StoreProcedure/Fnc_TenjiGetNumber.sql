 BEGIN TRY 
 Drop Function dbo.[Fnc_TenjiGetNumber]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fnc_TenjiGetNumber]
(
	-- Add the parameters for the function here
	@SlipType as int,
	@ReferenceDate as date,
	@StoreCD as  varchar(10)
)
RETURNS  VARCHAR(MAX)  
AS
BEGIN
	declare @StoreKBN int,@data int;
		DECLARE @sql varchar(4000), @cmd varchar(4000)
	IF @SlipType=13
		BEGIN
		if not exists(select 1 from M_temporaryReserve where TemporaryReserveKey =1)
		BEGIN	
			set @sql ='';
				SELECT @sql = 'insert into M_temporaryReserve (TemporaryReserveCounter,TemporaryReserveKey) values( 1,1)'
			SELECT @cmd = 'sqlcmd -S ' + @@SERVERNAME +  ' -d ' + db_name() + ' -Q "' + @sql + '"'
				EXEC master..xp_cmdshell @cmd, 'no_output'
			--update M_temporaryReserve set TemporaryReserveCounter=(TemporaryReserveCounter +1) where TemporaryReserveKey ='1'
		END
		if  exists(select 1 from M_temporaryReserve where TemporaryReserveKey =1)
		Begin
				set @sql ='';
				SELECT @sql = 'update M_temporaryReserve  set  TemporaryReserveCounter=(TemporaryReserveCounter +1) where TemporaryReserveKey = 1'
			SELECT @cmd = 'sqlcmd -S ' + @@SERVERNAME +  ' -d ' + db_name() + ' -Q "' + @sql + '"'
				EXEC master..xp_cmdshell @cmd, 'no_output'
			return (select (Right('00000000000'+  Cast(TemporaryReserveCounter +1 as varchar(11)),11))  
			 from M_temporaryReserve where TemporaryReserveKey =1)

		End
		--ELSE
		--BEGIN 
		--set @sql ='';
		--		SELECT @sql = 'insert into M_temporaryReserve (TemporaryReserveCounter,TemporaryReserveKey) values( 1,1)'
		--	SELECT @cmd = 'sqlcmd -S ' + @@SERVERNAME +  ' -d ' + db_name() + ' -Q "' + @sql + '"'
		--		EXEC master..xp_cmdshell @cmd, 'no_output'
		--set @sql ='';
		--		SELECT @sql = 'update M_temporaryReserve  set  TemporaryReserveCounter=(TemporaryReserveCounter +1) where TemporaryReserveKey = 1'
		--	SELECT @cmd = 'sqlcmd -S ' + @@SERVERNAME +  ' -d ' + db_name() + ' -Q "' + @sql + '"'
		--		EXEC master..xp_cmdshell @cmd, 'no_output'
		--	return (select (Right('00000000000'+  Cast(TemporaryReserveCounter +1 as varchar(11)),11))  
		--	 from M_temporaryReserve where TemporaryReserveKey =1)
		--END
		END
	ELSE 
		BEGIN			
			IF  (SELECT 1 FROM  M_Calendar WHERE  CalendarDate=@ReferenceDate ) is null
			 BEGIN
				 return null
			 END
			ELSE
				BEGIN
					SELECT @StoreKBN = StoreKBN from M_Store where StoreCD = @StoreCD
				IF @StoreKBN is null
						BEGIN
						return null;
						END 
				ELSE IF @StoreKBN = 2
						BEGIN
					set	@StoreCD	= (select top 1 StoreCD from M_Store where StoreKBN=3 and DeleteFlg=0 and ChangeDate<=@ReferenceDate)
						END				
				ELSE
					BEGIN
						
						SELECT @data = (CAST(mpn.Prefix as int) + CAST(mpn.Prefix2 as int) + (CAST(mpn.SeqNumber as int)+1))
						FROM M_PrefixNumber mpn
						INNER JOIN M_Prefix mp on mpn.Prefix=mp.Prefix
						INNER JOIN M_Control mc on(CASE mc.SeqUnit WHEN 1 THEN '0000' 
																   WHEN 2 THEN DATEPART(YYYY,@ReferenceDate)
																   ELSE  CONVERT(char(4),@ReferenceDate, 12) END ) = mpn.Prefix2
						WHERE  mp.SeqKBN=@SlipType
						AND mp.StoreCD=@StoreCD
						AND mc.MainKey=1
							 return @data;
						END
					END
		END

		 return null;
END

--SELECT * FROM  M_Calendar WHERE  CalendarDate<=getdate()
 
--select * from M_Store where storecd = '0001'

--update F_Store(getdate()) set StoreCD = '0001' where StoreCD = '1022' and storeKBN = 3
 

