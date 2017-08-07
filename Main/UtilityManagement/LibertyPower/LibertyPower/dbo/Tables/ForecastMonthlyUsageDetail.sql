CREATE TABLE [dbo].[ForecastMonthlyUsageDetail] (
    [MonthlyUsageId]      INT             NOT NULL,
    [UtilityCode]         VARCHAR (50)    NOT NULL,
    [AccountNumber]       VARCHAR (50)    NOT NULL,
    [UsageType]           INT             NOT NULL,
    [UsageSource]         INT             NOT NULL,
    [FromDate]            DATETIME        NOT NULL,
    [ToDate]              DATETIME        NOT NULL,
    [TotalKwh]            INT             NOT NULL,
    [DaysUsed]            INT             NOT NULL,
    [Created]             DATETIME        NULL,
    [CreatedBy]           VARCHAR (50)    NULL,
    [Modified]            DATETIME        NULL,
    [ModifiedBy]          VARCHAR (50)    NULL,
    [MeterNumber]         VARCHAR (50)    NULL,
    [OnPeakKWh]           DECIMAL (20, 6) NULL,
    [OffPeakKWh]          DECIMAL (20, 6) NULL,
    [BillingDemandKW]     DECIMAL (20, 6) NULL,
    [MonthlyPeakDemandKW] DECIMAL (20, 6) NULL,
    [CurrentCharges]      DECIMAL (20, 6) NULL,
    [Comments]            VARCHAR (1000)  NULL,
    [TransactionNumber]   VARCHAR (500)   NULL,
    [TdspCharges]         DECIMAL (20, 6) NULL,
    [UsageId]             INT             NULL,
    [IsConsolidated]      TINYINT         NULL,
    CONSTRAINT [FK_ForecastMonthlyUsageDetail_ForecastMonthlyUsageHeader2] FOREIGN KEY ([MonthlyUsageId]) REFERENCES [dbo].[ForecastMonthlyUsageHeader] ([MonthlyUsageId]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Forecast', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ForecastMonthlyUsageDetail';

