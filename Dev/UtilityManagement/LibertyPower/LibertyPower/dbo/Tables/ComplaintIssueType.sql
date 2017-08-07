CREATE TABLE [dbo].[ComplaintIssueType] (
    [ComplaintIssueTypeID] INT          NOT NULL,
    [Name]                 VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_ComplaintIssueType] PRIMARY KEY CLUSTERED ([ComplaintIssueTypeID] ASC)
);

