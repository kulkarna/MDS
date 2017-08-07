
CREATE PROC [dbo].[usp_RequestModeType_SELECT_NameById]
@Id NVARCHAR(50)
AS
BEGIN
	SELECT
		[Name]
	FROM 
		dbo.RequestModeType (NOLOCK) RMT
	WHERE
		CONVERT(NVARCHAR(50),RMT.Id) = @Id
END

GO