CREATE TABLE [dbo].[CustomerContact] (
    [CustomerContactID] INT      IDENTITY (1, 1) NOT NULL,
    [CustomerID]        INT      NULL,
    [ContactID]         INT      NULL,
    [Modified]          DATETIME NULL,
    [ModifiedBy]        INT      NULL,
    [DateCreated]       DATETIME NULL,
    [CreatedBy]         INT      NULL,
    CONSTRAINT [PK_CustomerContact] PRIMARY KEY CLUSTERED ([CustomerContactID] ASC),
    CONSTRAINT [FK_CustomerContact_Contact] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[Contact] ([ContactID]),
    CONSTRAINT [FK_CustomerContact_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID])
);


GO
CREATE NONCLUSTERED INDEX [CustomerContact__CustomerID_ContactID]
    ON [dbo].[CustomerContact]([CustomerID] ASC, [ContactID] ASC);


GO
CREATE NONCLUSTERED INDEX [CustomerContact__ContactID_CustomerID]
    ON [dbo].[CustomerContact]([ContactID] ASC, [CustomerID] ASC);

