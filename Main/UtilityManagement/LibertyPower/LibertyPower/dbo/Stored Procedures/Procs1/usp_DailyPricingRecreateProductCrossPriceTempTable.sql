


/*******************************************************************************
 * usp_DailyPricingRecreateProductCrossPriceTempTable
 * Desc
 *
 * History
 *******************************************************************************
 * 11/4/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingRecreateProductCrossPriceTempTable]

AS
BEGIN

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DailyPricingProductCrossPriceTemp]') AND type in (N'U'))
	DROP TABLE [dbo].[DailyPricingProductCrossPriceTemp]

	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	SET ANSI_PADDING ON

	CREATE TABLE [dbo].[DailyPricingProductCrossPriceTemp](
		[ProductCrossPriceID] [int] IDENTITY(1,1) NOT NULL,
		[ProductCrossPriceSetID] [int] NOT NULL,
		[ProductMarkupRuleID] [int] NOT NULL,
		[ProductCostRuleID] [int] NOT NULL,
		[ProductTypeID] [int] NOT NULL,
		[MarketID] [int] NOT NULL,
		[UtilityID] [int] NOT NULL,
		[SegmentID] [int] NOT NULL,
		[ZoneID] [int] NOT NULL,
		[ServiceClassID] [int] NOT NULL,
		[ChannelTypeID] [int] NOT NULL,
		[ChannelGroupID] [int] NOT NULL,
		[CostRateEffectiveDate] [datetime] NOT NULL,
		[StartDate] [datetime] NOT NULL,
		[Term] [int] NOT NULL,
		[CostRateExpirationDate] [datetime] NOT NULL,
		[MarkupRate] [decimal](18, 10) NOT NULL,
		[CostRate] [decimal](18, 10) NOT NULL,
		[CommissionsRate] [decimal](18, 10) NULL,
		[POR] [decimal](18, 10) NULL,
		[GRT] [decimal](18, 10) NULL,
		[SUT] [decimal](18, 10) NULL,
		[Price] [decimal](18, 10) NOT NULL,
		[CreatedBy] [int] NOT NULL,
		[DateCreated] [datetime] NOT NULL,
		[RateCodeID] [int] NULL
	)ON [PRIMARY]

	SET ANSI_PADDING OFF

END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingRecreateProductCrossPriceTempTable';

