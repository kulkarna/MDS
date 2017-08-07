USE Libertypower
GO

IF NOT EXISTS (SELECT 1 FROM Libertypower..FileManager WHERE ContextKey = 'TemplateTextFields')
	BEGIN
		DECLARE	@ID	int

		INSERT	INTO Libertypower..FileManager
		SELECT	'TemplateTextFields', 'Pricing Sheet Text', GETDATE(), 3

		SET	@ID = SCOPE_IDENTITY()

		INSERT	INTO Libertypower..ManagerRoot
		SELECT	@ID, '\\lpcftlfs1\InformationTechnology\ManagedFiles\Import\TemplateTextFields\', 1, GETDATE(), 3
	END