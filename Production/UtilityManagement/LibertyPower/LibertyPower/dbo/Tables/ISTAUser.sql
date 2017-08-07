CREATE TABLE [dbo].[ISTAUser] (
    [ID]             INT          IDENTITY (1, 1) NOT NULL,
    [UserID]         INT          NOT NULL,
    [SecUser_UserID] INT          NOT NULL,
    [IstaUsername]   VARCHAR (50) NOT NULL,
    [IstaPassword]   VARCHAR (50) NOT NULL,
    [DateCreated]    DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [fk_UserID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [UNQ__TableName__SecUser_UserID] UNIQUE NONCLUSTERED ([SecUser_UserID] ASC)
);

