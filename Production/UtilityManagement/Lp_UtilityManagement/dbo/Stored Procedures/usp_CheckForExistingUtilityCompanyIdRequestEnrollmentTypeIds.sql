CREATE PROC [dbo].[usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds]
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN

	SELECT 
		COUNT(RMHU.Id) AS CountOfId
	FROM 
		RequestModeHistoricalUsage (NOLOCK) RMHU
	WHERE
		CONVERT(NVARCHAR(50), RMHU.UtilityCompanyId) = @UtilityCompanyId
		AND CONVERT(NVARCHAR(50), RMHU.RequestModeEnrollmentTypeId) = @RequestModeEnrollmentTypeId

END
GO