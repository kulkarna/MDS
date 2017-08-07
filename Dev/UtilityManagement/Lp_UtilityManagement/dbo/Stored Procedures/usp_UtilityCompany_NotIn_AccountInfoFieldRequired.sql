
CREATE PROC [dbo].[usp_UtilityCompany_NotIn_AccountInfoFieldRequired]
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

