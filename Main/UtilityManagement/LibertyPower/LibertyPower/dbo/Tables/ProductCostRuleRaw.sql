CREATE TABLE [dbo].[ProductCostRuleRaw] (
    [ProductCostRuleRawID] INT              IDENTITY (1, 1) NOT NULL,
    [ProductCostRuleSetID] INT              NOT NULL,
    [ProspectCustomerType] VARCHAR (50)     NULL,
    [Product]              VARCHAR (50)     NULL,
    [MarketCode]           VARCHAR (50)     NULL,
    [UtilityCode]          VARCHAR (50)     NULL,
    [Zone]                 VARCHAR (50)     NULL,
    [UtilityServiceClass]  VARCHAR (50)     NULL,
    [ServiceClassName]     VARCHAR (50)     NULL,
    [StartDate]            DATETIME         NULL,
    [Term]                 INT              NULL,
    [Rate]                 DECIMAL (18, 10) NULL,
    [CreatedBy]            INT              NOT NULL,
    [CreatedDate]          DATETIME         NOT NULL,
    [PriceTier]            TINYINT          NULL,
    CONSTRAINT [PK_ProductCostRuleRaw] PRIMARY KEY CLUSTERED ([ProductCostRuleRawID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductCostRuleRaw';

