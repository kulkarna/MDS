USE Libertypower
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'ProductMarkupRule'             
	AND		COLUMN_NAME = 'ProductTerm'
) 
	BEGIN
		ALTER TABLE ProductMarkupRule
		ADD ProductTerm int
	END
	
IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'ProductMarkupRuleRaw'             
	AND		COLUMN_NAME = 'ProductTerm'
) 
	BEGIN
		ALTER TABLE ProductMarkupRuleRaw
		ADD ProductTerm int
	END	