CREATE TABLE [dbo].[PropertyValue] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [InternalRefID]  INT           NULL,
    [Value]          VARCHAR (100) NOT NULL,
    [Inactive]       BIT           CONSTRAINT [DF_PropertyValue_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated]    DATETIME      CONSTRAINT [DF_PropertyValue_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      INT           NOT NULL,
    [PropertyId]     INT           NULL,
    [PropertyTypeId] INT           CONSTRAINT [DF_PropertyValue_PropertyTypeId] DEFAULT ((0)) NULL,
    [Modified]       DATETIME      NULL,
    [ModifiedBy]     INT           NULL,
    CONSTRAINT [PK_PropertyValue] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PropertyValue_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_PropertyValue_PropertyInternalRef] FOREIGN KEY ([InternalRefID]) REFERENCES [dbo].[PropertyInternalRef] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_PropertyValue_PropertyType] FOREIGN KEY ([PropertyTypeId]) REFERENCES [dbo].[PropertyType] ([ID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [dbo].[PropertyValue] NOCHECK CONSTRAINT [FK_PropertyValue_PropertyInternalRef];


GO
ALTER TABLE [dbo].[PropertyValue] NOCHECK CONSTRAINT [FK_PropertyValue_PropertyType];

