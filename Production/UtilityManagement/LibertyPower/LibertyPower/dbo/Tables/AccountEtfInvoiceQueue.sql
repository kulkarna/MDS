CREATE TABLE [dbo].[AccountEtfInvoiceQueue] (
    [EtfInvoiceID]      INT          IDENTITY (1, 1) NOT NULL,
    [AccountID]         INT          NOT NULL,
    [EtfID]             INT          NOT NULL,
    [StatusID]          INT          NOT NULL,
    [IsPaid]            BIT          CONSTRAINT [DF_AccountEtfInvoiceQueue_IsPaid] DEFAULT ((0)) NOT NULL,
    [DateInvoiced]      DATETIME     NULL,
    [IstaInvoiceNumber] VARCHAR (50) NULL,
    [DateInserted]      DATETIME     CONSTRAINT [DF_AccountEtfInvoiceQueue_DateInserted] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AccountEtfInvoiceQueue] PRIMARY KEY CLUSTERED ([EtfInvoiceID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AccountEtfInvoiceQueue_AccountEtfInvoiceStatus] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[AccountEtfInvoiceStatus] ([EtfInvoiceStatusID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfInvoiceQueue';

