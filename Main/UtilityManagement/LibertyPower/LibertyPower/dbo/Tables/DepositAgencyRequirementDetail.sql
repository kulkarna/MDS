CREATE TABLE [dbo].[DepositAgencyRequirementDetail] (
    [DepositAgencyRequirementDetailID] INT             IDENTITY (1, 1) NOT NULL,
    [LowScore]                         INT             NOT NULL,
    [HighScore]                        INT             NOT NULL,
    [Deposit]                          NUMERIC (18, 2) NOT NULL,
    [DepositAgencyRequirementID]       INT             NOT NULL,
    [AccountTypeGroup]                 NVARCHAR (50)   NULL,
    CONSTRAINT [PK_DepositAgencyRequirement_1] PRIMARY KEY CLUSTERED ([DepositAgencyRequirementDetailID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DepositAgencyRequirementDetail';

