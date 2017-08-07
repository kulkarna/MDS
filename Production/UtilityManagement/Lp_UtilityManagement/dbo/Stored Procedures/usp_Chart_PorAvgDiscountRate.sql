
CREATE PROC dbo.usp_Chart_PorAvgDiscountRate
AS 
BEGIN
SELECT
	UC.UtilityCode,
	AVG(ISNULL(POR.PorDiscountRate,0)) AvgPorDiscountRate
FROM
	PurchaseOfReceivables (NOLOCK) POR
	INNER JOIN UtilityCompany (NOLOCK ) UC
		ON POR.UtilityCompanyId = UC.Id
GROUP BY 
	UC.UtilityCode
ORDER BY 
	UC.UtilityCode

END