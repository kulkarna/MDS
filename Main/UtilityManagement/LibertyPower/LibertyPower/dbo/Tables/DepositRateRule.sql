CREATE TABLE [dbo].[DepositRateRule] (
    [DepositRateRuleID] INT          IDENTITY (1, 1) NOT NULL,
    [RetailMarketID]    CHAR (2)     NULL,
    [UtilityID]         CHAR (15)    NULL,
    [Rate]              FLOAT (53)   NULL,
    [DateCreated]       DATETIME     NULL,
    [CreatedBy]         VARCHAR (50) NULL,
    [DateExpired]       DATETIME     NULL,
    [ExpiredBy]         VARCHAR (50) NULL,
    CONSTRAINT [PK_dbo.DepositRateRule] PRIMARY KEY CLUSTERED ([DepositRateRuleID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DepositRateRule';

