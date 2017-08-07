CREATE PROC usp_UtilityCompany_NotInAccountInfoFieldRequired
AS
BEGIN

	SELECT 
		* 
	FROM 
		UtilityCompany (NOLOCK) UC 
	WHERE 
		ID NOT IN (SELECT DISTINCT UtilityCompanyId FROM AccountInfoFieldRequired (NOLOCK))
	ORDER 
		BY UC.UtilityCode

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_UtilityCompany_NotInAccountInfoFieldRequired] TO [LibertyPowerUtilityManagementUser]
    AS [dbo];

