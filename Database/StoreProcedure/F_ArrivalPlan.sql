 BEGIN TRY 
 Drop Function dbo.[F_ArrivalPlan]
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
CREATE FUNCTION [dbo].[F_ArrivalPlan] 
(	
	-- Add the parameters for the function here
	@CalcuArrivalPlanDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT dap.*  from D_ArrivalPlan dap
	inner join
	(
		select ArrivalPlanNO,AdminNO,MAX(CalcuArrivalPlanDate)as CalcuArrivalPlanDate  from dbo.D_ArrivalPlan
		where (@CalcuArrivalPlanDate is null or (CalcuArrivalPlanDate<=@CalcuArrivalPlanDate))
		group by ArrivalPlanNO,AdminNO
	) temp_ArrivalPlan
	on dap.ArrivalPlanNO=temp_ArrivalPlan.ArrivalPlanNO and dap.AdminNO=temp_ArrivalPlan.AdminNO and dap.CalcuArrivalPlanDate=temp_ArrivalPlan.CalcuArrivalPlanDate
)


