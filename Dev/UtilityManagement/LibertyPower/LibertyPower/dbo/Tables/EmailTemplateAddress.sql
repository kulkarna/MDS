CREATE TABLE [dbo].[EmailTemplateAddress] (
    [EmailTemplateAddressID] INT           IDENTITY (1, 1) NOT NULL,
    [EmailTemplateAddress]   VARCHAR (100) NULL,
    [DisplayName]            VARCHAR (100) NULL,
    CONSTRAINT [PK_EmailTemplateAddress] PRIMARY KEY CLUSTERED ([EmailTemplateAddressID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [IX_EmailTemplateAddress_EmailTemplateAddress] UNIQUE NONCLUSTERED ([EmailTemplateAddress] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Email', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailTemplateAddress';

