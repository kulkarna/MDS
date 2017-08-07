CREATE TABLE [dbo].[ProductCrossPrice_stage] (
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
    [PriceTier]              TINYINT          NULL
);


GO
CREATE CLUSTERED INDEX [IX_ProductCrossPrice_stage_CreateDate]
    ON [dbo].[ProductCrossPrice_stage]([DateCreated] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_ProductCrossPrice_stage_SetId]
    ON [dbo].[ProductCrossPrice_stage]([ProductCrossPriceSetID] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCrossPrice_stage';

