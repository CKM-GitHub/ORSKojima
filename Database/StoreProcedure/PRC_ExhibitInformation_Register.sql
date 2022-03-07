IF OBJECT_ID ( 'PRC_ExhibitInformation_Register', 'P' ) IS NOT NULL
    Drop Procedure dbo.[PRC_ExhibitInformation_Register]
GO
IF EXISTS (select * from sys.table_types where name = 'T_ItmRegist')
    Drop TYPE dbo.[T_ItmRegist]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  ==================================================================================
--       Program Call    【出品情報出力】出品履歴データ（D_ExhibitHistory）更新処理
--       Program ID      ExhibitInformation
--       Create date:    
--  ==================================================================================

CREATE TYPE T_ItmRegist AS TABLE
    (
        [Chk] [varchar](1) ,
        [Item_Code] [varchar](32),
        [Item_Name] [varchar](255),
        [List_Price] [int],
        [Price] [int],
        [Cost] [int],
        [ArariRate] [decimal](5,1),
        [WaribikiRate] [decimal](5,1),
        [ID][int],
        [Brand_Name][varchar](200)
    )
GO

--****************************************--
--                                        --
--            登録処理                    --
--                                        --
--****************************************--
CREATE PROCEDURE [dbo].[PRC_ExhibitInformation_Register]
(
    @TokuisakiCD    varchar(5),
    @TableRegist    T_ItmRegist READONLY,
    @Operator       varchar(10),
    @PC             varchar(30),
    
    @OutTokuisakiCD	varchar(5) OUTPUT
)AS

BEGIN

    DECLARE @W_ERR          int;
    DECLARE @SYSDATETIME    datetime;
    DECLARE @Counter        int;
    DECLARE @UpdCount       int;
    
    SET @W_ERR = 0;
    SET @SYSDATETIME = SYSDATETIME();

    

    --【カウンター処理】

    --MultiPorposeのカウンターを取得・更新
    SELECT @Counter = ISNULL(Num1,0)
    FROM M_MultiPorpose
    WHERE [ID]  = 3
    AND   [KEY] = 1
    ;

    --更新件数を取得
    SELECT @UpdCount = COUNT(*)
    FROM   @TableRegist
    ;

    --件数を更新
    UPDATE MP
    SET MP.Num1 = @Counter + @UpdCount 
    FROM M_MultiPorpose MP
    WHERE MP.[ID]  = 3
    AND   MP.[KEY] = 1
    ;



    --【出品履歴データ（D_ExhibitHistory）更新処理】
    INSERT INTO [D_ExhibitHistory]
    (
          [Counter]
        , [TokuisakiCD]
        , [ExhibitDate]
        , [ID]
        , [Item_Code]
        , [Item_Name]
        , [Brand_Name]
        , [List_Price]
        , [Sale_Price]
        , [Cost]
        , [ArariRate]
        , [WaribikiRate]
        , [Yobi1]
        , [Yobi2]
        , [Yobi3]
        , [Yobi4]
        , [Yobi5]
        , [Yobi6]
        , [Yobi7]
        , [Yobi8]
        , [Yobi9]
        , [InsertOperator]
        , [InsertDateTime]
        , [UpdateOperator]
        , [UpdateDateTime]
    )
    SELECT
          ROW_NUMBER() OVER(ORDER BY Main.Item_Code ASC) + @Counter
        , @TokuisakiCD
        , CONVERT(NVARCHAR,GETDATE(),111)
        , Main.ID
        , Main.Item_Code
        , Main.Item_Name
        , Main.Brand_Name
        , Main.List_Price
        , Main.Price
        , Main.Cost
        , Main.ArariRate
        , Main.WaribikiRate
        , NULL
        , NULL
        , NULL
        , 0
        , 0
        , 0
        , NULL
        , NULL
        , NULL
        , @Operator
        , @SYSDATETIME
        , @Operator
        , @SYSDATETIME

    FROM  @TableRegist Main
    ;

    
 
--<<OWARI>>
  return @OutTokuisakiCD;

END


