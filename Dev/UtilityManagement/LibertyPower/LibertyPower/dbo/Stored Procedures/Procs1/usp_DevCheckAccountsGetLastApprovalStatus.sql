
-- EXEC  [usp_DevCheckAccountsGetLastApprovalStatus] '0785244'
CREATE PROCEDURE [dbo].[usp_DevCheckAccountsGetLastApprovalStatus]
	@contract_nbr VARCHAR(20) 
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	

	SELECT TOP(1) contract_nbr,check_type,approval_status, C.date_created
	FROM lp_enrollment..check_account C (NOLOCK) 
	JOIN 
		(select MAX(date_created) as date_created
		FROM lp_enrollment..check_account (NOLOCK)
		WHERE LTRIM(RTRIM(contract_nbr)) =  @contract_nbr -- '0785244'
		) Z ON Z.date_created = C.date_created
	WHERE    LTRIM(RTRIM(contract_nbr)) = @contract_nbr -- '0785244'



END	
