CREATE TABLE [dbo].[CustomerName] (
    [CustomerNameID] INT      IDENTITY (1, 1) NOT NULL,
    [CustomerID]     INT      NULL,
    [NameID]         INT      NULL,
    [Modified]       DATETIME NOT NULL,
    [ModifiedBy]     INT      NOT NULL,
    [DateCreated]    DATETIME NOT NULL,
    [CreatedBy]      INT      NOT NULL,
    CONSTRAINT [PK_CustomerName] PRIMARY KEY CLUSTERED ([CustomerNameID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [CustomerName__CustomerID_NameID]
    ON [dbo].[CustomerName]([CustomerID] ASC, [NameID] ASC);


GO
CREATE NONCLUSTERED INDEX [CustomerName__NameID_CustomerID]
    ON [dbo].[CustomerName]([NameID] ASC, [CustomerID] ASC);

