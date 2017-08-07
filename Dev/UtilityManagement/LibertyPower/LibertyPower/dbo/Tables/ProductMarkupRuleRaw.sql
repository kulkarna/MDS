CREATE TABLE [dbo].[ProductMarkupRuleRaw] (
    [ProductMarkupRuleRawID] INT              IDENTITY (1, 1) NOT NULL,
    [ProductMarkupRuleSetID] INT              NOT NULL,
    [ChannelType]            VARCHAR (50)     NULL,
    [MarketCode]             VARCHAR (50)     NULL,
    [UtilityCode]            VARCHAR (50)     NULL,
    [ChannelGroup]           VARCHAR (50)     NULL,
    [Segment]                VARCHAR (50)     NULL,
    [Product]                VARCHAR (50)     NULL,
    [Zone]                   VARCHAR (50)     NULL,
    [UtilityServiceClass]    VARCHAR (50)     NULL,
    [MinTerm]                INT              NULL,
    [MaxTerm]                INT              NULL,
    [Rate]                   DECIMAL (18, 10) NOT NULL,
    [CreatedBy]              INT              NOT NULL,
    [CreatedDate]            DATETIME         NOT NULL,
    [PriceTier]              TINYINT          NULL,
    [ProductTerm]            INT              NULL,
    [ProductBrandID]         INT              NULL,
    CONSTRAINT [PK_ProductMarkupRuleRaw] PRIMARY KEY CLUSTERED ([ProductMarkupRuleRawID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [productmarkupruleraw__ProductMarkupRuleSetID]
    ON [dbo].[ProductMarkupRuleRaw]([ProductMarkupRuleSetID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductMarkupRuleRaw';

