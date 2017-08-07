CREATE TABLE [dbo].[AccountSalesPitchLetterQueue] (
    [SalesPitchLetterID] INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]          INT      NOT NULL,
    [EtfID]              INT      NOT NULL,
    [StatusID]           INT      NOT NULL,
    [DateScheduled]      DATETIME NOT NULL,
    [DateProcessed]      DATETIME NULL,
    [DateInserted]       DATETIME CONSTRAINT [DF_AccountSalesPitchLetterQueue_DateInserted] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AccountSalesPitchLetterQueue] PRIMARY KEY CLUSTERED ([SalesPitchLetterID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AccountSalesPitchLetterQueue_AccountSalesPitchLetterStatus] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[AccountSalesPitchLetterStatus] ([SalesPitchLetterStatusID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountSalesPitchLetterQueue';

