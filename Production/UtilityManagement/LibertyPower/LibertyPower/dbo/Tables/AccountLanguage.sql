CREATE TABLE [dbo].[AccountLanguage] (
    [AccountNumber] VARCHAR (30) NOT NULL,
    [LanguageId]    TINYINT      CONSTRAINT [DF_AccountLanguage_LanguageId] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_AccountLanguage] PRIMARY KEY CLUSTERED ([AccountNumber] ASC)
);

