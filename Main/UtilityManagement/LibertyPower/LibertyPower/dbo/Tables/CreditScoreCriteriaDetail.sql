CREATE TABLE [dbo].[CreditScoreCriteriaDetail] (
    [CreditScoreCriteriaDetailId] INT           IDENTITY (1, 1) NOT NULL,
    [CreditScoreCriteriaHeaderId] INT           NOT NULL,
    [AccountTypeGroup]            NVARCHAR (50) NOT NULL,
    [LowUsage]                    INT           NOT NULL,
    [HighUsage]                   INT           NULL,
    [LowRange]                    INT           NULL,
    [HighRange]                   INT           NULL,
    CONSTRAINT [PK_CreditScoreCriteriaDetail] PRIMARY KEY CLUSTERED ([CreditScoreCriteriaDetailId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CreditScoreCriteriaDetail';

