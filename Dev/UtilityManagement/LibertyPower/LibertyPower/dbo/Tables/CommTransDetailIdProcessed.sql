CREATE TABLE [dbo].[CommTransDetailIdProcessed] (
    [TransactionDetailId] INT      CONSTRAINT [DF_CommTransDetailIdProcessed_TransactionDetailId] DEFAULT ((0)) NOT NULL,
    [ReportDate]          DATETIME NULL
);

