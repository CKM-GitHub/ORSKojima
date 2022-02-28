 BEGIN TRY 
 Drop Procedure dbo.[D_ArrivalPlan_Select]
END try
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
CREATE PROCEDURE [dbo].[D_ArrivalPlan_Select]
	-- Add the parameters for the stored procedure here
	@SoukoCD as Varchar(30), 
	@CalcuArrivalPlanDate1 as date,
	@CalcuArrivalPlanDate2 as date,
	@FrmSoukoCD as varchar(6), 
	@ITEMCD as varchar(200),
	@JanCD as varchar(200), 
	@SKUCD as varchar(200),
	@MakerItem varchar(30),
	
	@ArrivalDate1 as date,
	@ArrivalDate2 as date, 
	@PurchaseSu as int, 
	@VendorDeliveryNo as varchar(15),
	
	@PurchaseDateFrom as date,
	@PurchaseDateTo as date,
	@VendorCD as varchar(13),
	@StatusFlg as tinyint,
	@DisplayFlg as tinyint


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @currentdate as date = getdate()
    -- Insert statements for procedure here
	Select --distinct
	CAST(da.ArrivalDate AS VARCHAR(10)) AS ArrivalDate,
	CAST(dap.CalcuArrivalPlanDate AS VARCHAR(10)) AS CalcuArrivalPlanDate,
	CAST(dp.PurchaseDate AS VARCHAR(10)) AS PurchaseDate,
	(CASE 
		  WHEN dap.ArrivalPlanKBN = 1  THEN N'発注'
		  Else N'店舗移動'		  
	END) AS Goods,
	dap.SKUCD ,
	dap.JanCD,
	sku.SKUName,
	sku.ColorName,
	sku.SizeName,
	CAST(dap.ArrivalPlanSu AS VARCHAR(10)) AS ArrivalPlanSu,
	CAST(dad.ArrivalSu AS VARCHAR(10)) AS ArrivalSu,
	mv.VendorName,
	ms.SoukoName,
	(CASE 
		  WHEN sku.DirectFlg = 1 THEN N'〇'
		  Else null		  
	END) AS Directdelivery,
	(CASE 
		  WHEN dad.ArrivalKBN = 1 THEN dad.Number  
		  ELSE Null
	END) AS ReserveNumber,
	dap.Number,
	da.ArrivalNO,
	dp.PurchaseNO,
	da.VendorDeliveryNo,
	dad.ArrivalRows

	From D_ArrivalPlan dap
	Left Outer Join D_ArrivalDetails dad on dad.ArrivalPlanNO = dap.ArrivalPlanNO
	INNER Join D_Arrival da on da.ArrivalNO = dad.ArrivalNO
	Left Outer Join D_PurchaseDetails dpd on dpd.ArrivalNO = da.ArrivalNO
	Left Outer Join D_Purchase dp on dp.PurchaseNO = dpd.PurchaseNO
	Left Outer Join D_Stock ds on ds.ArrivalPlanNO = dap.ArrivalPlanNO 
--	Left Outer Join D_Reserve dr on dr.StockNO = ds.StockNO 
	Left Outer Join F_SKU(cast(@currentdate as varchar(10))) sku on sku.AdminNO = da.AdminNO and sku.ChangeDate <= da.ArrivalDate
	Left Outer Join F_Vendor(cast(@currentdate as varchar(10))) mv on mv.VendorCD = dap.OrderCD and mv.ChangeDate <= da.ArrivalDate
	Left Outer Join F_Souko(cast(@currentdate as varchar(10))) ms on ms.SoukoCD = dap.FromSoukoCD and ms.ChangeDate <= dap.CalcuArrivalPlanDate
	Where dap.DeleteDateTime is null and 
	dad.DeleteDateTime is null and
	da.DeleteDateTime is null and 
	dpd.DeleteDateTime is null and 
	dp.DeleteDateTime is null and 
	ds.DeleteDateTime is null and 
--	dr.DeleteDateTime is null and 
	ISNULL(sku.DeleteFlg,0 )= 0 and 
	ISNULL(mv.DeleteFlg,0 )= 0 and 
	ISNULL(ms.DeleteFlg,0 ) = 0 and
	dap.SoukoCD = @SoukoCD and 
    (@ArrivalDate1 is null or	da.ArrivalDate >= @ArrivalDate1) and ( @ArrivalDate2 is null or da.ArrivalDate <= @ArrivalDate2) and 
	(@CalcuArrivalPlanDate1 is null or dap.CalcuArrivalPlanDate >= @CalcuArrivalPlanDate1) and ( @CalcuArrivalPlanDate2 is null or dap.CalcuArrivalPlanDate <= @CalcuArrivalPlanDate2) and
	
	((@StatusFlg = 0 and (dp.PurchaseDate is not null and 
	(@PurchaseDateFrom is null or dp.PurchaseDate >= @PurchaseDateFrom) and (@PurchaseDateTo is  null or dp.PurchaseDate <= @PurchaseDateTo))) or
	(@StatusFlg = 1 and not exists (select PurchaseNO from D_Purchase where PurchaseNO = dpd.PurchaseNO)) or
	(@StatusFlg = 2 and ((dp.PurchaseDate is not null and 
	(@PurchaseDateFrom is null or dp.PurchaseDate >= @PurchaseDateFrom) and (@PurchaseDateTo is  null or dp.PurchaseDate <= @PurchaseDateTo)) or
	not exists (select PurchaseNO from D_Purchase where PurchaseNO = dpd.PurchaseNO)))) and

	(@VendorDeliveryNo is null or da.VendorDeliveryNo = @VendorDeliveryNo) and
	((@DisplayFlg=0 and ((@VendorCD is null and dap.OrderCD is not null) or (@VendorCD is not null and dap.OrderCD=@VendorCD))) or
	((@DisplayFlg = 1 and ((@FrmSoukoCD is null and dap.FromSoukoCD is not null) or (@FrmSoukoCD is not null and dap.FromSoukoCD =@FrmSoukoCD))) or 
	((@DisplayFlg = 2 and (((@VendorCD is null and dap.OrderCD is not null) or (@VendorCD is not null and dap.OrderCD=@VendorCD)) or 
	((@FrmSoukoCD is null and dap.FromSoukoCD is not null) or (@FrmSoukoCD is not null and dap.FromSoukoCD =@FrmSoukoCD))))))) and
	(@ITEMCD is null or dap.SKUCD in (Select SKUCD from M_SKU where ITemCD in (select Item from SplitString(@ITEMCD,','))))and 
	(@JanCD is null or (dap.JanCD in  (select Item from SplitString(@JanCD,','))))and
	(@SKUCD is null  or( dap.SKUCD in (select Item from SplitString(@SKUCD,',')))) and 
	--(@MakerItem is null or ( dap.SKUCD in ( select SKUCD from M_SKU where SKUName LIKE '%' + @MakerItem + ' %')))
	(@MakerItem is null or sku.SKUName like '%'+@MakerItem+'%')
	--Order by dap.CalcuArrivalPlanDate asc,da.ArrivalDate asc,dp.PurchaseDate asc,SKUCD asc
	Order by dap.CalcuArrivalPlanDate asc,da.ArrivalDate asc,dp.PurchaseDate asc,SKUCD asc,da.ArrivalNO,dad.ArrivalRows
	
END


