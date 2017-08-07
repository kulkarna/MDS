CREATE TABLE [dbo].[ComplaintType] (
    [ComplaintTypeID]     INT          NOT NULL,
    [Name]                VARCHAR (60) NOT NULL,
    [ComplaintCategoryID] INT          NOT NULL,
    CONSTRAINT [PK_ComplaintType] PRIMARY KEY CLUSTERED ([ComplaintTypeID] ASC),
    CONSTRAINT [FK_ComplaintType_ComplaintCategory] FOREIGN KEY ([ComplaintCategoryID]) REFERENCES [dbo].[ComplaintCategory] ([ComplaintCategoryID])
);

