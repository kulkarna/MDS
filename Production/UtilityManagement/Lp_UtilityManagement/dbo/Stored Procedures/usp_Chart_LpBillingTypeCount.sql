CREATE PROC usp_Chart_LpBillingTypeCount
AS
BEGIN

SELECT 
	UC.UtilityCode, COUNT(LBT.ID) AS LpBillingTypeCount
FROM
	dbo.LpBillingType (NOLOCK) LBT
	INNER JOIN dbo.UtilityCompany (NOLOCK) UC
		ON LBT.UtilityCompanyId = UC.id
GROUP BY
	UC.UtilityCode
ORDER BY 
	UC.UtilityCode
	
END