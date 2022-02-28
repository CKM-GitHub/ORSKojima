 BEGIN TRY 
 Drop Procedure dbo.[_Item_Site]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_Item_Site]
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

	if @MainFlg = 1 or @MainFlg =8
	Begin

	    Declare
	    @Upt as int =1,
	    @Ins as int = 1;
			
	    update ms set
             ms.ShouhinCD = tim.WebAddress
	        ,ms.siteURL = ISNULL(ma.ShopURL,'') + ISNULL(tim.WebAddress,'') + '.html' 
	        ,ms.UpdateOperator = @Opt
	        ,ms.UpdateDateTime = @Date
	    from M_Site ms
	    inner join M_SKU msk on msk.AdminNO = ms.AdminNO
	    cross apply (select top 1 ma.ShopURL from M_API ma 
                where ma.APIKey = ms.APIKey and ma.ChangeDate <= msk.ChangeDate and ma.SiteKBN > 0
                order by ma.ChangeDate desc) ma
	    inner join @ItemTable tim on tim.ITemCD= msk.ITemCD and tim.ChangeDate = msk.ChangeDate and ISNULL(tim.WebAddress,'') <> '' 


	    insert into M_Site
	    select distinct 
             msk.AdminNO
	        ,map.APIKey 
	        ,tim.WebAddress
	        ,isnull(map.ShopURL,'') + isnull(tim.WebAddress,'') + '.html' as site
	        ,@Opt
	        ,@Date
	        ,@Opt
	        ,@Date
				
	    from M_SKU msk
	    cross apply (
            select map.APIKey, map.ShopURL, ROW_NUMBER() OVER(PARTITION BY map.APIKey ORDER BY map.ChangeDate DESC) RowNum from M_API map 
            where map.ChangeDate <= msk.ChangeDate and SiteKBN > 0) map
	    inner join @ItemTable tim on tim.ITemCD = msk.ITemCD and tim.ChangeDate = msk.ChangeDate and isnull (tim.WebAddress,'') <> ''
	    where not exists (select * from M_Site ms where ms.AdminNO = msk.AdminNO and ms.APIKey = map.APIKey)        
        and map.RowNum = 1

	End
END