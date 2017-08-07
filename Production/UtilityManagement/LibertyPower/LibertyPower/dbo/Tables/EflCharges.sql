CREATE TABLE [dbo].[EflCharges] (
    [UtilityID]      INT             NOT NULL,
    [AccountTypeID]  INT             NOT NULL,
    [LpFixed]        DECIMAL (10, 2) NOT NULL,
    [TdspFixed]      DECIMAL (10, 3) NULL,
    [TdspKwh]        DECIMAL (10, 7) NULL,
    [TdspFixedAbove] DECIMAL (10, 3) DEFAULT ((0)) NOT NULL,
    [TdspKwhAbove]   DECIMAL (10, 7) DEFAULT ((0)) NOT NULL,
    [TdspKw]         DECIMAL (10, 7) DEFAULT ((0)) NOT NULL,
    CONSTRAINT [FK_EflCharges_AccountType] FOREIGN KEY ([AccountTypeID]) REFERENCES [dbo].[AccountType] ([ID]),
    CONSTRAINT [FK_EflCharges_Utility] FOREIGN KEY ([UtilityID]) REFERENCES [dbo].[vw_Utility] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EflCharges';

