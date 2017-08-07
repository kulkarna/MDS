CREATE TABLE [dbo].[TransferDisposition] (
    [TransferDispositionID] INT            IDENTITY (1, 1) NOT NULL,
    [Description]           NVARCHAR (MAX) NULL,
    [DateCreated]           DATETIME       CONSTRAINT [DF_TransferDisposition_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TransferDisposition] PRIMARY KEY CLUSTERED ([TransferDispositionID] ASC)
);

