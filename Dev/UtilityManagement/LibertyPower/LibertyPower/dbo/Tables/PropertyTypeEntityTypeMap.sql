CREATE TABLE [dbo].[PropertyTypeEntityTypeMap] (
    [ID]                   INT      IDENTITY (1, 1) NOT NULL,
    [PropertyID]           INT      NOT NULL,
    [ExternalEntityTypeID] INT      NOT NULL,
    [Inactive]             BIT      CONSTRAINT [DF_PropertyTypeEntityTypeMap_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated]          DATETIME CONSTRAINT [DF_PropertyTypeEntityTypeMap_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            INT      NOT NULL,
    [Modified]             DATETIME NULL,
    [ModifiedBy]           INT      NULL,
    CONSTRAINT [PK_PropertyTypeEntityTypeMap] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PropertyTypeEntityTypeMap_ExtEntityType] FOREIGN KEY ([ExternalEntityTypeID]) REFERENCES [dbo].[ExternalEntityType] ([ID]),
    CONSTRAINT [FK_PropertyTypeEntityTypeMap_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([ID])
);

