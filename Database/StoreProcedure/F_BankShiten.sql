 BEGIN TRY 
 Drop Function dbo.[F_BankShiten]
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
CREATE FUNCTION [dbo].[F_BankShiten]
(	
	-- Add the parameters for the function her
	--@BankCD as varchar(4),
	@ChangeDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	--select  BankCD,BranchCD, MAX(ChangeDate) as ChangeDate
	--from    dbo.M_BankShiten
	--where ChangeDate <= @ChangeDate
	--and BankCD = @BankCD
	--group by BankCD,BranchCD

	--select mb.* from M_BankShiten mb
	
	--inner join 
	--(
	--	select  BankCD,BranchCD, MAX(ChangeDate) as ChangeDate
	--	from    dbo.M_BankShiten
	--	where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
	--	and (@BankCD is null or (BankCD=@BankCD))
	--	group by BankCD,BranchCD
	--) temp_BankShiten  on mb.BankCD = temp_BankShiten.BankCD and mb.BranchCD=temp_BankShiten.BranchCD and mb.ChangeDate = temp_BankShiten.ChangeDate
	select distinct mb.* from M_BankBranch mb
	inner join 
	(
		select  BankCD,BranchCD, MAX(ChangeDate) as ChangeDate
		from    dbo.M_BankBranch
		where (@ChangeDate is null or (ChangeDate <= @ChangeDate))
		group by BankCD,BranchCD
	)  temp_Branch on mb.BankCD = temp_Branch.BankCD and mb.BranchCD = temp_Branch.BranchCD and mb.ChangeDate = temp_Branch.ChangeDate
)


