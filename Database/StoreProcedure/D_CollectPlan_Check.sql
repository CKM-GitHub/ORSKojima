 BEGIN TRY 
 Drop Procedure dbo.[D_CollectPlan_Check]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [D_CollectPlan_Check]    */
CREATE PROCEDURE [dbo].[D_CollectPlan_Check](
    -- Add the parameters for the stored procedure here
    @Syori    tinyint,        -- 処理区分（1:請求締,2:請求締キャンセル,3:請求確定）
    @StoreCD  varchar(4),
    @CustomerCD  varchar(13),
    @ChangeDate  varchar(10),
    @BillingCloseDate tinyint
)AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here

	--請求締--
    IF @Syori = 1
    BEGIN
		IF EXISTS (SELECT ProcessingKBN FROM D_BillingProcessing
					WHERE ProcessingNO = (SELECT MAX(ProcessingNO) FROM D_BillingProcessing
										  WHERE StoreCD = @StoreCD
										  AND BillingDate = @ChangeDate
										  AND ((@CustomerCD IS NULL AND CustomerCD IS NULL) OR CustomerCD = @CustomerCD)
										  GROUP BY StoreCD, BillingDate, CustomerCD)
					AND ProcessingKBN IN (1, 3))
		BEGIN
            --SelectできればError
            SELECT 'S013' AS MessageID
            RETURN;
		END
		
		IF EXISTS (SELECT ProcessingKBN FROM D_BillingProcessing
					WHERE ProcessingNO in (SELECT MAX(ProcessingNO) FROM D_BillingProcessing
										  WHERE StoreCD = @StoreCD
										  AND BillingDate > @ChangeDate
										  AND ((@CustomerCD IS NULL AND CustomerCD IS NULL) OR (CustomerCD IS NULL OR CustomerCD = @CustomerCD))
										  GROUP BY StoreCD, BillingDate, CustomerCD)
					AND ProcessingKBN IN (1, 3))
		BEGIN
            --SelectできればError
            SELECT 'S016' AS MessageID
            RETURN;
		END
	END

	--請求締ｷｬﾝｾﾙ--
	ELSE IF @Syori = 2 
	BEGIN
		IF EXISTS (SELECT ProcessingKBN FROM D_BillingProcessing
					WHERE ProcessingNO = (SELECT MAX(ProcessingNO) FROM D_BillingProcessing
										  WHERE StoreCD = @StoreCD
										  AND BillingDate = @ChangeDate
										  AND ((@CustomerCD IS NULL AND CustomerCD IS NULL) OR CustomerCD = @CustomerCD)
										  GROUP BY StoreCD, BillingDate, CustomerCD)
					AND ProcessingKBN IN (2, 3))
		BEGIN
            --SelectできればError
            SELECT 'S013' AS MessageID
            RETURN;
		END

		IF NOT EXISTS (SELECT ProcessingKBN FROM D_BillingProcessing
					WHERE ProcessingNO = (SELECT MAX(ProcessingNO) FROM D_BillingProcessing
										  WHERE StoreCD = @StoreCD
										  AND BillingDate = @ChangeDate
										  AND ((@CustomerCD IS NULL AND CustomerCD IS NULL) OR CustomerCD = @CustomerCD)
										  GROUP BY StoreCD, BillingDate, CustomerCD)
					AND ProcessingKBN IN (1))
		BEGIN
            --SelectできればError
            SELECT 'S013' AS MessageID
            RETURN;
		END
	END

	--請求確定--
	ELSE IF @Syori = 3
	BEGIN
		IF EXISTS (SELECT ProcessingKBN FROM D_BillingProcessing
					WHERE ProcessingNO = (SELECT MAX(ProcessingNO) FROM D_BillingProcessing
										  WHERE StoreCD = @StoreCD
										  AND BillingDate = @ChangeDate
										  AND ((@CustomerCD IS NULL AND CustomerCD IS NULL) OR CustomerCD = @CustomerCD)
										  GROUP BY StoreCD, BillingDate, CustomerCD)
					AND ProcessingKBN IN (2, 3))
		BEGIN
            --SelectできればError
            SELECT 'S013' AS MessageID
            RETURN;
		END

		IF NOT EXISTS (SELECT ProcessingKBN FROM D_BillingProcessing
					WHERE ProcessingNO = (SELECT MAX(ProcessingNO) FROM D_BillingProcessing
										  WHERE StoreCD = @StoreCD
										  AND BillingDate = @ChangeDate
										  AND ((@CustomerCD IS NULL AND CustomerCD IS NULL) OR CustomerCD = @CustomerCD)
										  GROUP BY StoreCD, BillingDate, CustomerCD)
					AND ProcessingKBN IN (1))
		BEGIN
            --SelectできればError
            SELECT 'S013' AS MessageID
            RETURN;
		END
	END

	--Comment Closed By TZA For Task 3177
   -- --請求締--
   -- IF @Syori = 1
   -- BEGIN
   --     --※先日付の請求締チェック
   --     if  exists(SELECT DC.CollectPlanNO
   --         FROM D_CollectPlan AS DC
   --         INNER JOIN (SELECT MC.CustomerCD, MAX(MC.ChangeDate) AS ChangeDate
   --             FROM M_Customer AS MC 
   --             WHERE MC.ChangeDate <= @ChangeDate
   --             AND MC.BillingCloseDate = @BillingCloseDate
   --             AND MC.DeleteFlg = 0
   --             GROUP BY MC.CustomerCD) AS MMC ON MMC.CustomerCD = DC.CustomerCD
   --         INNER JOIN D_Billing AS DB ON DB.StoreCD = DC.StoreCD
   --         AND DB.BillingCustomerCD = DC.CustomerCD
   --         AND DB.BillingCloseDate >= @ChangeDate    
   --         AND DB.DeleteDateTime IS Null   
   --         WHERE DC.BillingNO IS Null       
   --         AND DC.DeleteOperator IS Null       
   --         AND DC.DeleteDateTime IS Null       
   --         AND DC.StoreCD = @StoreCD
   --         AND DC.CustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DC.CustomerCD END)
   --         --2021/05/31 Y.Nishikawa CHG 未締時はBillingDateはNULL状態↓↓
			----AND DC.BillingDate <= @ChangeDate   
			--AND (DC.BillingDate IS NULL OR (DC.BillingDate IS NOT NULL AND DC.BillingDate <= @ChangeDate))
			----2021/05/31 Y.Nishikawa CHG 未締時はBillingDateはNULL状態↑↑   
   --         AND DC.InvalidFLG = 0
   --         AND DC.BillingConfirmFlg = 0
   --         AND DC.BillingType = 2
   --     )
   --     begin
   --         --SelectできればError
   --         select 'S016' as MessageID
   --         return;
   --     end
        
   --     --※仮締め中のチェック
   --     if exists(SELECT DC.CollectPlanNO
   --         FROM D_CollectPlan AS DC
   --         INNER JOIN (SELECT MC.CustomerCD, MAX(MC.ChangeDate) AS ChangeDate
   --             FROM M_Customer AS MC 
   --             WHERE MC.ChangeDate <= @ChangeDate
   --             AND MC.BillingCloseDate = @BillingCloseDate
   --             AND MC.DeleteFlg = 0
   --             GROUP BY MC.CustomerCD) AS MMC ON MMC.CustomerCD = DC.CustomerCD
   --         INNER JOIN D_Billing AS DB ON DB.StoreCD = DC.StoreCD
   --         AND DB.BillingCustomerCD = DC.CustomerCD
   --         AND DB.BillingConfirmFlg = 0
   --         AND DB.DeleteDateTime IS Null   
            
   --         WHERE DC.BillingNO IS Null       
   --         AND DC.DeleteOperator IS Null       
   --         AND DC.DeleteDateTime IS Null       
   --         AND DC.StoreCD = @StoreCD
   --         AND DC.CustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DC.CustomerCD END)
   --         --2021/05/31 Y.Nishikawa CHG 未締時はBillingDateはNULL状態↓↓
			----AND DC.BillingDate <= @ChangeDate   
			--AND (DC.BillingDate IS NULL OR (DC.BillingDate IS NOT NULL AND DC.BillingDate <= @ChangeDate))
			----2021/05/31 Y.Nishikawa CHG 未締時はBillingDateはNULL状態↑↑   
   --         AND DC.InvalidFLG = 0
   --         AND DC.BillingConfirmFlg = 0
   --         AND DC.BillingType = 2
   --     )
   --     begin
   --         --SelectできればError
   --         select 'S017' as MessageID
   --         return;
   --     end
   -- END

   -- --請求締ｷｬﾝｾﾙ--
   -- ELSE IF @Syori = 2
   -- BEGIN
   --     if NOT exists(SELECT DB.BillingNO
   --         FROM D_Billing AS DB
   --         INNER JOIN (SELECT MC.CustomerCD, MAX(MC.ChangeDate) AS ChangeDate
   --             FROM M_Customer AS MC 
   --             WHERE MC.ChangeDate <= @ChangeDate
   --             AND MC.BillingCloseDate = @BillingCloseDate
   --             AND MC.DeleteFlg = 0
   --             GROUP BY MC.CustomerCD) AS MMC ON MMC.CustomerCD = DB.BillingCustomerCD
   --       WHERE DB.StoreCD = @StoreCD
   --         AND DB.BillingCustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DB.BillingCustomerCD END)
   --         AND DB.BillingConfirmFlg = 0
   --         AND DB.DeleteDateTime IS Null   
   --     )
   --     begin
   --         --SelectできなければError
   --         select 'S013' as MessageID
   --         return;
   --     end
        
   --     --このとき、D_Billing.CollectGaku ≠0のレコ―ドが存在すればエラー
   --     --（既に入金が行われているため取消できません）
   --     if exists(SELECT DB.BillingNO
   --         FROM D_Billing AS DB
   --         INNER JOIN (SELECT MC.CustomerCD, MAX(MC.ChangeDate) AS ChangeDate
   --             FROM M_Customer AS MC 
   --             WHERE MC.ChangeDate <= @ChangeDate
   --             AND MC.BillingCloseDate = @BillingCloseDate
   --             AND MC.DeleteFlg = 0
   --             GROUP BY MC.CustomerCD) AS MMC ON MMC.CustomerCD = DB.BillingCustomerCD
   --       WHERE DB.StoreCD = @StoreCD
   --         AND DB.BillingCustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DB.BillingCustomerCD END)
   --         AND DB.BillingConfirmFlg = 0
   --         AND DB.DeleteDateTime IS Null
   --         AND DB.CollectGaku <> 0   
   --     )
   --     begin
   --         --SelectできなければError
   --         select 'E152' as MessageID
   --         return;
   --     end
   -- END
    
   -- --請求確定--
   -- ELSE IF @Syori = 3
   -- BEGIN
   --     if NOT exists(SELECT DB.BillingNO
   --         FROM D_Billing AS DB
   --         INNER JOIN (SELECT MC.CustomerCD, MAX(MC.ChangeDate) AS ChangeDate
   --             FROM M_Customer AS MC 
   --             WHERE MC.ChangeDate <= @ChangeDate
   --             AND MC.BillingCloseDate = @BillingCloseDate
   --             AND MC.DeleteFlg = 0
   --             GROUP BY MC.CustomerCD) AS MMC ON MMC.CustomerCD = DB.BillingCustomerCD
   --       WHERE DB.StoreCD = @StoreCD
   --         AND DB.BillingCustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DB.BillingCustomerCD END)
   --         AND DB.BillingConfirmFlg = 0
   --         AND DB.DeleteDateTime IS Null   
   --     )
   --     begin
   --         --SelectできなければError
   --         select 'S013' as MessageID
   --         return;
   --     end

   -- END
    
	--Check OK
    select '' as MessageID
    return;

END


