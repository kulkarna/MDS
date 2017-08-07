CREATE TABLE [dbo].[FileManager] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [ContextKey]      VARCHAR (50)  NOT NULL,
    [BusinessPurpose] VARCHAR (128) NOT NULL,
    [CreationTime]    DATETIME      CONSTRAINT [DF_FileManager_CreationTime] DEFAULT (getdate()) NOT NULL,
    [UserID]          INT           NOT NULL,
    CONSTRAINT [PK_FileManager] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

