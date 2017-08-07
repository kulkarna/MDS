CREATE TABLE [dbo].[Source] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (200) NOT NULL,
    [SourceTypeID] INT           NULL,
    [DateCreated]  DATETIME      CONSTRAINT [DF_Source_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Source] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Source_SourceType] FOREIGN KEY ([SourceTypeID]) REFERENCES [dbo].[SourceType] ([ID])
);

