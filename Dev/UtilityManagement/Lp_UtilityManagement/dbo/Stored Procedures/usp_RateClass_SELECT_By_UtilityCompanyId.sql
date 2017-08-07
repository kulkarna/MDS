CREATE PROC [dbo].[usp_RateClass_SELECT_By_UtilityCompanyId]
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN


	SELECT
		[RC].[Id],
		[RC].[RateClassCode] AS [Name]
	FROM
		dbo.RateClass (NOLOCK) RC
	WHERE
		CONVERT(NVARCHAR(50),RC.UtilityCompanyId) = @UtilityCompanyId


END
