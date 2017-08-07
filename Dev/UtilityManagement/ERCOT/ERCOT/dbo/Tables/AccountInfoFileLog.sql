CREATE TABLE [dbo].[AccountInfoFileLog] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [GUID]         VARCHAR (100) NULL,
    [ZipFileName]  VARCHAR (200) NULL,
    [FileName]     VARCHAR (200) NULL,
    [Status]       TINYINT       NULL,
    [Information]  VARCHAR (500) NULL,
    [TimeInserted] DATETIME      NULL,
    CONSTRAINT [PK_FileLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

