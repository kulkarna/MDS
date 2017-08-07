CREATE PROC usp_TEST_SELECT_RequestModeHistoricalUsage_BY_EnrollmentTypeAndUtility
	@RequestModeEnrollmentTypeId AS NVARCHAR(50),
	@UtilityCompanyId AS NVARCHAR(50),
	@UtilityLegacyId AS INT,
	@UtilityCode AS NVARCHAR(50)

AS
BEGIN
--SELECT * FROM RequestModeHistoricalUsage
--SET @RequestModeEnrollmentTypeId = '65325E2F-6FC4-4DB1-A1B7-28BBB1A606B9'
--SET @UtilityCompanyId = '3BA9F09B-972B-4C10-8435-1BAA0989C042'
--SET @UtilityLegacyId = 22
--DECLARE @UtilityCode AS NVARCHAR(50)

SELECT
	COUNT(RMHU.Id)
FROM
	dbo.RequestModeHistoricalUsage (NOLOCK) RMHU
	INNER JOIN dbo.UtilityCompanyToUtilityLegacy (NOLOCK) U2U
		ON RMHU.UtilityCompanyId = U2U.UtilityCompanyId
	LEFT OUTER JOIN dbo.UtilityLegacy (NOLOCK) UL
		ON U2U.UtilityLegacyId = UL.ID
	LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC
		ON U2U.UtilityCompanyId= UC.Id
WHERE
	RMHU.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	AND 
	(
		(UL.ID IS NOT NULL AND UL.ID <> 0 AND U2U.UtilityLegacyId = @UtilityLegacyId)
		OR U2U.UtilityCompanyId = @UtilityCompanyId
		OR (UC.UtilityCode IS NOT NULL AND UC.UtilityCode <> '' AND UC.UtilityCode = @UtilityCode)
	)
	
END