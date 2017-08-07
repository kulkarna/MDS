CREATE TABLE [dbo].[ComplaintStatus] (
    [ComplaintStatusID] INT          NOT NULL,
    [Name]              VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_ComplaintStatus] PRIMARY KEY CLUSTERED ([ComplaintStatusID] ASC)
);

