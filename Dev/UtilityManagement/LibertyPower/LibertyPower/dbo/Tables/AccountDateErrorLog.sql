CREATE TABLE [dbo].[AccountDateErrorLog] (
    [AccountDateErrorLogID] INT       IDENTITY (1, 1) NOT NULL,
    [AccountID]             CHAR (12) NOT NULL,
    [RateChangeType]        CHAR (12) NOT NULL,
    [IntendedStartDate]     DATETIME  NOT NULL,
    [ActualStartDate]       DATETIME  NOT NULL,
    CONSTRAINT [PK_AccountDateErrorLog] PRIMARY KEY CLUSTERED ([AccountDateErrorLogID] ASC) WITH (FILLFACTOR = 90)
);

