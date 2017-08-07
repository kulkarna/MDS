CREATE TABLE [dbo].[SalesStatus] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50) NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_SalesStatus] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

