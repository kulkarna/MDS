CREATE TABLE [dbo].[FileContext] (
    [FileGuid]         UNIQUEIDENTIFIER NOT NULL,
    [ManagedBinID]     INT              NOT NULL,
    [FileName]         VARCHAR (512)    NOT NULL,
    [OriginalFileName] VARCHAR (512)    NOT NULL,
    [CreationTime]     DATETIME         CONSTRAINT [DF_FileContext_CreationTime] DEFAULT (getdate()) NOT NULL,
    [UserID]           INT              NOT NULL,
    CONSTRAINT [PK_FileContext] PRIMARY KEY CLUSTERED ([FileGuid] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_FileContext_ManagedBin] FOREIGN KEY ([ManagedBinID]) REFERENCES [dbo].[ManagedBin] ([ID])
);

