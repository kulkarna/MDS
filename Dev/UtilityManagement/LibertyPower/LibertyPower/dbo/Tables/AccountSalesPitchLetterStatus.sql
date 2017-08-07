CREATE TABLE [dbo].[AccountSalesPitchLetterStatus] (
    [SalesPitchLetterStatusID] INT          NOT NULL,
    [StatusName]               VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_AccountSalesPitchLetterStatus] PRIMARY KEY CLUSTERED ([SalesPitchLetterStatusID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountSalesPitchLetterStatus';

