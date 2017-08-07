CREATE TABLE [dbo].[EflDefaultProduct] (
    [ID]            INT             IDENTITY (1, 1) NOT NULL,
    [MarketCode]    VARCHAR (50)    NOT NULL,
    [AccountTypeID] INT             NOT NULL,
    [Month]         INT             NOT NULL,
    [Year]          INT             NOT NULL,
    [Mcpe]          DECIMAL (10, 5) NOT NULL,
    [Adder]         DECIMAL (10, 5) NOT NULL,
    [Username]      VARCHAR (100)   NOT NULL,
    [DateCreated]   DATETIME        CONSTRAINT [DF_EflDefaultProduct_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EflDefaultProduct] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_EflDefaultProduct_AccountType] FOREIGN KEY ([AccountTypeID]) REFERENCES [dbo].[AccountType] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [ndx_DateCreated]
    ON [dbo].[EflDefaultProduct]([MarketCode] ASC, [AccountTypeID] ASC, [Month] ASC, [Year] ASC)
    INCLUDE([DateCreated]) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EflDefaultProduct';

