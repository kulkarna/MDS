CREATE TABLE [dbo].[AccountBillTypeChange] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [AccountID]        INT           NOT NULL,
    [BillType]         VARCHAR (200) NOT NULL,
    [EnrollmentAction] VARCHAR (40)  NOT NULL,
    [EffectiveDate]    DATETIME      NULL,
    [EDITransactionID] INT           NOT NULL,
    [DateCreated]      DATETIME      CONSTRAINT [DF_AccountBillTypeChange_DateCreated] DEFAULT (getdate()) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountBillTypeChange';

