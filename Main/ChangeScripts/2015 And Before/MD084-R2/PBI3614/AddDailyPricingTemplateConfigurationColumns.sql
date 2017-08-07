USE Libertypower
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'DailyPricingTemplateConfiguration'             
	AND		COLUMN_NAME = 'PromoMessage'
) 
	BEGIN
		ALTER TABLE DailyPricingTemplateConfiguration
		ADD PromoMessage varchar(1000)
	END

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'DailyPricingTemplateConfiguration'             
	AND		COLUMN_NAME = 'PromoImageFileGuid'
) 
	BEGIN
		ALTER TABLE DailyPricingTemplateConfiguration
		ADD PromoImageFileGuid varchar(100)
	END