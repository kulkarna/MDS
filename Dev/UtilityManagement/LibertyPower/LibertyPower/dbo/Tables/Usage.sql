CREATE TABLE [dbo].[Usage] (
    [ID]                  BIGINT         IDENTITY (100, 1) NOT NULL,
    [UtilityCode]         VARCHAR (50)   NOT NULL,
    [AccountNumber]       VARCHAR (50)   NOT NULL,
    [UsageType]           INT            NOT NULL,
    [UsageSource]         INT            NOT NULL,
    [FromDate]            DATETIME       NOT NULL,
    [ToDate]              DATETIME       NOT NULL,
    [TotalKwh]            INT            NOT NULL,
    [DaysUsed]            INT            NULL,
    [Created]             DATETIME       CONSTRAINT [DF_Usage_Created] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)   NULL,
    [Modified]            DATETIME       NULL,
    [ModifiedBy]          VARCHAR (50)   NULL,
    [MeterNumber]         VARCHAR (50)   NULL,
    [OnPeakKWh]           VARCHAR (25)   NULL,
    [OffPeakKWh]          VARCHAR (25)   NULL,
    [BillingDemandKW]     FLOAT (53)     NULL,
    [MonthlyPeakDemandKW] FLOAT (53)     NULL,
    [CurrentCharges]      FLOAT (53)     NULL,
    [Comments]            VARCHAR (1000) NULL,
    [TransactionNumber]   VARCHAR (500)  NULL,
    [TdspCharges]         FLOAT (53)     NULL,
    CONSTRAINT [PK_AccountBillingInfo] PRIMARY KEY CLUSTERED ([UtilityCode] ASC, [AccountNumber] ASC, [UsageType] ASC, [UsageSource] ASC, [FromDate] ASC, [ToDate] ASC, [TotalKwh] ASC) WITH (FILLFACTOR = 90, IGNORE_DUP_KEY = ON),
    CONSTRAINT [not_a_valid_begin_date] CHECK ([fromdate]>'01/01/1990'),
    CONSTRAINT [not_a_valid_end_date] CHECK ([todate]>'01/01/1990')
);


GO
CREATE NONCLUSTERED INDEX [NDX_ToDate]
    ON [dbo].[Usage]([ToDate] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ndx_ToDate_ID_TotalKwh_DaysUsed]
    ON [dbo].[Usage]([ToDate] ASC)
    INCLUDE([ID], [TotalKwh], [DaysUsed]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ndx_ID_ToDate]
    ON [dbo].[Usage]([ID] ASC)
    INCLUDE([ToDate]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [Usage__Accountnumber_Created_I]
    ON [dbo].[Usage]([AccountNumber] ASC, [Created] ASC)
    INCLUDE([UsageType], [UsageSource], [FromDate], [ToDate]);

