CREATE PROC [dbo].[usp_TariffCode_SELECT_By_UtilityCompanyId]
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN


	SELECT
		[RC].[Id],
		[RC].[TariffCodeCode] AS [Name]
	FROM
		dbo.TariffCode (NOLOCK) RC
	WHERE
		CONVERT(NVARCHAR(50),RC.UtilityCompanyId) = @UtilityCompanyId
END
GO