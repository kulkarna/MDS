USE Libertypower
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProductCrossPrice' AND COLUMN_NAME = 'ProductBrandID')
	BEGIN
		ALTER TABLE ProductCrossPrice
		ADD ProductBrandID int NULL	
	END
	
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProductCrossPrice' AND COLUMN_NAME = 'GreenRate')
	BEGIN
		ALTER TABLE ProductCrossPrice
		ADD GreenRate decimal(18,10) NULL
	END	