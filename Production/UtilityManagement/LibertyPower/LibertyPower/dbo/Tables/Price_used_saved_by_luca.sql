CREATE TABLE [dbo].[Price_used_saved_by_luca] (
    [ID]                     BIGINT           NOT NULL,
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
    [DateCreated]            DATETIME         NOT NULL,
    [PriceTier]              TINYINT          NULL,
    [ProductBrandID]         INT              NULL,
    [GrossMargin]            DECIMAL (18, 10) NULL
);

