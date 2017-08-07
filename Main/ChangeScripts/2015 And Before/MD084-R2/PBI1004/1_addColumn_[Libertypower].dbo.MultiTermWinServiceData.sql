USE [Libertypower]
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'MultiTermWinServiceData'             
	AND		COLUMN_NAME = 'ReenrollmentFollowingMeterDate'
) 
	BEGIN
		ALTER TABLE dbo.MultiTermWinServiceData
		ADD ReenrollmentFollowingMeterDate DateTime Null;
	END
GO 