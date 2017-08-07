CREATE TABLE [dbo].[TransferLog] (
    [TransferLogID]         INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]             INT      NULL,
    [TransferTopicID]       INT      NULL,
    [TransferDispositionID] INT      NULL,
    [DateCreated]           DATETIME CONSTRAINT [DF_TransferLog_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TransferLog] PRIMARY KEY CLUSTERED ([TransferLogID] ASC),
    CONSTRAINT [FK_TransferLog_TransferDisposition] FOREIGN KEY ([TransferDispositionID]) REFERENCES [dbo].[TransferDisposition] ([TransferDispositionID]),
    CONSTRAINT [FK_TransferLog_TransferTopic] FOREIGN KEY ([TransferTopicID]) REFERENCES [dbo].[TransferTopic] ([TransferTopicID])
);

