CREATE TABLE [dbo].[GrossMarginUsageProxy] (
    [ProxyID]     INT          IDENTITY (1, 1) NOT NULL,
    [AccountType] VARCHAR (50) NOT NULL,
    [Usage]       INT          NOT NULL,
    CONSTRAINT [PK_GrossMarginUsageProxy] PRIMARY KEY CLUSTERED ([ProxyID] ASC) WITH (FILLFACTOR = 90)
);

