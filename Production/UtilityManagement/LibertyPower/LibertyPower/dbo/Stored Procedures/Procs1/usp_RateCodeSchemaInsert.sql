
/*******************************************************************************
 * usp_RateCodeSchemaInsert
 * 
 *******************************************************************************
 */

CREATE PROCEDURE usp_RateCodeSchemaInsert
(
	@UtilityCode varchar(128), 
	@FieldName int, 
	@IsColumnRequired bit, 
	@IsValueRequired bit,
	@CreatedBy int
)
AS
	SET NOCOUNT ON;

	DECLARE @ID int;
	
	SET @ID = (SELECT ID from RateCodeSchemaColumn where FieldName = @FieldName)

	IF @ID IS NOT NULL	
		INSERT INTO RateCodeSchema
			(
				UtilityCode,
				FieldNameID, 
				IsColumnRequired, 	
				IsValueRequired,		 
				CreatedBy 
			)
			VALUES
			(
				@UtilityCode,
				@ID,
				@IsColumnRequired,
				@IsValueRequired,
				@CreatedBy
			);


	IF @@ROWCOUNT > 0
	BEGIN

	SELECT
		ID,
		UtilityCode,
		FieldNameID, 
		IsColumnRequired, 	
		IsValueRequired,		 
		CreatedBy

	FROM
		RateCodeSchema
	WHERE
		ID = SCOPE_IDENTITY();
		
	END

	RETURN


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeSchemaInsert';

