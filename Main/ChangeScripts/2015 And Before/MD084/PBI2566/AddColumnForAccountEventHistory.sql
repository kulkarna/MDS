USE Libertypower
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'AccountEventHistory'             
	AND		COLUMN_NAME = 'ProductTypeID'
) 
	BEGIN
		ALTER TABLE AccountEventHistory
		ADD ProductTypeID int
	END