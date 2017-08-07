CREATE TABLE [dbo].[SourceType_Test] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (200) NOT NULL,
    [DateCreated] DATETIME      CONSTRAINT [DF_SourceType_Test_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SourceType_Test] PRIMARY KEY CLUSTERED ([ID] ASC)
);

