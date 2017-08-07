CREATE TABLE [dbo].[AccountEtfCalculationFixedHistory] (
    [EtfCalculationFixedHistoryID] INT        IDENTITY (1, 1) NOT NULL,
    [EtfID]                        INT        NOT NULL,
    [LostTermDays]                 INT        NOT NULL,
    [LostTermMonths]               INT        NOT NULL,
    [AccountRate]                  FLOAT (53) NOT NULL,
    [MarketRate]                   FLOAT (53) NOT NULL,
    [AnnualUsage]                  INT        NOT NULL,
    [Term]                         INT        NOT NULL,
    [FlowStartDate]                DATETIME   NOT NULL,
    [DropMonthIndicator]           INT        NOT NULL,
    [DateCreated]                  DATETIME   CONSTRAINT [DF_AccountEtfCalculationFixedHistory_DateCreated] DEFAULT (getdate()) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfCalculationFixedHistory';

