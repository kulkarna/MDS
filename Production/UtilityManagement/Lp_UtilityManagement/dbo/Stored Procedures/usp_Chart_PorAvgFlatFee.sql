CREATE PROC dbo.usp_Chart_PorAvgFlatFee
AS 
BEGIN
SELECT
	UC.UtilityCode,
	AVG(ISNULL(POR.PorFlatFee,0)) AvgPorFlatFee
FROM
	PurchaseOfReceivables (NOLOCK) POR
	INNER JOIN UtilityCompany (NOLOCK ) UC
		ON POR.UtilityCompanyId = UC.Id
GROUP BY 
	UC.UtilityCode
ORDER BY 
	UC.UtilityCode

END