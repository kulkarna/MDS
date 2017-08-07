
CREATE PROCEDURE [dbo].[usp_EmailAddressUpdate]
	@EmailAddressID int
	,@EmailAddress varchar(100)
	,@DisplayName varchar(100)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [EmailAddress]
		SET [EmailAddress] = @EmailAddress
		,[DisplayName] = @DisplayName
	WHERE [EmailAddressID] = @EmailAddressID

	SET NOCOUNT OFF;

END

