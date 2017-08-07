USE Libertypower
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'Price'             
	AND		COLUMN_NAME = 'ProductCrossPriceID'
) 
	BEGIN
		ALTER TABLE Price
		ADD ProductCrossPriceID int
	END