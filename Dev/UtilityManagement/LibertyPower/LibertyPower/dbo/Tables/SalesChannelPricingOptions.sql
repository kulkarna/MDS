CREATE TABLE [dbo].[SalesChannelPricingOptions] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [ChannelID]           INT             NOT NULL,
    [EnableTieredPricing] TINYINT         CONSTRAINT [DF_SalesChannelPricingOptions_EnableTieredPricing] DEFAULT ((1)) NOT NULL,
    [QuoteTolerance]      DECIMAL (12, 6) CONSTRAINT [DF_SalesChannelPricingOptions_QuoteTolerance] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SalesChannelPricingOptions] PRIMARY KEY CLUSTERED ([ID] ASC)
);

