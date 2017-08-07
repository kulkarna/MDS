CREATE TABLE [dbo].[UtilityPaymentTerms] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [MarketId]      INT          NOT NULL,
    [UtilityId]     INT          NOT NULL,
    [BillingType]   VARCHAR (50) NULL,
    [AccountType]   VARCHAR (50) NULL,
    [ARTerms]       SMALLINT     NOT NULL,
    [BillingTypeID] INT          NULL,
    [AccountTypeID] INT          NULL,
    CONSTRAINT [PK_UtilityPaymentTerms] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NDX_UtilityPaymentTerms]
    ON [dbo].[UtilityPaymentTerms]([MarketId] ASC, [UtilityId] ASC, [BillingTypeID] ASC, [AccountTypeID] ASC);

