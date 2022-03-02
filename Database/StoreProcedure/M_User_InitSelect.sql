BEGIN TRY 
	Drop Procedure dbo.[M_User_InitSelect]
END TRY
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [M_User_InitSelect]    */

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[M_User_InitSelect]
	-- Add the parameters for the stored procedure here
	@UserID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		  ID
		, User_Name
		, Login_ID
		, Password
		, Status
		, Created_Date
		, UPdated_Date
		, ISAdmin
		, CONVERT(VARCHAR,GETDATE(),111) sysDate
	FROM  [User] 
	WHERE Login_ID = @UserID
	;
	
END


