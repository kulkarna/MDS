CREATE TABLE [dbo].[VREIstaRateUpdateRetries] (
    [IstaRateUpdateRetryID] INT              IDENTITY (1, 1) NOT NULL,
    [AccountNumber]         VARCHAR (50)     NOT NULL,
    [Utility]               VARCHAR (50)     NOT NULL,
    [Rate]                  DECIMAL (18, 10) NOT NULL,
    [SwitchDate]            DATETIME         NOT NULL,
    [RawEndingDate]         DATETIME         NOT NULL,
    [DateCreated]           DATETIME         CONSTRAINT [DF_IstaRateUpdateRetries_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             INT              NOT NULL,
    CONSTRAINT [PK_IstaRateUpdateRetries] PRIMARY KEY CLUSTERED ([IstaRateUpdateRetryID] ASC)
);

