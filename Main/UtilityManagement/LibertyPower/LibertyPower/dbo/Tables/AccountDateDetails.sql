CREATE TABLE [dbo].[AccountDateDetails] (
    [AccountDateDetailsID] INT      IDENTITY (1, 1) NOT NULL,
    [AccountID]            INT      NOT NULL,
    [ExpirationDate]       DATETIME NOT NULL,
    [NumberOfDays]         INT      NOT NULL,
    [CreatedBy]            INT      NOT NULL,
    [Created]              DATETIME NOT NULL,
    [ModifiedBy]           INT      NULL,
    [Modified]             DATETIME NULL,
    CONSTRAINT [PK_AccountDateDetails] PRIMARY KEY CLUSTERED ([AccountDateDetailsID] ASC),
    CONSTRAINT [FK_AccountDateDetails_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_AccountDateDetails_User] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_AccountDateDetails_User1] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserID])
);

