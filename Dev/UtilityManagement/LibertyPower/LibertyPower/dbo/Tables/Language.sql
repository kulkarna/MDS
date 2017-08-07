CREATE TABLE [dbo].[Language] (
    [LanguageID]  INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [DateCreated] DATETIME     CONSTRAINT [DF_Language_DateCreated] DEFAULT (getdate()) NOT NULL
);

