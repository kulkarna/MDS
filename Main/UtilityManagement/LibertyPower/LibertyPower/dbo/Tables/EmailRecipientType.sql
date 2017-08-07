CREATE TABLE [dbo].[EmailRecipientType] (
    [EmailRecipientTypeID] INT         IDENTITY (1, 1) NOT NULL,
    [TypeName]             VARCHAR (5) NOT NULL,
    CONSTRAINT [PK_EmailRecipientType] PRIMARY KEY CLUSTERED ([EmailRecipientTypeID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Email', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailRecipientType';

