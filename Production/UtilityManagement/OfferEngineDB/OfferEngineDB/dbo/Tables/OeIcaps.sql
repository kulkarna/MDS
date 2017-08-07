CREATE TABLE [dbo].[OeIcaps] (
    [ID]          INT             IDENTITY (1, 1) NOT NULL,
    [OeAccountID] INT             NOT NULL,
    [Icap]        DECIMAL (18, 9) NULL,
    [StartDate]   DATETIME        NULL,
    [EndDate]     DATETIME        NULL,
    [TimeStamp]   DATETIME        CONSTRAINT [DF_OeIcaps_TimeStamp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [FK_OeIcaps_OE_ACCOUNT] FOREIGN KEY ([OeAccountID]) REFERENCES [dbo].[OE_ACCOUNT] ([ID]) ON DELETE CASCADE
);

