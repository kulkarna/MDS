CREATE TABLE [dbo].[AccountEventHistory] (
    [ID]                          INT             IDENTITY (1, 1) NOT NULL,
    [ContractNumber]              VARCHAR (50)    NULL,
    [AccountId]                   CHAR (12)       NOT NULL,
    [ProductId]                   CHAR (20)       NOT NULL,
    [RateID]                      INT             NULL,
    [Rate]                        DECIMAL (18, 6) NOT NULL,
    [RateEndDate]                 DATETIME        NOT NULL,
    [EventID]                     INT             NOT NULL,
    [EventEffectiveDate]          DATETIME        NOT NULL,
    [ContractType]                VARCHAR (50)    NOT NULL,
    [ContractDate]                DATETIME        NOT NULL,
    [ContractEndDate]             DATETIME        NOT NULL,
    [DateFlowStart]               DATETIME        NOT NULL,
    [Term]                        SMALLINT        NOT NULL,
    [AnnualUsage]                 INT             NOT NULL,
    [GrossMarginValue]            DECIMAL (18, 6) NULL,
    [AnnualGrossProfit]           DECIMAL (18, 4) NOT NULL,
    [TermGrossProfit]             DECIMAL (18, 4) NOT NULL,
    [AnnualGrossProfitAdjustment] DECIMAL (18, 4) NOT NULL,
    [TermGrossProfitAdjustment]   DECIMAL (18, 4) NOT NULL,
    [AnnualRevenue]               DECIMAL (18, 4) NOT NULL,
    [TermRevenue]                 DECIMAL (18, 4) NOT NULL,
    [AnnualRevenueAdjustment]     DECIMAL (18, 4) NOT NULL,
    [TermRevenueAdjustment]       DECIMAL (18, 4) NOT NULL,
    [EventDate]                   DATETIME        CONSTRAINT [DF_AccountEventHistory_EventDate] DEFAULT (getdate()) NOT NULL,
    [SubmitDate]                  DATETIME        NULL,
    [DealDate]                    DATETIME        NULL,
    [SalesChannelId]              VARCHAR (100)   NULL,
    [SalesRep]                    VARCHAR (100)   NULL,
    [AdditionalGrossMargin]       DECIMAL (18, 6) DEFAULT ((0)) NULL,
    [ProductTypeID]               INT             NULL
);


GO
CREATE CLUSTERED INDEX [idx_EventID]
    ON [dbo].[AccountEventHistory]([EventID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_dta_index_AccountEventHistory_113_498100815__K1D_2_3_4_5_6_7_8_9_10_11_12_13_14_15_16_17_18_19_20_21_22_23_24_25_26_27_28_29_]
    ON [dbo].[AccountEventHistory]([ID] DESC)
    INCLUDE([ContractNumber], [AccountId], [ProductId], [RateID], [Rate], [RateEndDate], [EventID], [EventEffectiveDate], [ContractType], [ContractDate], [ContractEndDate], [DateFlowStart], [Term], [AnnualUsage], [GrossMarginValue], [AnnualGrossProfit], [TermGrossProfit], [AnnualGrossProfitAdjustment], [TermGrossProfitAdjustment], [AnnualRevenue], [TermRevenue], [AnnualRevenueAdjustment], [TermRevenueAdjustment], [EventDate], [SubmitDate], [DealDate], [SalesChannelId], [SalesRep], [AdditionalGrossMargin]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_AccountID]
    ON [dbo].[AccountEventHistory]([AccountId] ASC, [ID] ASC, [ContractNumber] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_AccountIDContractNumber]
    ON [dbo].[AccountEventHistory]([AccountId] ASC, [ContractNumber] ASC) WITH (FILLFACTOR = 90);


GO
CREATE STATISTICS [_dta_stat_498100815_3_8_1]
    ON [dbo].[AccountEventHistory]([AccountId], [EventID], [ID]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Account', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEventHistory';

