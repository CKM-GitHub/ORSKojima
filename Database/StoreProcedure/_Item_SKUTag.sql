
 BEGIN TRY 
 Drop Procedure dbo.[_IteM_SKUTag]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_IteM_SKUTag]
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

	Declare
    @Upt as int =1,
    @Ins as int = 1;

    if @MainFlg = 1 --or @MainFlg = 3 or @MainFlg =4
    Begin

        Delete tag 
        from M_SKUTag tag
        inner join M_SKU sku on sku.AdminNO = tag.AdminNO and sku.ChangeDate = tag.ChangeDate
        inner join @ItemTable tp on tp.ITemCD = sku.ITemCD and tp.ChangeDate = sku.ChangeDate


	    insert into M_SKUTag 
	    select distinct AdminNO, ChangeDate, ROW_NUMBER() OVER (PARTITION BY AdminNo, ChangeDate  ORDER BY AdminNo, SEQ) RowNo, TaggedName

	    from (
            select distinct ms.AdminNo, ms.ChangeDate, 1 as SEQ ,tp.TagName01 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all 
            select distinct ms.AdminNo, ms.ChangeDate, 2 as SEQ ,tp.TagName02 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 3 as SEQ ,tp.TagName03 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 4 as SEQ ,tp.TagName04 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 5 as SEQ ,tp.TagName05 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 6 as SEQ ,tp.TagName06 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 7 as SEQ ,tp.TagName07 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 8 as SEQ ,tp.TagName08 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 9 as SEQ ,tp.TagName09 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
		    union all
            select distinct ms.AdminNo, ms.ChangeDate, 10 as SEQ ,tp.TagName10 as TaggedName from M_SKU ms inner join @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
								  
	    ) t where t.TaggedName != '' order by AdminNO , ChangeDate 

    End
	
	IF @MainFlg = 6
	BEGIN

	       --M_SKUTagをDeleteする前にここに退避させておく
           CREATE TABLE #tempTagName
		   (
		      [AdminNO] [varchar](50) collate database_default NOT null
			, [ChangeDate] [date] NOT null
			, [SEQ] [int] NOT null
			, [TagName][varchar](40)
		   );

	
	       INSERT INTO #tempTagName
	       SELECT DISTINCT AdminNO, ChangeDate, ROW_NUMBER() OVER (PARTITION BY AdminNo, ChangeDate  ORDER BY AdminNo, SEQ) RowNo, TaggedName
		   FROM (


				SELECT distinct ms.AdminNo, ms.ChangeDate, 1 as SEQ
				, CASE WHEN tmp.TagName01 IS NOT NULL THEN CASE tmp.TagName01 WHEN tag.TagName THEN tp.TagName01 ELSE tag.TagName END 
				       ELSE tp.TagName01
				  END AS TaggedName
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 1
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 2 as SEQ 
				, CASE WHEN tmp.TagName02 IS NOT NULL THEN CASE tmp.TagName02 WHEN tag.TagName THEN tp.TagName02 ELSE tag.TagName END
				       ELSE tp.TagName02
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 2
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 3 as SEQ 
				, CASE WHEN tmp.TagName03 IS NOT NULL THEN CASE tmp.TagName03 WHEN tag.TagName THEN tp.TagName03 ELSE tag.TagName END
				       ELSE tp.TagName03
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 3
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 4 as SEQ 
				, CASE WHEN tmp.TagName04 IS NOT NULL THEN CASE tmp.TagName04 WHEN tag.TagName THEN tp.TagName04 ELSE tag.TagName END
			           ELSE tp.TagName04
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 4
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 5 as SEQ 
				, CASE WHEN tmp.TagName05 IS NOT NULL THEN CASE tmp.TagName05 WHEN tag.TagName THEN tp.TagName05 ELSE tag.TagName END
				       ELSE tp.TagName05
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 5
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 6 as SEQ 
				, CASE WHEN tmp.TagName06 IS NOT NULL THEN CASE tmp.TagName06 WHEN tag.TagName THEN tp.TagName06 ELSE tag.TagName END
				       ELSE tp.TagName06
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 6
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 7 as SEQ 
				, CASE WHEN tmp.TagName07 IS NOT NULL THEN CASE tmp.TagName07 WHEN tag.TagName THEN tp.TagName07 ELSE tag.TagName END
				       ELSE tp.TagName07
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 7
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 8 as SEQ 
				, CASE WHEN tmp.TagName08 IS NOT NULL THEN CASE tmp.TagName08 WHEN tag.TagName THEN tp.TagName08 ELSE tag.TagName END
				       ELSE tp.TagName08
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 8
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 9 as SEQ 
				, CASE WHEN tmp.TagName09 IS NOT NULL THEN CASE tmp.TagName09 WHEN tag.TagName THEN tp.TagName09 ELSE tag.TagName END
				       ELSE tp.TagName09
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 9
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				union all

				SELECT distinct ms.AdminNo, ms.ChangeDate, 10 as SEQ 
				, CASE WHEN tmp.TagName10 IS NOT NULL THEN CASE tmp.TagName10 WHEN tag.TagName THEN tp.TagName10 ELSE tag.TagName END
				       ELSE tp.TagName10
				  END
				from M_SKU ms 
				INNER JOIN @ItemTable tp on ms.ITemCD = tp.ITemCD and ms.ChangeDate = tp.ChangeDate
				LEFT JOIN M_SKUTag tag on tag.AdminNO = ms.AdminNO and tag.ChangeDate = ms.ChangeDate and tag.SEQ = 10
				INNER JOIN ##tmpTag tmp on tmp.ItemCD = ms.ITemCD and tmp.ChangeDate = ms.ChangeDate

				) t

		   WHERE t.TaggedName != ''
		   ;

	       --全てDelete
           DELETE tag 
           FROM M_SKUTag tag
           INNER JOIN M_SKU sku on sku.AdminNO = tag.AdminNO and sku.ChangeDate = tag.ChangeDate
           INNER JOIN @ItemTable tp on tp.ITemCD = sku.ITemCD and tp.ChangeDate = sku.ChangeDate
		   ;

		   --退避させておいたデータをInsert
           INSERT INTO M_SKUTag
           SELECT * 
           FROM #tempTagName
           ;


	END

END
