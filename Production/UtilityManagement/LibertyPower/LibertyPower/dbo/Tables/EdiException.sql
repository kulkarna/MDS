CREATE TABLE [dbo].[EdiException] (
    [EdiExceptionID] NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [Code]           CHAR (3)       NOT NULL,
    [Description]    NVARCHAR (500) NOT NULL,
    [DateCreated]    DATETIME       NOT NULL,
    [UserCreated]    NVARCHAR (100) NOT NULL,
    [DateModified]   DATETIME       NOT NULL,
    [UserModified]   NVARCHAR (100) NOT NULL,
    [InactiveInd]    BIT            NOT NULL,
    CONSTRAINT [PK_EdiExceptionID] PRIMARY KEY CLUSTERED ([EdiExceptionID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NDX_Code]
    ON [dbo].[EdiException]([Code] ASC) WITH (FILLFACTOR = 90);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NDX_Description]
    ON [dbo].[EdiException]([Description] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiException';

