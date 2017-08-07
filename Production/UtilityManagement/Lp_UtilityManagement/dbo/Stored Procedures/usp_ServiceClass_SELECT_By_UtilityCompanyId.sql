
CREATE PROC [dbo].[usp_ServiceClass_SELECT_By_UtilityCompanyId]
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN


	SELECT
		[RC].[Id],
		[RC].[ServiceClassCode] AS [Name]
	FROM
		dbo.ServiceClass (NOLOCK) RC
	WHERE
		CONVERT(NVARCHAR(50),RC.UtilityCompanyId) = @UtilityCompanyId


END
