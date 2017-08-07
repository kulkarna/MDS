USE Libertypower
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProductCostRuleSetup' AND COLUMN_NAME = 'ProductBrandID')
	BEGIN
		ALTER TABLE ProductCostRuleSetup
		ADD ProductBrandID int NULL	
	END
	
UPDATE	ProductCostRuleSetup
SET		ProductBrandID = -1	