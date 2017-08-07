CREATE TABLE [dbo].[StatusHistory] (
    [HistoryID]      INT          IDENTITY (1, 1) NOT NULL,
    [Stepname]       VARCHAR (50) NULL,
    [StatusName]     VARCHAR (50) NULL,
    [SequenceNumber] INT          NULL,
    [EntityID]       INT          NULL,
    [Appkey]         VARCHAR (50) NULL,
    [DateCreated]    DATETIME     CONSTRAINT [DF__StatusHis__DateC__2C1E8537] DEFAULT (getdate()) NULL
);

