CREATE TABLE [dbo].[ProductConfigurationPrices] (
    [ID]                     BIGINT IDENTITY (1, 1) NOT NULL,
    [ProductConfigurationID] INT    NOT NULL,
    [PriceID]                BIGINT NOT NULL,
    CONSTRAINT [PK_ProductConfigurationPrices] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ProductConfigurationPrices__PriceID_I_ProductConfigurationID]
    ON [dbo].[ProductConfigurationPrices]([PriceID] ASC)
    INCLUDE([ProductConfigurationID]);

