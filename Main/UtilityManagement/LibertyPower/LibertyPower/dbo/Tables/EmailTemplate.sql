CREATE TABLE [dbo].[EmailTemplate] (
    [EmailTemplateID]      INT           IDENTITY (1, 1) NOT NULL,
    [Code]                 VARCHAR (20)  NOT NULL,
    [Description]          VARCHAR (100) NULL,
    [DefaultFromAddressID] INT           NOT NULL,
    [Subject]              VARCHAR (100) NOT NULL,
    [Body]                 VARCHAR (MAX) NOT NULL,
    [IsHtml]               BIT           CONSTRAINT [DF_EmailTemplate_IsHtml] DEFAULT ((1)) NOT NULL,
    [CreatedByID]          INT           NOT NULL,
    [CreatedDate]          DATETIME      CONSTRAINT [DF_EmailTemplate_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedByID]         INT           NOT NULL,
    [ModifiedDate]         DATETIME      CONSTRAINT [DF_EmailTemplate_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EmailTemplate] PRIMARY KEY CLUSTERED ([EmailTemplateID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_EmailTemplate_EmailTemplateAddress1] FOREIGN KEY ([DefaultFromAddressID]) REFERENCES [dbo].[EmailTemplateAddress] ([EmailTemplateAddressID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_EmailTemplate_Code]
    ON [dbo].[EmailTemplate]([Code] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Email', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailTemplate';

