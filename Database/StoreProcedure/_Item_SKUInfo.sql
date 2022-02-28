 BEGIN TRY 
 Drop Procedure dbo.[_Item_SKUInfo]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_Item_SKUInfo] 
	-- Add the parameters for the stored procedure here
      @ItemTable as T_ItemImport readonly
	 ,@Opt as varchar(20)
	 ,@Date as datetime
	 ,@MainFlg as tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	if @MainFlg = 1 or @MainFlg =5
	Begin

    -- Insert statements for procedure here
		Declare
        @Upt as int =1,
        @Ins as int = 1;

		Update msi set
		     msi.YearTerm = msk.LastYearTerm
		    ,msi.Season = msk.LastSeason
		    ,msi.CatalogNO = msk.LastCatalogNO
		    ,msi.CatalogPage =msk.LastCatalogPage
		    ,msi.CatalogText = msk.LastCatalogText
		    ,msi.InstructionsNO = msk.LastInstructionsNO
		    ,msi.InstructionsDate =msk.LastInstructionsDate
		    ,msi.UpdateDateTime = @Date
		    ,msi.UpdateOperator = @Opt
			
		from M_SKUInfo msi
		inner join M_SKU msk on msk.AdminNO = msi.AdminNO and msk.ChangeDate = msi.ChangeDate
		inner join @ItemTable tim on tim.ITemCD = msk.ITemCD and tim.ChangeDate = msk.ChangeDate


		insert into M_SKUInfo
		select 
             msk.AdminNO
            ,tim.ChangeDate
            ,1
            ,tim.LastYearTerm
            ,tim.LastSeason
            ,tim.LastCatalogNO
            ,tim.LastCatalogPage
            ,tim.LastCatalogText
            ,tim.LastInstructionsNO
            ,tim.LastInstructionsDate
            ,0
            ,@Opt
            ,@Date
            ,@Opt
            ,@Date
			 
        from M_SKU msk
        inner join @ItemTable tim on tim.ITemCD = msk.ITemCD and tim.ChangeDate = msk.ChangeDate
        where not exists (select * from M_SKUInfo msi where msi.AdminNO = msk.AdminNO and msi.ChangeDate = msk.ChangeDate)

	End		
END