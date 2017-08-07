CREATE PROC usp_Chart_PorCount
AS
BEGIN

SELECT
	UC.UtilityCode,
	COUNT(POR.Id) PorCount
FROM
	PurchaseOfReceivables (NOLOCK) POR
	INNER JOIN UtilityCompany (NOLOCK ) UC
		ON POR.UtilityCompanyId = UC.Id
GROUP BY 
	UC.UtilityCode
ORDER BY 
	UC.UtilityCode

END
GO
