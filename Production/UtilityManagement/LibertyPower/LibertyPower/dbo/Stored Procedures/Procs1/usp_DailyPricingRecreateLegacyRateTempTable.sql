


/*******************************************************************************
 * usp_DailyPricingRecreateLegacyRateTempTable
 * Desc
 *
 * History
 *******************************************************************************
 * 11/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingRecreateLegacyRateTempTable]

AS
BEGIN

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DailyPricingLegacyRatesTemp]') AND type in (N'U'))
	DROP TABLE [dbo].[DailyPricingLegacyRatesTemp]


	/****** Object:  Table [dbo].[DailyPricingLegacyRatesTemp]    Script Date: 11/03/2011 11:49:32 ******/
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	SET ANSI_PADDING ON

	CREATE TABLE [dbo].[DailyPricingLegacyRatesTemp](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[ProductID] [varchar](20) NULL,
		[RateID] [int] NULL,
		[MarketID] [int] NULL,
		[UtilityID] [int] NULL,
		[ZoneID] [int] NULL,
		[ServiceClassID] [int] NULL,
		[ChannelGroupID] [int] NULL,
		[Term] [int] NULL,
		[AccountTypeID] [int] NULL,
		[ChannelTypeID] [int] NULL,
		[ProductTypeID] [int] NULL,
		[RateDesc] [varchar](250) NULL,
		[DueDate] [datetime] NULL,
		[ContractEffStartDate] [datetime] NULL,
		[TermMonths] [int] NULL,
		[Rate] [decimal](12, 0) NULL,
		[IsTermRange] [tinyint] NULL
	) ON [PRIMARY]

	SET ANSI_PADDING OFF

END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingRecreateLegacyRateTempTable';

