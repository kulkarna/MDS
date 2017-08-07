CREATE TABLE [dbo].[SelfGeneration] (
    [ID]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_SelfGeneration] PRIMARY KEY CLUSTERED ([ID] ASC)
);

