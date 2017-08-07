CREATE TABLE [dbo].[CreditAgencyScoreRange] (
    [CreditAgencyScoreRangeID] INT NOT NULL,
    [CreditAgencyID]           INT NOT NULL,
    [LowScore]                 INT NOT NULL,
    [HighScore]                INT NULL,
    [AccountTypeID]            INT NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CreditAgencyScoreRange';

