/*******************************************************************************
 * usp_DailyPricingTemplateConfigurationSelect
 * Gets template configuration data
 *
 * History
 *******************************************************************************
 * 6/17/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 1/3/2013 - Modified - Rick Deigsler
 * Added 2 new columns for promo messages
 *******************************************************************************
 * 3/13/2013 - merged with production version
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, SegmentID, ChannelTypeID, ChannelGroupID, MarketID, UtilityID, HeaderStatement, 
			SizeRequirement, SubmissionStatement, CustomerClassStatement, ProductTaxStatement,
			ConfidentialityStatement, Header, Footer1, Footer2, 
			ISNULL(PromoMessage, '') AS PromoMessage, ISNULL(PromoImageFileGuid, '') AS PromoImageFileGuid
	FROM	DailyPricingTemplateConfiguration WITH (NOLOCK)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingTemplateConfigurationSelect';

