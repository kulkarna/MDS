CREATE TABLE [dbo].[EflParameters] (
    [AccountTypeID]        INT            NOT NULL,
    [AverageMonthlyUsage]  INT            NULL,
    [ProductId]            VARCHAR (50)   NULL,
    [ProductDescription]   VARCHAR (100)  NULL,
    [Term]                 INT            NULL,
    [MonthlyServiceCharge] DECIMAL (5, 2) NULL,
    [EflProcessID]         INT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [FK_EflParameters_AccountType] FOREIGN KEY ([AccountTypeID]) REFERENCES [dbo].[AccountType] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EflParameters';

