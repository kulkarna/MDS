
CREATE PROC [dbo].[usp_LoadProfile_SELECT_By_UtilityCompanyId]
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN


	SELECT
		[RC].[Id],
		[RC].[LoadProfileCode] AS [Name]
	FROM
		dbo.LoadProfile (NOLOCK) RC
	WHERE
		CONVERT(NVARCHAR(50),RC.UtilityCompanyId) = @UtilityCompanyId


END
