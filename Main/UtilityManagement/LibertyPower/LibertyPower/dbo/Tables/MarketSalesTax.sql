CREATE TABLE [dbo].[MarketSalesTax] (
    [MarketSalesTaxId]   INT        IDENTITY (1, 1) NOT NULL,
    [MarketId]           INT        NOT NULL,
    [SalesTax]           FLOAT (53) NOT NULL,
    [EffectiveStartDate] DATETIME   NOT NULL,
    [EffectiveEndDate]   DATETIME   NULL,
    [DateCreated]        DATETIME   NOT NULL,
    CONSTRAINT [PK_MarketSalesTax] PRIMARY KEY CLUSTERED ([MarketSalesTaxId] ASC)
);

