CREATE TABLE [dbo].[RemoveUnusedPriceRecords_log] (
    [seqid]     INT            IDENTITY (1, 1) NOT NULL,
    [EventTime] DATETIME       DEFAULT (getdate()) NULL,
    [notes]     VARCHAR (1000) NULL
);

