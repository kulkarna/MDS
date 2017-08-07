CREATE TABLE [dbo].[CustomerAddress] (
    [CustomerAddressID] INT      IDENTITY (1, 1) NOT NULL,
    [CustomerID]        INT      NULL,
    [AddressID]         INT      NULL,
    [Modified]          DATETIME NOT NULL,
    [ModifiedBy]        INT      NOT NULL,
    [DateCreated]       DATETIME NOT NULL,
    [CreatedBy]         INT      NOT NULL,
    CONSTRAINT [PK_CustomerAddress] PRIMARY KEY CLUSTERED ([CustomerAddressID] ASC),
    CONSTRAINT [FK_CustomerAddress_Address] FOREIGN KEY ([AddressID]) REFERENCES [dbo].[Address] ([AddressID]),
    CONSTRAINT [FK_CustomerAddress_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID])
);


GO
CREATE NONCLUSTERED INDEX [CustomerAddress__CustomerID_AddressID]
    ON [dbo].[CustomerAddress]([CustomerID] ASC, [AddressID] ASC);


GO
CREATE NONCLUSTERED INDEX [CustomerAddress__AddressID_CustomerID]
    ON [dbo].[CustomerAddress]([AddressID] ASC, [CustomerID] ASC);

