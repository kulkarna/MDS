CREATE TABLE [dbo].[DailyPricingConfiguration] (
    [DailyPricingConfigurationID] INT      IDENTITY (1, 1) NOT NULL,
    [AutoGeneratePrices]          BIT      NOT NULL,
    [AutoGeneratePriceSheets]     BIT      NOT NULL,
    [CreatedBy]                   INT      NOT NULL,
    [DateCreated]                 DATETIME NOT NULL,
    CONSTRAINT [PK_DailyPricingConfiguration] PRIMARY KEY CLUSTERED ([DailyPricingConfigurationID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingConfiguration';

