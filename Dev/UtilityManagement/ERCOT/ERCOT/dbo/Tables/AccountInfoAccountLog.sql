CREATE TABLE [dbo].[AccountInfoAccountLog] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [FileLogID]    INT           NULL,
    [Information]  VARCHAR (500) NULL,
    [TimeInserted] DATETIME      NULL,
    CONSTRAINT [PK_AccountLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

