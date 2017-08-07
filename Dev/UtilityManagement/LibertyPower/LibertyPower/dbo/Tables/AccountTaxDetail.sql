CREATE TABLE [dbo].[AccountTaxDetail] (
    [AccountTaxDetailID] INT            IDENTITY (1, 1) NOT NULL,
    [AccountID]          VARCHAR (25)   NULL,
    [TaxTypeID]          INT            NULL,
    [PercentTaxable]     DECIMAL (9, 6) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountTaxDetail';

