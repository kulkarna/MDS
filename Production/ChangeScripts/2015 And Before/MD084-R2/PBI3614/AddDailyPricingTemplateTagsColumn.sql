USE Libertypower
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'DailyPricingTemplateTags'             
	AND		COLUMN_NAME = 'PromoMessage'
) 
	BEGIN
		ALTER TABLE DailyPricingTemplateTags
		ADD PromoMessage varchar(1000)
	END
GO

UPDATE	DailyPricingTemplateTags
SET		PromoMessage = '[promotional_message]'