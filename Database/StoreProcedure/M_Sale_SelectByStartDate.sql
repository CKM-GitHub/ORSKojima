BEGIN TRY 
 Drop Procedure dbo.[M_Sale_SelectByStartDate]
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
CREATE PROCEDURE [dbo].[M_Sale_SelectByStartDate]
@StoreCD varchar(10),
@ChangeDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select top 1
	CONVERT(varchar, StartDate,111)as 'StartDate',
	CONVERT(varchar, EndDate,111)as 'EndDate',
    ISNULL(SaleFlg,'') as 'SaleFlg',
	ISNULL(GeneralSaleRate,0.00) as 'GeneralSaleRate',
	ISNULL(MemberSaleRate,0.00) as 'MemberSaleRate',
	ISNULL(ClientSaleRate,0.00) as 'ClientSaleRate',
	ISNULL(GeneralSaleFraction,'') as 'GeneralSaleFraction',
	CONVERT(varchar, StartDate,111)as 'StartDate1'
	from  M_Sale ms
	inner join 
	(
		select  StoreCD,MAX(StartDate) as ChangeDate
		from    dbo.M_Sale
		where StoreCD=@StoreCD
		AND (@ChangeDate is null or (StartDate < @ChangeDate))
		group by StoreCD
	) temp_Store on ms.StoreCD = temp_Store.StoreCD 
	and ms.StartDate = temp_Store.ChangeDate
	--Select top 1
	--ISNULL(CONVERT(varchar, StartDate,111),CONVERT(varchar, GETDATE(),111)) as 'StartDate',
	--ISNULL(CONVERT(varchar, EndDate,111),CONVERT(varchar, GETDATE(),111)) as 'EndDate',
 --   ISNULL(SaleFlg,'') as 'SaleFlg',
	--ISNULL(GeneralSaleRate,0.00) as 'GeneralSaleRate',
	--ISNULL(MemberSaleRate,0.00) as 'MemberSaleRate',
	--ISNULL(ClientSaleRate,0.00) as 'ClientSaleRate',
	--ISNULL(GeneralSaleFraction,'') as 'GeneralSaleFraction',
	--ISNULL(CONVERT(varchar, StartDate,111),CONVERT(varchar, GETDATE(),111)) as 'StartDate1'
	--from  M_Sale
	--Where StoreCD=@StoreCD
	--AND  StartDate < @ChangeDate
END
GO
