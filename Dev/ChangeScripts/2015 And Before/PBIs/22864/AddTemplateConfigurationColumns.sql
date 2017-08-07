USE LibertyPower
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DailyPricingTemplateConfiguration' AND COLUMN_NAME = 'ProductTypeID')
	BEGIN
		ALTER TABLE DailyPricingTemplateConfiguration
		ADD ProductTypeID int NULL	
	END
	
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DailyPricingTemplateConfiguration' AND COLUMN_NAME = 'ProductBrandID')
	BEGIN
		ALTER TABLE DailyPricingTemplateConfiguration
		ADD ProductBrandID int NULL	
	END	
GO

UPDATE	DailyPricingTemplateConfiguration
SET		ProductTypeID	= -1,
		ProductBrandID	= -1