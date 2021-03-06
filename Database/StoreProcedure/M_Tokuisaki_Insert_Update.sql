BEGIN TRY 
	Drop Procedure dbo.[M_Tokuisaki_Insert_Update]
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
CREATE PROCEDURE [dbo].[M_Tokuisaki_Insert_Update] 
	-- Add the parameters for the stored procedure here
	@TokuisakiCD	as varchar(5),
	@TokuisakiName	as varchar(50),
	@ExportName		as varchar(50),
	@TitleUmuKBN	as tinyint,
	@OyaTokuisakiCD	as varchar(5),
	@Yobi1			as varchar(50),
	@Yobi2			as varchar(50),
	@Yobi3			as varchar(100),
	@Yobi4			as int,
	@Yobi5			as int,
	@Yobi6			as int,
	@Yobi7			as datetime,
	@Yobi8			as datetime,
	@Yobi9			as datetime,

	@Operator		as varchar(10),
	@Mode			as tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CurrentDate as datetime = getdate();

    -- Insert statements for procedure here
	IF @Mode = 1--insert mode
		BEGIN
		
			INSERT INTO M_Tokuisaki
			(
				TokuisakiCD,
				TokuisakiName,
				ExportName,
				TitleUmuKBN,
				OyaTokuisakiCD,
				Yobi1,
				Yobi2,
				Yobi3,
				Yobi4,
				Yobi5,
				Yobi6,
				Yobi7,
				Yobi8,
				Yobi9,
				InsertOperator,
				InsertDateTime,
				UpdateOperator,
				UpdateDateTime
			)
			values
			(		
				@TokuisakiCD,
				@TokuisakiName,
				@ExportName,
				@TitleUmuKBN,
				@OyaTokuisakiCD,
				@Yobi1,
				@Yobi2,
				@Yobi3,
				@Yobi4,
				@Yobi5,
				@Yobi6,
				@Yobi7,
				@Yobi8,
				@Yobi9,
				@Operator,
				@currentDate,
				@Operator,
				@currentDate
			)

		END
		ELSE IF @Mode = 2--update mode
		BEGIN
			UPDATE M_Tokuisaki
			SET
					TokuisakiName	= @TokuisakiName,
					ExportName		= @ExportName,
					TitleUmuKBN		= @TitleUmuKBN,
					OyaTokuisakiCD	= @OyaTokuisakiCD,
					Yobi1			= @Yobi1,
					Yobi2			= @Yobi2,
					Yobi3			= @Yobi3,
					Yobi4			= @Yobi4,
					Yobi5			= @Yobi5,
					Yobi6			= @Yobi6,
					Yobi7			= @Yobi7,
					Yobi8			= @Yobi8,
					Yobi9			= @Yobi9,
					UpdateOperator	= @Operator, 
					UpdateDateTime	= @CurrentDate
										   
			WHERE TokuisakiCD	= @TokuisakiCD	  

		END

END


