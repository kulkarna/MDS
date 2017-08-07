CREATE TABLE [dbo].[NameBak] (
    [NameID]      INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (150) NULL,
    [Modified]    DATETIME       NULL,
    [ModifiedBy]  INT            NULL,
    [DateCreated] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [account_id]  CHAR (12)      NULL,
    [name_link]   INT            NULL
);

