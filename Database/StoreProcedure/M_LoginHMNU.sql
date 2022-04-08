 BEGIN TRY 
 Drop PROCEDURE dbo.[M_LoginHMNU]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[M_LoginHMNU]
	-- Add the parameters for the stored procedure here
	@Login_ID as varchar(10)
AS
BEGIN 
	SET NOCOUNT ON;
 select 
 fmd.BusinessID,fmd.BusinessSEQ,m.Char1,mp.ProgramName as ProgramID,mp.ProgramID as ProgramID_ID,
fmd.ProgramSEQ,a.Insertable,a.Updatable,a.Deletable,a.Inquirable,a.Printable,a.Outputable,a.Runable
 from M_menu fm
inner join F_Menu_Details(Getdate()) fmd on fm.MenuID = fmd.MenuID  and fm.DeleteFlg = 0
left join M_Program mp on fmd.ProgramID = mp.ProgramID 
left outer join M_MultiPorpose m on fmd.BusinessID= m.[Key] and m.ID='223' 
inner join		
			
   (select    ProgramID,fad.Insertable,fad.Updatable,
fad.Deletable,fad.Inquirable,fad.Printable,fad.Outputable,fad.Runable from F_Authorizations(getdate()) fa
inner join  F_AuthorizationsDetails(getdate()) fad on fa.AuthorizationsCD =  fad.AuthorizationsCD  
inner join [User] fs on fad.AuthorizationsCD = '001' where Login_ID = @Login_ID ) a 
on fmd.MenuID='001' and mp.ProgramID=a.ProgramID

END