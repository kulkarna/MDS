
CREATE PROC [dbo].[usp_RequestModeHistoricalUsage_VALIDATE_RequestModeIcapRequestModeType]
	@UtilityCompanyId AS NVARCHAR(50),
	@RequestModeTypeId AS NVARCHAR(50)
AS
BEGIN

	SELECT
		COUNT(RMHU.ID) AS MatchCount
	FROM
		dbo.RequestModeHistoricalUsage (NOLOCK) RMHU
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMHU.RequestModeEnrollmentTypeId = RMET.Id
		INNER JOIN  dbo.UtilityCompany (NOLOCK) UC
			ON RMHU.UtilityCompanyId = UC.Id
	WHERE
		RMET.Id = '390712C2-AAF9-4B96-96B8-CD12FA33EEF1'
		AND RMHU.RequestModeTypeId <> @RequestModeTypeId
		AND RMHU.UtilityCompanyId = @UtilityCompanyId

END

GO