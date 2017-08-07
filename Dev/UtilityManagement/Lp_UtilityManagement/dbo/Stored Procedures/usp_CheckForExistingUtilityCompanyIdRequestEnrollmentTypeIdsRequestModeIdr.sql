
CREATE PROC [dbo].[usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIdsRequestModeIdr]
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN

	SELECT 
		COUNT(RMI.Id)
	FROM 
		RequestModeIdr (NOLOCK) RMI
	WHERE
		RMI.UtilityCompanyId = @UtilityCompanyId
		AND RMI.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	
END

