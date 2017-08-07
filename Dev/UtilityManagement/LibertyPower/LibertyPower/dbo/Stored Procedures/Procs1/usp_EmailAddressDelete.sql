
CREATE PROCEDURE [dbo].[usp_EmailAddressDelete]
	@EmailAddressID int
AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [EmailAddress]
		WHERE [EmailAddressID] = @EmailAddressID

	SET NOCOUNT OFF;

END

