CREATE TABLE [dbo].[ProductCostRule] (
    [ProductCostRuleID]    INT              IDENTITY (1, 1) NOT NULL,
    [ProductCostRuleSetID] INT              NOT NULL,
    [CustomerTypeID]       INT              NULL,
    [MarketID]             INT              NULL,
    [UtilityID]            INT              NULL,
    [ServiceClassID]       INT              NULL,
    [ZoneID]               INT              NULL,
    [ProductTypeID]        INT              NULL,
    [StartDate]            DATETIME         NULL,
    [Term]                 INT              NULL,
    [Rate]                 DECIMAL (18, 10) NULL,
    [CreatedBy]            INT              NOT NULL,
    [DateCreated]          DATETIME         NOT NULL,
    [PriceTier]            TINYINT          NULL,
    CONSTRAINT [PK_ProductCostRule] PRIMARY KEY CLUSTERED ([ProductCostRuleID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductCostRule_ProductCostRuleSet] FOREIGN KEY ([ProductCostRuleSetID]) REFERENCES [dbo].[ProductCostRuleSet] ([ProductCostRuleSetID])
);


GO
CREATE NONCLUSTERED INDEX [ProductCostRuleIndex]
    ON [dbo].[ProductCostRule]([ProductCostRuleSetID] ASC, [MarketID] ASC, [UtilityID] ASC, [ServiceClassID] ASC, [ZoneID] ASC, [ProductTypeID] ASC, [StartDate] ASC, [Term] ASC, [PriceTier] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCostRule';

