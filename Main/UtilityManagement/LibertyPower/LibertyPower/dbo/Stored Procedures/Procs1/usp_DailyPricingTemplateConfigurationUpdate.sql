/*******************************************************************************
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
	@PromoImageFileGuid			varchar(100)
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
					PromoImageFileGuid			= @PromoImageFileGuid
			WHERE	SegmentID					= @SegmentID
					AND		ChannelTypeID		= @ChannelTypeID
					AND		ChannelGroupID		= @ChannelGroupID
					AND		MarketID			= @MarketID
					AND		UtilityID			= @UtilityID					
		END
	ELSE
		BEGIN
			INSERT INTO	DailyPricingTemplateConfiguration (SegmentID, ChannelTypeID, 
						ChannelGroupID, MarketID, UtilityID, HeaderStatement, SizeRequirement, 
						SubmissionStatement, CustomerClassStatement, ProductTaxStatement,
						ConfidentialityStatement, Header, Footer1, Footer2, PromoMessage, PromoImageFileGuid)
			VALUES		(@SegmentID, @ChannelTypeID, @ChannelGroupID, @MarketID, @UtilityID, @HeaderStatement, 
						@SizeRequirement, @SubmissionStatement, @CustomerClassStatement, @ProductTaxStatement,
						@ConfidentialityStatement, @Header, @Footer1, @Footer2, @PromoMessage, @PromoImageFileGuid)
		END

	SELECT SegmentID, ChannelTypeID, ChannelGroupID, MarketID, UtilityID, HeaderStatement,
	SizeRequirement, SubmissionStatement, CustomerClassStatement, ProductTaxStatement,
	ConfidentialityStatement, Header, Footer1, Footer2, PromoMessage, PromoImageFileGuid
	FROM DailyPricingTemplateConfiguration WITH (NOLOCK)
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingTemplateConfigurationUpdate';

