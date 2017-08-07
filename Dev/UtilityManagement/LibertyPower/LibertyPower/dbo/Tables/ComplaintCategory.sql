CREATE TABLE [dbo].[ComplaintCategory] (
    [ComplaintCategoryID] INT          NOT NULL,
    [Name]                VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_ComplaintCategory] PRIMARY KEY CLUSTERED ([ComplaintCategoryID] ASC)
);

