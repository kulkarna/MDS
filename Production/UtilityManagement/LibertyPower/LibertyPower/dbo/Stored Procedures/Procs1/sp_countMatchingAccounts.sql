CREATE PROCEDURE dbo.sp_countMatchingAccounts (
	@accountNumber varchar(30) = 0) AS 
BEGIN 
	SET NOCOUNT ON;

	SELECT 
		COUNT(*) AS total
	FROM 
		lp_account..account AS a with (nolock)
	WHERE 
		 a.account_type<>'RESIDENTIAL' 
	AND (a.status='905000' OR a.status='906000') 
	AND  a.account_number=@accountNumber;
END;
