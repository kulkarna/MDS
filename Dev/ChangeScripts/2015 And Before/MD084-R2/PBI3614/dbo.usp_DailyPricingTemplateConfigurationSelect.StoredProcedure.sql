USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateConfigurationSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateConfigurationSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
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
			ISNULL(PromoMessage, '''') AS PromoMessage, ISNULL(PromoImageFileGuid, '''') AS PromoImageFileGuid
	FROM	DailyPricingTemplateConfiguration WITH (NOLOCK)

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'DailyPricing', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_DailyPricingTemplateConfigurationSelect', NULL, NULL
GO
