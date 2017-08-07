CREATE TABLE [dbo].[ContactBak] (
    [ContactID]    INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]    NVARCHAR (50) NULL,
    [LastName]     NVARCHAR (50) NULL,
    [Title]        NVARCHAR (50) NULL,
    [Phone]        VARCHAR (20)  NULL,
    [Fax]          VARCHAR (20)  NULL,
    [Email]        NVARCHAR (75) NULL,
    [Birthdate]    DATETIME      NULL,
    [Modified]     DATETIME      NULL,
    [ModifiedBy]   INT           NULL,
    [DateCreated]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [account_id]   CHAR (12)     NULL,
    [contact_link] INT           NULL
);

