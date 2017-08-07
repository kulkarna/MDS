CREATE PROC [dbo].[usp_Chart_HuUtilitySla]
AS
BEGIN

SELECT
	UC.UtilityCode,
	AVG(ISNULL(RMHU.UtilitysSlaHistoricalUsageResponseInDays,0)) UtilitySla
FROM
	RequestModehistoricalusage (NOLOCK) RMHU
	INNER JOIN UtilityCompany (NOLOCK ) UC
		ON RMHU.UtilityCompanyId = UC.Id
WHERE 
	UC.UtilityIdInt < 15
GROUP BY 
	UC.UtilityCode
ORDER BY 
	AVG(ISNULL(RMHU.UtilitysSlaHistoricalUsageResponseInDays,0)) DESC

END
GO