CREATE TABLE [dbo].[EstimatedUsage] (
    [ID]            BIGINT       IDENTITY (1000, 1) NOT NULL,
    [UtilityCode]   VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [MeterNumber]   VARCHAR (50) NOT NULL,
    [FromDate]      DATETIME     NOT NULL,
    [ToDate]        DATETIME     NOT NULL,
    [TotalKwh]      INT          NOT NULL,
    [DaysUsed]      SMALLINT     NULL,
    [Created]       DATETIME     CONSTRAINT [DF_EstimatedUsage_Created] DEFAULT (getdate()) NULL,
    [CreatedBy]     VARCHAR (50) NULL,
    [UsageType]     INT          CONSTRAINT [DF_EstimatedUsage_UsageType] DEFAULT ((6)) NOT NULL,
    CONSTRAINT [PK_EstimatedUsage] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_EstimatedUsage]
    ON [dbo].[EstimatedUsage]([UtilityCode] ASC, [AccountNumber] ASC);

