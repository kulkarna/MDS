CREATE TABLE [dbo].[ProductCostRuleSetup] (
    [ID]                        INT              IDENTITY (1, 1) NOT NULL,
    [Segment]                   INT              NULL,
    [ProductType]               INT              NULL,
    [Market]                    INT              NULL,
    [Utility]                   INT              NULL,
    [Zone]                      INT              NULL,
    [ServiceClass]              INT              NULL,
    [ServiceClassDisplayName]   VARCHAR (50)     NULL,
    [MaxRelativeStartMonth]     INT              NULL,
    [MaxTerm]                   INT              NULL,
    [LowCostRate]               DECIMAL (18, 10) NULL,
    [HighCostRate]              DECIMAL (18, 10) NULL,
    [DateInserted]              DATETIME         NULL,
    [InsertedBy]                VARCHAR (100)    NULL,
    [PorRate]                   DECIMAL (18, 10) NULL,
    [GrtRate]                   DECIMAL (18, 10) NULL,
    [SutRate]                   DECIMAL (18, 10) NULL,
    [ProductCostRuleSetupSetID] INT              NOT NULL,
    [PriceTier]                 TINYINT          NULL,
    [ProductBrandID]            INT              NULL,
    CONSTRAINT [PK_ProductCostRateSetup] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ProductCostRuleSetup__Cover1]
    ON [dbo].[ProductCostRuleSetup]([ProductCostRuleSetupSetID] ASC)
    INCLUDE([Segment], [ProductType], [Utility], [Zone], [ServiceClass], [ServiceClassDisplayName], [PriceTier]);


GO
CREATE NONCLUSTERED INDEX [ProductCostRuleSetup__Cover2]
    ON [dbo].[ProductCostRuleSetup]([Segment] ASC, [ProductType] ASC, [Utility] ASC, [Zone] ASC, [ServiceClass] ASC)
    INCLUDE([ServiceClassDisplayName], [ProductCostRuleSetupSetID], [PriceTier]);


GO
CREATE NONCLUSTERED INDEX [ProductCostRuleSetup__Utility_Cover3]
    ON [dbo].[ProductCostRuleSetup]([Utility] ASC)
    INCLUDE([Segment], [ProductType], [Zone], [ServiceClass], [ServiceClassDisplayName], [ProductCostRuleSetupSetID], [PriceTier]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCostRuleSetup';

