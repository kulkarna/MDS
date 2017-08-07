CREATE TABLE [dbo].[GrossMarginErrorLog] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [AccountId]     CHAR (12)     NULL,
    [ErrorLocation] VARCHAR (500) NOT NULL,
    [ErrorMessage]  TEXT          NOT NULL,
    [ErrorDate]     DATETIME      CONSTRAINT [DF_GrossMarginErrorLog_ErrorDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_GrossMarginErrorLog] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

