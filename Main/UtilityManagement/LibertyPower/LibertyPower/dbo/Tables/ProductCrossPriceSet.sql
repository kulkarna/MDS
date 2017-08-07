CREATE TABLE [dbo].[ProductCrossPriceSet] (
    [ProductCrossPriceSetID] INT      IDENTITY (1, 1) NOT NULL,
    [EffectiveDate]          DATETIME NOT NULL,
    [ExpirationDate]         DATETIME NOT NULL,
    [CreatedBy]              INT      NOT NULL,
    [DateCreated]            DATETIME NOT NULL,
    CONSTRAINT [PK_ProductCrossPriceSet] PRIMARY KEY CLUSTERED ([ProductCrossPriceSetID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCrossPriceSet';

