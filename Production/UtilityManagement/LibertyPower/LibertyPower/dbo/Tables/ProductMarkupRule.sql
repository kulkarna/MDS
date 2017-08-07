CREATE TABLE [dbo].[ProductMarkupRule] (
    [ProductMarkupRuleID]    INT              IDENTITY (1, 1) NOT NULL,
    [ProductMarkupRuleSetID] INT              NOT NULL,
    [ChannelTypeID]          INT              NULL,
    [ChannelGroupID]         INT              NULL,
    [SegmentID]              INT              NULL,
    [MarketID]               INT              NULL,
    [UtilityID]              INT              NULL,
    [ServiceClassID]         INT              NULL,
    [ZoneID]                 INT              NULL,
    [ProductTypeID]          INT              NULL,
    [MinTerm]                INT              NULL,
    [MaxTerm]                INT              NULL,
    [Rate]                   DECIMAL (18, 10) NOT NULL,
    [CreatedBy]              INT              NOT NULL,
    [DateCreated]            DATETIME         NOT NULL,
    [PriceTier]              TINYINT          NULL,
    [ProductTerm]            INT              NULL,
    [ProductBrandID]         INT              NULL,
    CONSTRAINT [PK_ProductMarkupRule] PRIMARY KEY CLUSTERED ([ProductMarkupRuleID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ProductMarkupRuleIndex]
    ON [dbo].[ProductMarkupRule]([ProductMarkupRuleSetID] ASC, [ChannelTypeID] ASC, [ChannelGroupID] ASC, [SegmentID] ASC, [MarketID] ASC, [UtilityID] ASC, [ServiceClassID] ASC, [ZoneID] ASC, [ProductTypeID] ASC, [PriceTier] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductMarkupRule';

