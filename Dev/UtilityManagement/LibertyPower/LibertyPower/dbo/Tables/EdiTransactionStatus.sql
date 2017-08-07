CREATE TABLE [dbo].[EdiTransactionStatus] (
    [Id]                INT          IDENTITY (1, 1) NOT NULL,
    [TransactionStatus] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EdiTransactionStatus] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiTransactionStatus';

