CREATE PROC [dbo].[usp_Chart_HuLpSla]
AS
BEGIN

SELECT
	UC.UtilityCode,
	AVG(ISNULL(RMHU.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays,0)) LpSla
FROM
	RequestModehistoricalusage (NOLOCK) RMHU
	INNER JOIN UtilityCompany (NOLOCK ) UC
		ON RMHU.UtilityCompanyId = UC.Id
WHERE 
	UC.UtilityIdInt < 15
GROUP BY 
	UC.UtilityCode
ORDER BY 
	UC.UtilityCode

END
GO
