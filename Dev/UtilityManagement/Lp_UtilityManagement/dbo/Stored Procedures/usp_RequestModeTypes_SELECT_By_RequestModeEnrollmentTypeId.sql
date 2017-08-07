CREATE PROC [dbo].[usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId]
@RequestModeEnrollmentTypeId NVARCHAR(50)
AS
BEGIN
	SELECT
		[RMT].[Id],
		[RMT].[Name]
	FROM
		dbo.RequestModeType (NOLOCK) RMT
		INNER JOIN dbo.RequestModeTypeToRequestModeEnrollmentType (NOLOCK) RMT2RMET
			ON RMT.Id = RMT2RMET.RequestModeTypeId
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMT2RMET.RequestModeEnrollmentTypeId = RMET.Id
	WHERE
		CONVERT(NVARCHAR(50),RMET.Id) = @RequestModeEnrollmentTypeId
END


GO