CREATE TABLE [dbo].[OeTcaps] (
    [ID]          INT             IDENTITY (1, 1) NOT NULL,
    [OeAccountID] INT             NOT NULL,
    [Tcap]        DECIMAL (18, 9) NULL,
    [StartDate]   DATETIME        NULL,
    [EndDate]     DATETIME        NULL,
    [TimeStamp]   DATETIME        CONSTRAINT [DF_OeTcaps_TimeStamp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [FK_OeTcaps_OE_ACCOUNT] FOREIGN KEY ([OeAccountID]) REFERENCES [dbo].[OE_ACCOUNT] ([ID]) ON DELETE CASCADE
);

