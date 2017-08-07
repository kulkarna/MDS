CREATE TABLE [dbo].[EmailTemplateRecipient] (
    [EmailTemplateID]        INT NOT NULL,
    [EmailTemplateAddressID] INT NOT NULL,
    [EmailRecipientTypeID]   INT NOT NULL,
    CONSTRAINT [PK_EmailTemplateRecipient] PRIMARY KEY CLUSTERED ([EmailTemplateID] ASC, [EmailTemplateAddressID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_EmailTemplateRecipient_EmailRecipientType] FOREIGN KEY ([EmailRecipientTypeID]) REFERENCES [dbo].[EmailRecipientType] ([EmailRecipientTypeID]),
    CONSTRAINT [FK_EmailTemplateRecipient_EmailTemplate] FOREIGN KEY ([EmailTemplateID]) REFERENCES [dbo].[EmailTemplate] ([EmailTemplateID]),
    CONSTRAINT [FK_EmailTemplateRecipient_EmailTemplateAddress] FOREIGN KEY ([EmailTemplateAddressID]) REFERENCES [dbo].[EmailTemplateAddress] ([EmailTemplateAddressID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Email', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailTemplateRecipient';

