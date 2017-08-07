

CREATE PROC [dbo].[usp_DataSync_ServiceLevelAgreements_GetByLastModifiedDate]
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN

	DECLARE @RequestModeEnrollmentTypeId AS UNIQUEIDENTIFIER
	SELECT
		@RequestModeEnrollmentTypeId = ID
	FROM
		dbo.RequestModeEnrollmentType (NOLOCK) RMET
	WHERE
		EnumValue = 0

	SELECT 
		UC.[UtilityIdInt] AS UtilityId
		,RMHU.UtilitysSlaHistoricalUsageResponseInDays UtilitySlaHistoricalUsageResponseInDays
		,RMHU.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays LibertyPowerSlaFollowUpHistoricalUsageResponseInDays
		,RMIC.UtilitysSlaIcapResponseInDays UtilitySlaIcapResponseInDays
		,RMIC.LibertyPowersSlaFollowUpIcapResponseInDays LibertyPowerSlaFollowUpIcapResponseInDays
		,RMID.UtilitysSlaIdrResponseInDays UtilitySlaIdrResponseInDays
		,RMID.LibertyPowersSlaFollowUpIdrResponseInDays LibertyPowerSlaFollowUpIdrResponseInDays
		,GETDATE() AS LastModifiedDate
	FROM 
		[dbo].[UtilityCompany] (NOLOCK) UC
		LEFT OUTER JOIN [dbo].[RequestModeHistoricalUsage] (NOLOCK) RMHU
			ON UC.Id = RMHU.UtilityCompanyId
			AND RMHU.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
		LEFT OUTER JOIN [dbo].[RequestModeIcap] (NOLOCK) RMIC
			ON UC.Id = RMIC.UtilityCompanyId
			AND RMIC.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
		LEFT OUTER JOIN [dbo].[RequestModeIdr] (NOLOCK) RMID
			ON UC.Id = RMID.UtilityCompanyId
			AND RMID.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	WHERE
		(DATEDIFF(S, RMHU.[LastModifiedDate], @BeginDate) <= 0 AND DATEDIFF(S, RMHU.[LastModifiedDate], @EndDate) > 0)
		OR (DATEDIFF(S, RMIC.[LastModifiedDate], @BeginDate) <= 0 AND DATEDIFF(S, RMIC.[LastModifiedDate], @EndDate) > 0)
		OR (DATEDIFF(S, RMID.[LastModifiedDate], @BeginDate) <= 0  AND DATEDIFF(S, RMID.[LastModifiedDate], @EndDate) > 0)

				
END