USE lp_transactions
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'EdiAccount'             
	AND		COLUMN_NAME = 'IcapEffectiveDate'
) 
	BEGIN
		ALTER TABLE dbo.EdiAccount
		ADD IcapEffectiveDate datetime NULL
	END
	
IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'EdiAccount'             
	AND		COLUMN_NAME = 'TcapEffectiveDate'
) 
	BEGIN
		ALTER TABLE dbo.EdiAccount
		ADD TcapEffectiveDate datetime NULL
	END	