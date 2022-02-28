 BEGIN TRY 
 Drop Procedure dbo.[D_Billing_SelectAll]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [D_Billing_SelectAll]    */
CREATE PROCEDURE [dbo].[D_Billing_SelectAll](
    -- Add the parameters for the stored procedure here
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

    SELECT DB.BillingNO
          ,DB.BillingCustomerCD AS CustomerCD
          ,(SELECT top 1 A.CustomerName
            FROM M_Customer A 
            WHERE A.CustomerCD = DB.BillingCustomerCD AND A.ChangeDate <= DB.BillingCloseDate
            AND A.DeleteFlg = 0 
            ORDER BY A.ChangeDate desc) AS CustomerName 
			,(CASE 
		    WHEN DB.BillingType = 1 THEN N'都度'
		    Else N'締'
	        END) AS 請求
			,(CASE 
             WHEN DB.BillingType = 1 THEN ''
             WHEN DB.BillingType = 2 AND DB.BillingConfirmFlg = 0 THEN N'未確定'
             ELSE N'確定'
             END) AS 状態
		    ,CONVERT(varchar,DB.BillingCloseDate,111) AS BillingCloseDate
            ,DB.BillingGaku
            ,CONVERT(varchar,DB.CollectPlanDate,111) AS CollectPlanDate
            ,SUM(DB.BillingGaku) OVER() AS SUM_BillingGaku

    FROM D_Billing AS DB
	Left outer join M_Customer mc 
	on mc.CustomerCD=DB.BillingCustomerCD
	AND MC.ChangeDate <= DB.BillingCloseDate
    AND MC.BillingCloseDate = (CASE WHEN @BillingCloseDate <> 0 THEN @BillingCloseDate ELSE MC.BillingCloseDate END)
    WHERE DB.StoreCD = @StoreCD
	AND DB.DeleteDateTime IS NULL
	AND (@ChangeDate IS NULL OR (DB.BillingCloseDate = @ChangeDate))
	AND DB.BillingCustomerCD = (CASE WHEN @CustomerCD <> '' THEN @CustomerCD ELSE DB.BillingCustomerCD END)
	ORDER BY DB.BillingNO, DB.BillingCustomerCD, DB.CollectPlanDate
    ;

END

