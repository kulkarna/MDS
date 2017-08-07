CREATE TABLE [dbo].[AccountPropertyLockHistory] (
    [AccountPropertyLockHistoryID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [AccountPropertyHistoryID]     BIGINT        NOT NULL,
    [LockStatus]                   VARCHAR (60)  NOT NULL,
    [CreatedBy]                    VARCHAR (256) NOT NULL,
    [DateCreated]                  DATETIME      NOT NULL,
    CONSTRAINT [PK_AccountPropertyLockHistory] PRIMARY KEY CLUSTERED ([AccountPropertyLockHistoryID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idxLockStatus_AccountPropertyLockHistory]
    ON [dbo].[AccountPropertyLockHistory]([AccountPropertyHistoryID] ASC)
    INCLUDE([CreatedBy], [DateCreated], [LockStatus]);

