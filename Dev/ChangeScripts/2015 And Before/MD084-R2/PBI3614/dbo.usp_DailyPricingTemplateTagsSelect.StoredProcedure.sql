USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateTagsSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateTagsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DailyPricingTemplateTagsSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateTagsSelect]    Script Date: 1/4/2013 11:15:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateTagsSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
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
' 
END
GO
EXEC sp_addextendedproperty N'VirtualFolder_Path', N'DailyPricing', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_DailyPricingTemplateTagsSelect', NULL, NULL
GO