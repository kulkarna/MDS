
CREATE PROCEDURE [dbo].[usp_EmailAddressInsert]
	@EmailAddress varchar(100)
	,@DisplayName varchar(100)
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [EmailAddress]
		([EmailAddress]
		,[DisplayName])
	VALUES
		(@EmailAddress
		,@DisplayName)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END

