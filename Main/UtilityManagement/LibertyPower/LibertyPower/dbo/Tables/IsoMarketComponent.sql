CREATE TABLE [dbo].[IsoMarketComponent] (
    [ID]            INT      IDENTITY (1, 1) NOT NULL,
    [PricingCompID] INT      NOT NULL,
    [IsoID]         INT      NULL,
    [MarketID]      INT      NULL,
    [DateCreated]   DATETIME NOT NULL,
    [CreatedBy]     INT      NOT NULL,
    [DateModified]  DATETIME NULL,
    [ModifiedBy]    INT      NULL,
    CONSTRAINT [PK_IsoMarketComponent] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_IsoMarketComponent_PricingComponent] FOREIGN KEY ([PricingCompID]) REFERENCES [dbo].[PricingComponent] ([ID])
);

