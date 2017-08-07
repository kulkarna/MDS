
CREATE PROCEDURE [dbo].[usp_EmailTemplateDelete]
	@EmailTemplateID int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [EmailTemplate]
		WHERE EmailTemplateID = @EmailTemplateID
		
	SET NOCOUNT OFF;

END

