 BEGIN TRY 
 Drop Function dbo.[F_Carrier]
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
CREATE FUNCTION [dbo].[F_Carrier]
(	
	-- Add the parameters for the function here
	@ChangeDate as date
	--@DeleteFlg as tinyint
)
RETURNS TABLE 
AS
RETURN 
(
	
	select mc.* from M_Carrier mc
	inner join 
	(
	select  CarrierCD, MAX(ChangeDate) as ChangeDate
	from    dbo.M_Carrier
	where (@ChangeDate is null or (ChangeDate <= @ChangeDate)) and DeleteFlg = 0
	group by CarrierCD
	) temp_Carrier on mc.CarrierCD = temp_Carrier.CarrierCD and mc.ChangeDate= temp_Carrier.ChangeDate
)


