CREATE TABLE [dbo].[RetentionSavedAccountsQueue] (
    [SavedAccountsQueueID]    INT           IDENTITY (1, 1) NOT NULL,
    [AccountID]               INT           NOT NULL,
    [EtfID]                   INT           NOT NULL,
    [EtfInvoiceID]            INT           NOT NULL,
    [StatusID]                INT           NOT NULL,
    [DateProcessed]           DATETIME      NULL,
    [ProcessedBy]             VARCHAR (100) NULL,
    [IstaWaivedInvoiceNumber] VARCHAR (50)  NULL,
    [DateInserted]            DATETIME      CONSTRAINT [DF_RetentionSavedAccountsQueue_DateInserted] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_RetentionSavedAccountsQueue] PRIMARY KEY CLUSTERED ([SavedAccountsQueueID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RetentionSavedAccountsQueue';

