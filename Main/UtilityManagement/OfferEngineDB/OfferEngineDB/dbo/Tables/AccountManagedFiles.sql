CREATE TABLE [dbo].[AccountManagedFiles] (
    [ID]            INT              IDENTITY (1, 1) NOT NULL,
    [AccountNumber] VARCHAR (50)     NULL,
    [UtilityCode]   VARCHAR (50)     NULL,
    [FileType]      TINYINT          NULL,
    [FileGuid]      UNIQUEIDENTIFIER NULL,
    [DateCreated]   DATETIME         NULL,
    CONSTRAINT [PK_AccountManagedFiles] PRIMARY KEY CLUSTERED ([ID] ASC)
);

