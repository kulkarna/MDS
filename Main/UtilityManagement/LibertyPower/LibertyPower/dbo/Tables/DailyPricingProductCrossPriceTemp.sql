CREATE TABLE [dbo].[DailyPricingProductCrossPriceTemp] (
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
    [RateCodeID]             INT              NULL
);


GO
CREATE NONCLUSTERED INDEX [ndx_PriceSelect]
    ON [dbo].[DailyPricingProductCrossPriceTemp]([ProductTypeID] ASC, [MarketID] ASC, [UtilityID] ASC, [SegmentID] ASC, [ZoneID] ASC, [ServiceClassID] ASC, [ChannelTypeID] ASC, [ChannelGroupID] ASC) WITH (FILLFACTOR = 100, PAD_INDEX = ON);

