CREATE TABLE [dbo].[EdiTransactionProcessingDetail] (
    [Id]      INT            IDENTITY (1, 1) NOT NULL,
    [Key814]  INT            NOT NULL,
    [Outcome] TINYINT        NOT NULL,
    [Message] VARCHAR (1000) NULL,
    [BatchId] INT            NOT NULL,
    CONSTRAINT [PK_EDITransactionProcessingDetail] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ndx_Key814]
    ON [dbo].[EdiTransactionProcessingDetail]([Key814] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiTransactionProcessingDetail';

