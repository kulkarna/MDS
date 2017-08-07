
CREATE PROC [dbo].[usp_MeterType_SELECT_By_UtilityCompanyId]
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN


	SELECT
		[RC].[Id],
		[RC].[MeterTypeCode] AS [Name]
	FROM
		dbo.MeterType (NOLOCK) RC
	WHERE
		CONVERT(NVARCHAR(50),RC.UtilityCompanyId) = @UtilityCompanyId


END
