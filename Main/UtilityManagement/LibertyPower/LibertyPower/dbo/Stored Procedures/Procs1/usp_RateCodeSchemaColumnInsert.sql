
/*******************************************************************************
 * usp_RateCodeSchemaColumnInsert
 * 
 *******************************************************************************
 */

CREATE PROCEDURE usp_RateCodeSchemaColumnInsert
(
	@FieldName varchar(128), 
	@CreatedBy int 
)
AS
	SET NOCOUNT ON;

	DECLARE @ID int;
	
	INSERT INTO RateCodeSchemaColumn
		(
			FieldName,
			CreatedBy
		)
		VALUES
		(
			@FieldName, 
			@CreatedBy
		);

	IF @@ROWCOUNT > 0
	BEGIN

		SELECT
			ID,
			FieldName,
			CreatedBy,
			DateCreated,
			ModifiedBy,
			DateModified			
		FROM
			RateCodeSchemaColumn
		WHERE
			ID = SCOPE_IDENTITY();
		
	END

	RETURN


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeSchemaColumnInsert';

