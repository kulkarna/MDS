CREATE TABLE [dbo].[Price] (
    [ID]                     BIGINT           IDENTITY (1, 1) NOT NULL,
    [ChannelID]              INT              NOT NULL,
    [ChannelGroupID]         INT              NOT NULL,
    [ChannelTypeID]          INT              NOT NULL,
    [ProductCrossPriceSetID] INT              NOT NULL,
    [ProductTypeID]          INT              NOT NULL,
    [MarketID]               INT              NOT NULL,
    [UtilityID]              INT              NOT NULL,
    [SegmentID]              INT              NOT NULL,
    [ZoneID]                 INT              NOT NULL,
    [ServiceClassID]         INT              NOT NULL,
    [StartDate]              DATETIME         NOT NULL,
    [Term]                   INT              NOT NULL,
    [Price]                  DECIMAL (18, 10) NOT NULL,
    [CostRateEffectiveDate]  DATETIME         NOT NULL,
    [CostRateExpirationDate] DATETIME         NOT NULL,
    [IsTermRange]            TINYINT          NOT NULL,
    [DateCreated]            DATETIME         CONSTRAINT [DF_Price_DateCreated] DEFAULT (getdate()) NOT NULL,
    [PriceTier]              TINYINT          NULL,
    [ProductBrandID]         INT              NULL,
    [GrossMargin]            DECIMAL (18, 10) NULL,
    [ProductCrossPriceID]    INT              NULL,
    CONSTRAINT [PK_Price] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 95)
);


GO
CREATE NONCLUSTERED INDEX [ndx_EffExpDates]
    ON [dbo].[Price]([CostRateEffectiveDate] ASC, [CostRateExpirationDate] ASC, [ChannelID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [Price__Cover1]
    ON [dbo].[Price]([ChannelID] ASC, [CostRateEffectiveDate] ASC, [CostRateExpirationDate] ASC)
    INCLUDE([ProductCrossPriceSetID]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [Price__Cover3]
    ON [dbo].[Price]([ChannelID] ASC, [ProductCrossPriceSetID] ASC)
    INCLUDE([ProductTypeID], [UtilityID], [MarketID], [SegmentID], [ZoneID], [ServiceClassID], [PriceTier], [CostRateEffectiveDate], [CostRateExpirationDate], [ProductBrandID]) WITH (FILLFACTOR = 90);

