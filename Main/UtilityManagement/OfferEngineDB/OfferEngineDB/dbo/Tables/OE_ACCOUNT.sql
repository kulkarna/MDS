CREATE TABLE [dbo].[OE_ACCOUNT] (
    [ID]                     INT             IDENTITY (1, 1) NOT NULL,
    [ACCOUNT_NUMBER]         VARCHAR (50)    NULL,
    [ACCOUNT_ID]             VARCHAR (50)    NULL,
    [MARKET]                 VARCHAR (25)    NULL,
    [UTILITY]                VARCHAR (50)    NULL,
    [METER_TYPE]             VARCHAR (50)    NULL,
    [RATE_CLASS]             VARCHAR (50)    NULL,
    [VOLTAGE]                VARCHAR (50)    NULL,
    [ZONE]                   VARCHAR (50)    NULL,
    [VAL_COMMENT]            NCHAR (256)     NULL,
    [TCAP]                   DECIMAL (18, 9) CONSTRAINT [DF_OE_ACCOUNT_TCAP] DEFAULT ((-1)) NULL,
    [ICAP]                   DECIMAL (18, 9) CONSTRAINT [DF_OE_ACCOUNT_ICAP] DEFAULT ((-1)) NULL,
    [LOAD_SHAPE_ID]          VARCHAR (50)    NULL,
    [LOSSES]                 DECIMAL (18, 9) NULL,
    [ANNUAL_USAGE]           BIGINT          CONSTRAINT [DF__OE_ACCOUN__ANNUA__625A9A57] DEFAULT ((1)) NULL,
    [USAGE_DATE]             DATETIME        CONSTRAINT [DF_OE_ACCOUNT_USAGE_DATE] DEFAULT (((1)/(1))/(1900)) NOT NULL,
    [NAME_KEY]               VARCHAR (50)    CONSTRAINT [DF_OE_ACCOUNT_NAME_KEY] DEFAULT ('') NOT NULL,
    [STRATUM_VARIABLE]       VARCHAR (50)    CONSTRAINT [DF_OE_ACCOUNT_STRATUM_VARIABLE] DEFAULT ('') NULL,
    [RATE_CODE]              VARCHAR (50)    CONSTRAINT [DF_OE_ACCOUNT_RATE_CODE] DEFAULT ('') NULL,
    [BILL_GROUP]             INT             NULL,
    [LOAD_PROFILE]           VARCHAR (50)    NULL,
    [SUPPLY_GROUP]           VARCHAR (255)   NULL,
    [IsIcapEsimated]         SMALLINT        NULL,
    [BillingAccountNumber]   VARCHAR (50)    NULL,
    [NeedUsage]              SMALLINT        DEFAULT ((0)) NOT NULL,
    [TarrifCode]             VARCHAR (50)    NULL,
    [Grid]                   VARCHAR (50)    NULL,
    [LbmpZone]               VARCHAR (50)    NULL,
    [DateCreated]            DATETIME        CONSTRAINT [DF_OE_ACCOUNT_DateCreated] DEFAULT (getdate()) NULL,
    [IsAnnualUsageEstimated] BIT             NULL,
    [EstimatedAnnualUsage]   BIGINT          NULL,
    CONSTRAINT [PK_OE_ACCOUNT] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE CLUSTERED INDEX [idx_account_id]
    ON [dbo].[OE_ACCOUNT]([ACCOUNT_ID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OE_ACCOUNT_99_695673526__K15_K3_K2_K1]
    ON [dbo].[OE_ACCOUNT]([ANNUAL_USAGE] ASC, [ACCOUNT_ID] ASC, [ACCOUNT_NUMBER] ASC, [ID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OE_ACCOUNT_99_695673526__K2_K3_K1]
    ON [dbo].[OE_ACCOUNT]([ACCOUNT_NUMBER] ASC, [ACCOUNT_ID] ASC, [ID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [idx_market_account_id]
    ON [dbo].[OE_ACCOUNT]([MARKET] ASC, [ACCOUNT_ID] ASC)
    INCLUDE([UTILITY]) WITH (FILLFACTOR = 90);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_utility_account_id]
    ON [dbo].[OE_ACCOUNT]([UTILITY] ASC, [ACCOUNT_NUMBER] ASC) WITH (FILLFACTOR = 90);

