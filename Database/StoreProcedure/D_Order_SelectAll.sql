 BEGIN TRY 
 Drop Procedure dbo.[D_Order_SelectAll]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [D_Order_SelectAll]    */
CREATE PROCEDURE D_Order_SelectAll(
    -- Add the parameters for the stored procedure here
    @OrderDateFrom  varchar(10),
    @OrderDateTo  varchar(10),
    @StoreCD  varchar(4),
    @StaffCD  varchar(10),
    @OrderCD  varchar(13),
    @SKUName varchar(100),
    @ITemCD varchar(300) ,		--�J���}��؂�
    @SKUCD varchar(300),			--�J���}��؂�
    @JanCD varchar(300), 		--�J���}��؂�
    @MakerItem varchar(30) 
)AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF OBJECT_ID( N'[dbo]..[#TableForSearchHacchuuNO]', N'U' ) IS NOT NULL
      BEGIN
        DROP TABLE [#TableForSearchHacchuuNO];
      END
      
    SELECT DH.OrderNO
            ,(CASE WHEN DH.ApprovalStageFLG >= 9 THEN '���F��'
                    WHEN DH.ApprovalStageFLG = 1 THEN '�\��'
                    WHEN DH.ApprovalStageFLG = 0 THEN '�p��'
                    ELSE '���F��' END) AS ApprovalStageFLG
            ,(CASE DH.ReturnFLG WHEN 1 THEN '��'
                                WHEN 2 THEN '�L'
                                ELSE '' END) AS ReturnFLG
          ,CONVERT(varchar,DH.OrderDate,111) AS OrderDate
          
          ,CONVERT(varchar,DH.InsertDateTime,111) AS InsertDateTime
          ,DH.OrderCD
--          ,DH.CustomerName
          ,(SELECT top 1 A.VendorName
          FROM M_Vendor A 
          WHERE A.VendorCD = DH.OrderCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.OrderDate
		  --AND A.VendorFlg = 1
          ORDER BY A.ChangeDate desc) AS VendorName 
          
            ,(CASE DH.DestinationKBN WHEN 2 THEN (SELECT top 1 A.SoukoName
                                        FROM M_Souko AS A 
                                        WHERE A.SoukoCD = DH.DestinationSoukoCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.OrderDate
                                        ORDER BY A.ChangeDate desc) 
                                        WHEN 1 THEN DH.DestinationName
										--(SELECT top 1 A.DeliveryName
                                        --FROM D_DeliveryPlan A WHERE A.DeliveryPlanNO = DJ.DeliveryPlanNO)
                                        ELSE '' END) AS DeliveryName
                                        
            ,(CASE DH.DestinationKBN WHEN 2 THEN (SELECT top 1 A.Address1
                                        FROM M_Souko AS A 
                                        WHERE A.SoukoCD = DH.DestinationSoukoCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.OrderDate
                                        ORDER BY A.ChangeDate desc) 
                                        WHEN 1 THEN ISNULL(DH.DestinationAddress1+ ' ','') + ISNULL(DH.DestinationAddress2,'')
                                        -- (SELECT top 1 ISNULL(A.DeliveryAddress1+ ' ','') + ISNULL(A.DeliveryAddress2,'')
                                        --FROM D_DeliveryPlan A 
                                        --WHERE A.DeliveryPlanNO = DJ.DeliveryPlanNO
                                        --AND A.DeliveryKBN >= 1 )
                                        ELSE '' END) AS DeliveryAddress

            ,(SELECT top 1 M.SKUName 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS SKUName
            ,(SELECT top 1 M.ITemCD 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS ITemCD
            ,(SELECT top 1 M.SKUCD 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS SKUCD
            ,(SELECT top 1 M.JANCD 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS JANCD
            ,(SELECT top 1 M.MakerItem 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS MakerItem
          ,0 AS Check1  --ITemCD�p�`�F�b�N
          ,0 AS Check2  --SKUCD�p�`�F�b�N
          ,0 AS Check3  --JANCD�p�`�F�b�N
          ,1 AS DelFlg
    INTO #TableForSearchHacchuuNO 
    
    from D_Order AS DH
    LEFT OUTER JOIN D_OrderDetails AS DM ON DM.OrderNO = DH.OrderNO AND DM.DeleteDateTime IS NULL
    LEFT OUTER JOIN D_JuchuuDetails AS DJ ON DJ.JuchuuNO = DM.JuchuuNO AND DJ.JuchuuRows = DM.JuchuuRows AND DJ.DeleteDateTime IS NULL
        WHERE DH.OrderDate >= (CASE WHEN @OrderDateFrom <> '' THEN CONVERT(DATE, @OrderDateFrom) ELSE DH.OrderDate END)
        AND DH.OrderDate <= (CASE WHEN @OrderDateTo <> '' THEN CONVERT(DATE, @OrderDateTo) ELSE DH.OrderDate END)
        AND DH.StoreCD = @StoreCD
        AND DH.StaffCD = (CASE WHEN @StaffCD <> '' THEN @StaffCD ELSE DH.StaffCD END)
        AND DH.OrderCD = (CASE WHEN @OrderCD <> '' THEN @OrderCD ELSE DH.OrderCD END)
        
        AND DH.DeleteDateTime IS NULL
          
        /*AND EXISTS(SELECT M.SKUName 
            FROM M_SKU AS M 
            WHERE DM.OrderNO = DH.OrderNO 
             AND DM.DeleteDateTime IS NULL
             AND M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.SKUNO
             
             )*/
             
    ORDER BY DH.OrderNO
    ;

	IF ISNULL(@SKUName,'') <> ''
	BEGIN

        UPDATE #TableForSearchHacchuuNO
        SET DelFlg = 1
        ;
        
        UPDATE #TableForSearchHacchuuNO
        SET DelFlg = 0
        WHERE SKUName LIKE '%' + @SKUName + '%'
        ;
        
        DELETE FROM #TableForSearchHacchuuNO
        WHERE DelFlg = 1
        ;
	END
	
	IF ISNULL(@MakerItem,'') <> ''
	BEGIN

        UPDATE #TableForSearchHacchuuNO
        SET DelFlg = 1
        ;
        
        UPDATE #TableForSearchHacchuuNO
        SET DelFlg = 0
        WHERE MakerItem LIKE '%' + @MakerItem + '%'
        ;
        
        DELETE FROM #TableForSearchHacchuuNO
        WHERE DelFlg = 1
        ;
	END

    
    DECLARE @VALID_DATA tinyint;
    DECLARE @INDEX int;
    DECLARE @NEXT_INDEX int;
    
    --ITEM�������ɍ���Ȃ��f�[�^���e�[�u������폜
    IF ISNULL(@ITemCD,'') <> ''
    BEGIN
    	    	
        UPDATE #TableForSearchHacchuuNO
        SET Check1 = 1
        ;
        
        SET @VALID_DATA = 1;
        SET @INDEX = 1;
        
        WHILE @VALID_DATA = 1
        BEGIN
            IF CHARINDEX(',', @ITemCD, @INDEX) = 0
            BEGIN
                IF LEN(@ITemCD)-@INDEX >= 0
                BEGIN
                    --�f�[�^����݂̂̏ꍇ
                    UPDATE #TableForSearchHacchuuNO
                    SET Check1 = 0
                    WHERE ITemCD = SUBSTRING(@ITemCD,@INDEX,LEN(@ITemCD)-@INDEX+1)
                    ;
                    
                    BREAK;
                END
            END
            ELSE
            BEGIN
            	SET @NEXT_INDEX = CHARINDEX(',', @ITemCD, @INDEX);
            	
                UPDATE #TableForSearchHacchuuNO
                SET Check1 = 0
                WHERE ITemCD = SUBSTRING(@ITemCD,@INDEX,@NEXT_INDEX-@INDEX)
                ;
                
	            SET @INDEX = @NEXT_INDEX + 1;
            END
        END
        
        DELETE FROM #TableForSearchHacchuuNO
        WHERE  Check1 = 1
        ;
    END;
	
    --SKUCD�������ɍ���Ȃ��f�[�^���e�[�u������폜
    IF ISNULL(@SKUCD,'') <> ''
    BEGIN
    	    	
        UPDATE #TableForSearchHacchuuNO
        SET Check2 = 1
        ;
        
        SET @VALID_DATA = 1;
        SET @INDEX = 1;
        
        WHILE @VALID_DATA = 1
        BEGIN
            IF CHARINDEX(',', @SKUCD, @INDEX) = 0
            BEGIN
                IF LEN(@SKUCD)-@INDEX >= 0
                BEGIN
                    --�f�[�^����݂̂̏ꍇ
                    UPDATE #TableForSearchHacchuuNO
                    SET Check2 = 0
                    WHERE SKUCD = SUBSTRING(@SKUCD,@INDEX,LEN(@SKUCD)-@INDEX+1)
                    ;
                    
                    BREAK;
                END
            END
            ELSE
            BEGIN
            	SET @NEXT_INDEX = CHARINDEX(',', @SKUCD, @INDEX);
            	
                UPDATE #TableForSearchHacchuuNO
                SET Check2 = 0
                WHERE SKUCD = SUBSTRING(@SKUCD,@INDEX,@NEXT_INDEX-@INDEX)
                ;
                
	            SET @INDEX = @NEXT_INDEX + 1;
            END
        END
        
        DELETE FROM #TableForSearchHacchuuNO
        WHERE  Check2 = 1
        ;
    END;
    
    --JANCD�������ɍ���Ȃ��f�[�^���e�[�u������폜
    IF ISNULL(@JANCD,'') <> ''
    BEGIN
    	    	
        UPDATE #TableForSearchHacchuuNO
        SET Check3 = 1
        ;
        
        SET @VALID_DATA = 1;
        SET @INDEX = 1;
        
        WHILE @VALID_DATA = 1
        BEGIN
            IF CHARINDEX(',', @JANCD, @INDEX) = 0
            BEGIN
                IF LEN(@JANCD)-@INDEX >= 0
                BEGIN
                    --�f�[�^����݂̂̏ꍇ
                    UPDATE #TableForSearchHacchuuNO
                    SET Check3 = 0
                    WHERE JANCD = SUBSTRING(@JANCD,@INDEX,LEN(@JANCD)-@INDEX+1)
                    ;
                    
                    BREAK;
                END
            END
            ELSE
            BEGIN
            	SET @NEXT_INDEX = CHARINDEX(',', @JANCD, @INDEX);
            	
                UPDATE #TableForSearchHacchuuNO
                SET Check3 = 0
                WHERE JANCD = SUBSTRING(@JANCD,@INDEX,@NEXT_INDEX-@INDEX)
                ;
                
	            SET @INDEX = @NEXT_INDEX + 1;
            END
        END
        
        DELETE FROM #TableForSearchHacchuuNO
        WHERE  Check3 = 1
        ;
    END;
    
    SELECT DH.OrderNO
        , MAX(DH.ApprovalStageFLG) AS ApprovalStageFLG
        , MAX(DH.OrderDate) AS OrderDate
        , MAX(DH.VendorName) AS VendorName
        , MAX(DH.DeliveryName) AS DeliveryName
        , MAX(DH.DeliveryAddress) AS DeliveryAddress
        , MAX(DH.ReturnFLG) AS ReturnFLG
    FROM #TableForSearchHacchuuNO AS DH
    GROUP BY DH.OrderNO
    ORDER BY DH.OrderNO
    ;
END

GO
