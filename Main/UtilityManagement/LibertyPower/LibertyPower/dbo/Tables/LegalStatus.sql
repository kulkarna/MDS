CREATE TABLE [dbo].[LegalStatus] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50) NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_LegalStatus] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

