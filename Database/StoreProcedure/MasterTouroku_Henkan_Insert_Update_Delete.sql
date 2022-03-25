BEGIN TRY 
	Drop Procedure [dbo].[MasterTouroku_Henkan_Insert_Update_Delete]  
END TRY
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MasterTouroku_Henkan_Insert_Update_Delete]  
	 @TokuisakiCD varchar(5),
	 @RCMItemName varchar(50),
	 @RCMItemValue varchar(50),
	 @CsvOutputItemValue varchar(50),
	 @CsvTitleName varchar(50),
	 @Operator varchar(10),
	 @Mode as tinyint
AS
BEGIN
	Declare @SystemDate datetime=SYSDATETIME()

	SET NOCOUNT ON;
	
	 IF @Mode = 1--insert mode
	 Begin					
	
	 Insert Into M_Henkan(TokuisakiCD,
						  RCMItemName,
						  RCMItemValue,
						  CsvOutputItemValue,
						  CsvTitleName,
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
						  UpdateDateTime)
	 Values				 (@TokuisakiCD,
						  @RCMItemName,
						  @RCMItemValue,
						  @CsvOutputItemValue,
						  @CsvTitleName,
						  NULL,
						  NULL,
						  NULL,
						  0,
						  0,
						  0,
						  NULL,
						  NULL,
						  NULL,
						  @Operator,
						  @SystemDate,
						  @Operator,
						  @SystemDate)
	                 
	 END
	 ELSE IF @Mode = 2--update mode
	 BEGIN
	  Update  M_Henkan
	  SET	  CsvOutputItemValue=@CsvOutputItemValue,
			  CsvTitleName=@CsvTitleName,
			  Yobi1=NULL,
			  Yobi2=NULL,
			  Yobi3=NULL,
			  Yobi4=0,
			  Yobi5=0,
			  Yobi6=0,
			  Yobi7=NULL,
			  Yobi8=NULL,
			  Yobi9=NULL,
			  UpdateOperator=@Operator,
			  UpdateDateTime= @SystemDate
	  Where   TokuisakiCD=@TokuisakiCD
	  AND     RCMItemName=@RCMItemName
	  AND     RCMItemValue=@RCMItemValue
	 END
	 ELSE IF @Mode = 3--delete mode
	 BEGIN
	  Delete
	  FROM	M_Henkan
	  Where   TokuisakiCD=@TokuisakiCD
	  AND     RCMItemName=@RCMItemName
	  AND     RCMItemValue=@RCMItemValue
	 END
END

GO
