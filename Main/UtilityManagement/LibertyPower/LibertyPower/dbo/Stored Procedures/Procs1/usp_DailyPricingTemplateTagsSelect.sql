/*******************************************************************************
 * usp_DailyPricingTemplateTagsSelect
 * Gets template tag data
 *
 * History
 *******************************************************************************
 * 7/20/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 3/13/2013 - merged with production version by Lev Rosenblum
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingTemplateTagsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ID, SheetTemplate, SheetName, HeaderTag, Footer1Tag, Footer2Tag, ExpirationTag, 
			HeaderStatementTag, SubmissionStatementTag, CustomerClassStatementTag, 
			ProductTaxStatementTag, ConfidentialityStatementTag, SizeRequirementTag, MarketTag, 
			UtilityTag, SegmentTag, ChannelTypeTag, ZoneTag, ServiceClassTag, StartDateTag, 
			TermTag, PriceTag, SalesChannelTag, DateTimeTag, WorkbookAllowEditing, WorkbookPassword, PromoMessage
	  FROM	LibertyPower..DailyPricingTemplateTags WITH (NOLOCK)    


    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingTemplateTagsSelect';

