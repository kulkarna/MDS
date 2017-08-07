USE LibertyPower
GO
-- =============================================
-- Author:		Rafael Vasconcelos
-- Create date: 5/15/2012
-- Description:	Gets a new account id calling one stored procedure that already exists in lp_account
--				Used for the Gridview in send_do_not_enroll_account.aspx (Enrollment app)
-- =============================================
CREATE PROCEDURE usp_GetNewAccountID
	@UserName NCHAR(100)
AS 
BEGIN

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @p_new_account_id nvarchar(12)

exec lp_deal_capture..usp_get_key 
@p_username=@UserName,
@p_process_id=N'ACCOUNT ID',
@p_unickey=@p_new_account_id output,
@p_result_ind=N'N'
select @p_new_account_id

END