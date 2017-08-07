CREATE TABLE [dbo].[ProductGreenRule] (
    [ProductGreenRuleID]    INT              IDENTITY (1, 1) NOT NULL,
    [ProductGreenRuleSetID] INT              NOT NULL,
    [SegmentID]             INT              NULL,
    [MarketID]              INT              NULL,
    [UtilityID]             INT              NULL,
    [ServiceClassID]        INT              NULL,
    [ZoneID]                INT              NULL,
    [ProductTypeID]         INT              NULL,
    [ProductBrandID]        INT              NULL,
    [StartDate]             DATETIME         NULL,
    [Term]                  INT              NULL,
    [Rate]                  DECIMAL (18, 10) NULL,
    [CreatedBy]             INT              NOT NULL,
    [DateCreated]           DATETIME         NOT NULL,
    [PriceTier]             TINYINT          NULL,
    CONSTRAINT [PK_ProductGreenRule] PRIMARY KEY CLUSTERED ([ProductGreenRuleID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductGreenRule_ProductGreenRuleSet] FOREIGN KEY ([ProductGreenRuleSetID]) REFERENCES [dbo].[ProductGreenRuleSet] ([ProductGreenRuleSetID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductGreenRule';

