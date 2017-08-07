
CREATE PROC [dbo].[usp_RequestModeEnrollmentType_SELECT_NameById]
@Id NVARCHAR(50)
AS
BEGIN
	SELECT
		[Name]
	FROM
		dbo.RequestModeEnrollmentType (NOLOCK) RMET
	WHERE
		CONVERT(NVARCHAR(50),RMET.Id) = @Id
END
