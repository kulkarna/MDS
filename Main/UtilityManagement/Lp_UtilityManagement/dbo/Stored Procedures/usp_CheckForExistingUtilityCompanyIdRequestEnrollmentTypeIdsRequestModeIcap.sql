CREATE PROC dbo.usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIdsRequestModeIcap
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN

	SELECT 
		COUNT(RMHU.Id)
	FROM 
		RequestModeIcap (NOLOCK) RMHU
	WHERE
		RMHU.UtilityCompanyId = @UtilityCompanyId
		AND RMHU.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	
END

GO