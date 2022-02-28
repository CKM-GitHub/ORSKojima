BEGIN TRY 
 Drop Procedure dbo.[M_Sale_Insert_Update]
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
CREATE PROCEDURE [dbo].[M_Sale_Insert_Update]
@StoreCD int,
@StartDate varchar(10),
@strDate varchar(10),
@EndDate varchar(10),
@SaleFlg tinyint,
@GeneralSaleRate decimal(3,1),
@GFraction tinyint,
@MemberSaleRate decimal(3,1),
@MFraction tinyint,
@ClientSaleRate decimal(3,1),
@CFraction tinyint,
@Operator varchar(10),
@Program as varchar(30),
@PC as varchar(30),
@OperateMode as varchar(10),
@KeyItem as varchar(100),
@Mode as tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @currentDate as datetime = getdate();
	if @Mode = 1--insert mode
				begin				
				--テーブル転送仕様Ａ
				Delete from M_Sale 
				where StoreCD=@StoreCD 
				and StartDate=@strDate
				--テーブル転送仕様B
				insert into M_Sale
			      (
						StoreCD,
						StartDate,
						EndDate,
						SaleFlg,
						GeneralSaleRate,
						GeneralSaleFraction,
						MemberSaleRate,
						MemberSaleFraction,
						ClientSaleRate,
						ClientSaleFraction,
						InsertOperator,
						InsertDateTime,
						UpdateOperator,
						UpdateDateTime
					)
					values
					(
						@StoreCD,
						@StartDate,
						@EndDate,
						@SaleFlg,
						@GeneralSaleRate,
						@GFraction,
						@MemberSaleRate,
						@MFraction,
						@ClientSaleRate,
						@CFraction,
						@Operator,
						@currentDate,
						@Operator,
						@currentDate
					)
				end
    else if @Mode = 2--update mode
				begin
				--テーブル転送仕様Ａ
				Delete from M_Sale 
				where StoreCD=@StoreCD 
				and StartDate=@strDate
				end
    exec dbo.L_Log_Insert @Operator,@Program,@PC,@OperateMode,@KeyItem

END
GO
