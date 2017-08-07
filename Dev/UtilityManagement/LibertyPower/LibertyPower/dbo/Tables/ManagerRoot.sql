CREATE TABLE [dbo].[ManagerRoot] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [FileManagerID] INT           NOT NULL,
    [Root]          VARCHAR (512) NOT NULL,
    [IsActive]      BIT           NOT NULL,
    [CreationTime]  DATETIME      CONSTRAINT [DF_ManagerRoot_CreationTime] DEFAULT (getdate()) NOT NULL,
    [UserID]        INT           NOT NULL,
    CONSTRAINT [PK_ManagerRoot] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ManagerRoot_FileManager] FOREIGN KEY ([FileManagerID]) REFERENCES [dbo].[FileManager] ([ID])
);

