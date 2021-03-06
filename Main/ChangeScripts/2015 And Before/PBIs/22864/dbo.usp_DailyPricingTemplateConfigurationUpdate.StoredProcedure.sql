USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingTemplateConfigurationUpdate]    Script Date: 10/14/2013 15:55:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingTemplateConfigurationUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_DailyPricingTemplateConfigurationUpdate
 * Updates template text field data
 *
 * History
 *******************************************************************************
 * 7/20/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 1/3/2013 - Modified - Rick Deigsler
 * Added 2 new columns for promo messages
 *******************************************************************************
 * 3/13/2013 - merged with production version by Lev Rosenblum 
 *******************************************************************************
 * 10/14/2013 - Modified - Rick Deigsler
 * Added 2 parameters
 ******************************************************************************* 
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingTemplateConfigurationUpdate]
	@SegmentID					int,
	@ChannelTypeID				int,
	@ChannelGroupID				int,
	@MarketID					int,
	@UtilityID					int,
	@HeaderStatement			varchar(1000),
	@SizeRequirement			varchar(500),
	@SubmissionStatement		varchar(1000),
	@CustomerClassStatement		varchar(1000),
	@ProductTaxStatement		varchar(500),
	@ConfidentialityStatement	varchar(1000),
	@Header						varchar(1000),
	@Footer1					varchar(1000),
	@Footer2					varchar(1000),
	@PromoMessage				varchar(1000),
	@PromoImageFileGuid			varchar(100),
	@ProductTypeID				int,
	@ProductBrandID				int
AS
BEGIN
    SET NOCOUNT ON;

	IF EXISTS (	SELECT	NULL
				FROM	DailyPricingTemplateConfiguration WITH (NOLOCK)
				WHERE	SegmentID		= @SegmentID
				AND		ChannelTypeID	= @ChannelTypeID
				AND		ChannelGroupID	= @ChannelGroupID
				AND		MarketID		= @MarketID
				AND		UtilityID		= @UtilityID
				AND		ProductTypeID	= @ProductTypeID
				AND		ProductBrandID	= @ProductBrandID
			  )
		BEGIN
			UPDATE	DailyPricingTemplateConfiguration
			SET		SegmentID					= @SegmentID,
					ChannelTypeID				= @ChannelTypeID,
					ChannelGroupID				= @ChannelGroupID,
					MarketID					= @MarketID,
					UtilityID					= @UtilityID,
					HeaderStatement				= @HeaderStatement,
					SizeRequirement				= @SizeRequirement,
					SubmissionStatement			= @SubmissionStatement,
					CustomerClassStatement		= @CustomerClassStatement,
					ProductTaxStatement			= @ProductTaxStatement,
					ConfidentialityStatement	= @ConfidentialityStatement,
					Header						= @Header,
					Footer1						= @Footer1,
					Footer2						= @Footer2,
					PromoMessage				= @PromoMessage,
					PromoImageFileGuid			= @PromoImageFileGuid,
					ProductTypeID				= @ProductTypeID,
					ProductBrandID				= @ProductBrandID
			WHERE	SegmentID					= @SegmentID
					AND		ChannelTypeID		= @ChannelTypeID
					AND		ChannelGroupID		= @ChannelGroupID
					AND		MarketID			= @MarketID
					AND		UtilityID			= @UtilityID	
					AND		ProductTypeID		= @ProductTypeID
					AND		ProductBrandID		= @ProductBrandID									
		END
	ELSE
		BEGIN
			INSERT INTO	DailyPricingTemplateConfiguration (SegmentID, ChannelTypeID, 
						ChannelGroupID, MarketID, UtilityID, HeaderStatement, SizeRequirement, 
						SubmissionStatement, CustomerClassStatement, ProductTaxStatement,
						ConfidentialityStatement, Header, Footer1, Footer2, PromoMessage, PromoImageFileGuid,
						ProductTypeID, ProductBrandID)
			VALUES		(@SegmentID, @ChannelTypeID, @ChannelGroupID, @MarketID, @UtilityID, @HeaderStatement, 
						@SizeRequirement, @SubmissionStatement, @CustomerClassStatement, @ProductTaxStatement,
						@ConfidentialityStatement, @Header, @Footer1, @Footer2, @PromoMessage, @PromoImageFileGuid,
						@ProductTypeID, @ProductBrandID)
		END
		
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'VirtualFolder_Path' , N'SCHEMA',N'dbo', N'PROCEDURE',N'usp_DailyPricingTemplateConfigurationUpdate', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'DailyPricing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_DailyPricingTemplateConfigurationUpdate'
GO
