CREATE TABLE [dbo].[TransferTopic] (
    [TransferTopicID] INT            IDENTITY (1, 1) NOT NULL,
    [Description]     NVARCHAR (MAX) NULL,
    [DateCreated]     DATETIME       CONSTRAINT [DF_TransferTopic_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TransferTopic] PRIMARY KEY CLUSTERED ([TransferTopicID] ASC)
);

