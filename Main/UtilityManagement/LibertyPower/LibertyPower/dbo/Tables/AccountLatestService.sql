CREATE TABLE [dbo].[AccountLatestService] (
    [AccountLatestServiceID] INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]              INT      NOT NULL,
    [StartDate]              DATETIME NULL,
    [EndDate]                DATETIME NULL,
    [DateCreated]            DATETIME CONSTRAINT [DF_AccountLatestService_DateCreated] DEFAULT (getdate()) NOT NULL,
    [DateModified]           DATETIME CONSTRAINT [DF_AccountLatestService_DateModified] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AccountLatestService] PRIMARY KEY NONCLUSTERED ([AccountLatestServiceID] ASC)
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_AccountLatestService_AccountID_StartEndDate]
    ON [dbo].[AccountLatestService]([AccountID] ASC);

