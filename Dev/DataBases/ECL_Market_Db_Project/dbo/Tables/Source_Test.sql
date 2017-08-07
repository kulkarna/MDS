CREATE TABLE [dbo].[Source_Test] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (200) NOT NULL,
    [SourceTypeID] INT           NULL,
    [DateCreated]  DATETIME      CONSTRAINT [DF_Source_Test_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Source_Test] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Source_SourceType_Test] FOREIGN KEY ([SourceTypeID]) REFERENCES [dbo].[SourceType_Test] ([ID])
);

