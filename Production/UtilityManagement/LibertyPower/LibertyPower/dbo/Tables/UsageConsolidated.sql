CREATE TABLE [dbo].[UsageConsolidated] (
    [ID]                     BIGINT       IDENTITY (1000, 1) NOT NULL,
    [UtilityCode]            VARCHAR (50) NOT NULL,
    [AccountNumber]          VARCHAR (50) NOT NULL,
    [UsageType]              SMALLINT     NOT NULL,
    [UsageSource]            SMALLINT     NOT NULL,
    [FromDate]               DATETIME     NOT NULL,
    [ToDate]                 DATETIME     NOT NULL,
    [TotalKwh]               INT          NOT NULL,
    [DaysUsed]               SMALLINT     NULL,
    [Created]                DATETIME     CONSTRAINT [DF_UsageConsolidated_Created] DEFAULT (getdate()) NULL,
    [CreatedBy]              VARCHAR (50) NULL,
    [Modified]               DATETIME     NULL,
    [Active]                 SMALLINT     NOT NULL,
    [ReasonCode]             SMALLINT     NULL,
    [MeterNumber]            VARCHAR (50) NOT NULL,
    [OnPeakKWh]              VARCHAR (25) NULL,
    [OffPeakKWh]             VARCHAR (25) NULL,
    [IntermediateKwh]        FLOAT (53)   NULL,
    [BillingDemandKW]        FLOAT (53)   NULL,
    [MonthlyPeakDemandKW]    FLOAT (53)   NULL,
    [MonthlyOffPeakDemandKw] FLOAT (53)   NULL,
    CONSTRAINT [PK_UsageConsolidated] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_UsageConsolidated_ReasonCode] FOREIGN KEY ([ReasonCode]) REFERENCES [dbo].[ReasonCode] ([Value])
);


GO
CREATE NONCLUSTERED INDEX [UC_CreatedIndex]
    ON [dbo].[UsageConsolidated]([Created] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UC_UniqueValuesIndex]
    ON [dbo].[UsageConsolidated]([UtilityCode] ASC, [AccountNumber] ASC, [FromDate] ASC, [ToDate] ASC, [MeterNumber] ASC, [Active] ASC);

