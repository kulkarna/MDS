

CREATE PROC [dbo].[usp_RequestModeIcap_VALIDATE_RequestModeHistoricalUsageRequestModeType]
	@UtilityCompanyId AS NVARCHAR(50),
	@RequestModeTypeId AS NVARCHAR(50)
AS
BEGIN

	SELECT
		COUNT(RMI.ID) AS MatchCount
	FROM
		dbo.RequestModeIcap (NOLOCK) RMI
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMI.RequestModeEnrollmentTypeId = RMET.Id
		INNER JOIN  dbo.UtilityCompany (NOLOCK) UC
			ON RMI.UtilityCompanyId = UC.Id
	WHERE
		RMET.Id = '390712C2-AAF9-4B96-96B8-CD12FA33EEF1'
		AND RMI.RequestModeTypeId <> @RequestModeTypeId
		AND RMI.UtilityCompanyId = @UtilityCompanyId
END

GO