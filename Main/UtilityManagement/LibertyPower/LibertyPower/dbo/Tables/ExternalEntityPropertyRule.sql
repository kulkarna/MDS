CREATE TABLE [dbo].[ExternalEntityPropertyRule] (
    [ID]               INT      IDENTITY (1, 1) NOT NULL,
    [ExternalEntityID] INT      NOT NULL,
    [PropertyID]       INT      NOT NULL,
    [PropertyRuleID]   INT      NOT NULL,
    [Inactive]         BIT      CONSTRAINT [DF_ExternalEntityPropertyRule_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated]      DATETIME NOT NULL,
    [CreatedBy]        INT      NULL,
    [Modified]         DATETIME NULL,
    [ModifiedBy]       INT      NULL,
    CONSTRAINT [PK_ExternalEntityPropertyRule] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_ExternalEntityPropertyRule_ExternalEntity] FOREIGN KEY ([ExternalEntityID]) REFERENCES [dbo].[ExternalEntity] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ExternalEntityPropertyRule_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ExternalEntityPropertyRule_PropertyRule] FOREIGN KEY ([PropertyRuleID]) REFERENCES [dbo].[PropertyRule] ([ID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [dbo].[ExternalEntityPropertyRule] NOCHECK CONSTRAINT [FK_ExternalEntityPropertyRule_ExternalEntity];


GO
ALTER TABLE [dbo].[ExternalEntityPropertyRule] NOCHECK CONSTRAINT [FK_ExternalEntityPropertyRule_Property];

