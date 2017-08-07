CREATE TABLE [dbo].[EdiTransactionProcessingOutcome] (
    [ResultId] INT          IDENTITY (1, 1) NOT NULL,
    [Result]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EdiTransactionResult] PRIMARY KEY CLUSTERED ([ResultId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiTransactionProcessingOutcome';

