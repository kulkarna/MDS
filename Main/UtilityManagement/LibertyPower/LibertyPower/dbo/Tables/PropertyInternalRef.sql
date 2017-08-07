CREATE TABLE [dbo].[PropertyInternalRef] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Value]          VARCHAR (100) NOT NULL,
    [Inactive]       BIT           CONSTRAINT [DF_PropertyInternalRef_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated]    DATETIME      CONSTRAINT [DF_PropertyInternalRef_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      INT           NOT NULL,
    [PropertyId]     INT           NULL,
    [PropertyTypeId] INT           NULL,
    [Modified]       DATETIME      NULL,
    [ModifiedBy]     INT           NULL,
    CONSTRAINT [PK_PropertyInternalRef] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PropertyInternalRef_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_PropertyInternalRef_PropertyType] FOREIGN KEY ([PropertyTypeId]) REFERENCES [dbo].[PropertyType] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_PropertyInternalRef_Value] UNIQUE NONCLUSTERED ([PropertyId] ASC, [Value] ASC)
);


GO
ALTER TABLE [dbo].[PropertyInternalRef] NOCHECK CONSTRAINT [FK_PropertyInternalRef_PropertyType];

