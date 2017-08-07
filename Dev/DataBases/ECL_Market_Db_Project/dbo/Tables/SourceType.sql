CREATE TABLE [dbo].[SourceType] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (200) NOT NULL,
    [DateCreated] DATETIME      CONSTRAINT [DF_SourceType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SourceType] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (DATA_COMPRESSION = PAGE)
);

