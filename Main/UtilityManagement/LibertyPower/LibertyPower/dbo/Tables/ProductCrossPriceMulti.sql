CREATE TABLE [dbo].[ProductCrossPriceMulti] (
    [ProductCrossPriceMultiID] INT             IDENTITY (1, 1) NOT NULL,
    [ProductCrossPriceID]      INT             NOT NULL,
    [StartDate]                DATETIME        NOT NULL,
    [Term]                     INT             NOT NULL,
    [MarkupRate]               DECIMAL (13, 5) NOT NULL,
    [Price]                    DECIMAL (13, 5) NOT NULL,
    CONSTRAINT [PK_ProductCrossPriceMulti] PRIMARY KEY CLUSTERED ([ProductCrossPriceMultiID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_ProductCrosPriceID]
    ON [dbo].[ProductCrossPriceMulti]([ProductCrossPriceID] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [ndx_ProdCrossPriceIDStartDateTerm]
    ON [dbo].[ProductCrossPriceMulti]([ProductCrossPriceID] ASC, [StartDate] ASC, [Term] ASC) WITH (FILLFACTOR = 90);

