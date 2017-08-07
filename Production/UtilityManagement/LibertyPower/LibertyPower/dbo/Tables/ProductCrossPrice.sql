CREATE TABLE [dbo].[ProductCrossPrice] (
    [ProductCrossPriceID]    INT              IDENTITY (1, 1) NOT NULL,
    [ProductCrossPriceSetID] INT              NOT NULL,
    [ProductMarkupRuleID]    INT              NOT NULL,
    [ProductCostRuleID]      INT              NOT NULL,
    [ProductTypeID]          INT              NOT NULL,
    [MarketID]               INT              NOT NULL,
    [UtilityID]              INT              NOT NULL,
    [SegmentID]              INT              NOT NULL,
    [ZoneID]                 INT              NOT NULL,
    [ServiceClassID]         INT              NOT NULL,
    [ChannelTypeID]          INT              NOT NULL,
    [ChannelGroupID]         INT              NOT NULL,
    [CostRateEffectiveDate]  DATETIME         NOT NULL,
    [StartDate]              DATETIME         NOT NULL,
    [Term]                   INT              NOT NULL,
    [CostRateExpirationDate] DATETIME         NOT NULL,
    [MarkupRate]             DECIMAL (18, 10) NOT NULL,
    [CostRate]               DECIMAL (18, 10) NOT NULL,
    [CommissionsRate]        DECIMAL (18, 10) NULL,
    [POR]                    DECIMAL (18, 10) NULL,
    [GRT]                    DECIMAL (18, 10) NULL,
    [SUT]                    DECIMAL (18, 10) NULL,
    [Price]                  DECIMAL (18, 10) NOT NULL,
    [CreatedBy]              INT              NOT NULL,
    [DateCreated]            DATETIME         NOT NULL,
    [RateCodeID]             INT              NULL,
    [PriceTier]              TINYINT          NULL,
    [ProductBrandID]         INT              NULL,
    [GreenRate]              DECIMAL (18, 10) NULL,
    CONSTRAINT [PK_ProductCrossPrice2] PRIMARY KEY NONCLUSTERED ([ProductCrossPriceID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductCrossPrice_ProductCrossPriceSet2] FOREIGN KEY ([ProductCrossPriceSetID]) REFERENCES [dbo].[ProductCrossPriceSet] ([ProductCrossPriceSetID])
);


GO
CREATE CLUSTERED INDEX [idx_ProductCrossPriceSetID2]
    ON [dbo].[ProductCrossPrice]([ProductCrossPriceSetID] ASC, [ProductCrossPriceID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ndx_ProductCrossPriceSetIDUtilityIDChannelGroupID2]
    ON [dbo].[ProductCrossPrice]([ProductCrossPriceSetID] ASC, [UtilityID] ASC, [ChannelGroupID] ASC)
    INCLUDE([ProductTypeID], [MarketID], [SegmentID], [ZoneID], [ServiceClassID], [ChannelTypeID]) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCrossPrice';

