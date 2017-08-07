CREATE TABLE [dbo].[AccountEtfMarketRate] (
    [EtfMarketRateID]    INT          IDENTITY (1, 1) NOT NULL,
    [EffectiveDate]      DATETIME     NOT NULL,
    [RetailMarket]       CHAR (2)     NOT NULL,
    [Utility]            VARCHAR (20) NOT NULL,
    [Zone]               VARCHAR (25) NULL,
    [ServiceClass]       VARCHAR (50) NULL,
    [Term]               INT          NULL,
    [DropMonthIndicator] INT          NOT NULL,
    [Rate]               FLOAT (53)   NOT NULL,
    [AccountType]        CHAR (3)     CONSTRAINT [DF_AccountEtfMarketRate_AccountType] DEFAULT ('SMB') NOT NULL,
    CONSTRAINT [PK_AccountEtfMarketRate] PRIMARY KEY CLUSTERED ([EtfMarketRateID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [IX_AccountEtfMarketRate_EffectiveDate_RetailMarket_Utility_Zone_ServiceClass_Term_DropMonthIndicator] UNIQUE NONCLUSTERED ([EffectiveDate] ASC, [RetailMarket] ASC, [Utility] ASC, [Zone] ASC, [ServiceClass] ASC, [Term] ASC, [DropMonthIndicator] ASC, [AccountType] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfMarketRate';

