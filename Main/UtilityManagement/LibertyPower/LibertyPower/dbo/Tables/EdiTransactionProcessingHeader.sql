CREATE TABLE [dbo].[EdiTransactionProcessingHeader] (
    [BatchId]          INT      IDENTITY (1, 1) NOT NULL,
    [RecordsProcessed] INT      NOT NULL,
    [Began]            DATETIME CONSTRAINT [DF_EDITransactionProcessingHeader_Began] DEFAULT (getdate()) NOT NULL,
    [Ended]            DATETIME CONSTRAINT [DF_EDITransactionProcessingHeader_Ended] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EdiTransactionProcessingHeader] PRIMARY KEY CLUSTERED ([BatchId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiTransactionProcessingHeader';

