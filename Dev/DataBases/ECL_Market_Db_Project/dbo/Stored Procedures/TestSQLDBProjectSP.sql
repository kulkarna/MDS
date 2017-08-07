CREATE PROCEDURE [dbo].[TestSQLDBProjectSP]
AS
	SELECT top 10 * from FileImport  with(nolock)

