CREATE TABLE [dbo].[EdiTransactionType] (
    [EdiTransactionTypeID] NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [Number]               INT            NOT NULL,
    [Type]                 VARCHAR (2)    NOT NULL,
    [Description]          NVARCHAR (500) NOT NULL,
    [DateCreated]          DATETIME       NOT NULL,
    [UserCreated]          NVARCHAR (100) NOT NULL,
    [DateModified]         DATETIME       NOT NULL,
    [UserModified]         NVARCHAR (100) NOT NULL,
    [InactiveInd]          BIT            NOT NULL,
    CONSTRAINT [PK_TransactionTypeID] PRIMARY KEY CLUSTERED ([EdiTransactionTypeID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NDX_NumberType]
    ON [dbo].[EdiTransactionType]([Number] ASC, [Type] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiTransactionType';

