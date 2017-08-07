/*******************************************************************************
 * usp_UtilityAccountSchemasSelect
 * Retrieves information about required fields related to parsing an Excel
 * file containing list of accounts for a specific utility.
 *
 * History
 *******************************************************************************
  */
CREATE PROCEDURE usp_UtilityAccountSchemasSelect

AS
	SET NOCOUNT ON;
	
	SELECT
		UtilityAccountSchema.ID,
		UtilityAccountSchema.Context,
		UtilityAccountSchema.UtilityCode,
		UtilityAccountSchemaColumn.FieldName,
		UtilityAccountSchema.IsRequired,
		UtilityAccountSchema.CreatedBy,
		UtilityAccountSchema.DateCreated,
		UtilityAccountSchema.ModifiedBy,
		UtilityAccountSchema.DateModified
		FROM
		UtilityAccountSchema JOIN UtilityAccountSchemaColumn 
		ON 
		UtilityAccountSchema.FieldNameID = UtilityAccountSchemaColumn.ID 
	
	RETURN
