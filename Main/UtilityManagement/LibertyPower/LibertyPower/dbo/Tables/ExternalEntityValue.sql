CREATE TABLE [dbo].[ExternalEntityValue] (
    [ID]               INT      IDENTITY (1, 1) NOT NULL,
    [ExternalEntityID] INT      NOT NULL,
    [Inactive]         BIT      CONSTRAINT [DF_ExternalEntityValue_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated]      DATETIME CONSTRAINT [DF_ExternalEntityValue_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        INT      NOT NULL,
    [PropertyValueID]  INT      CONSTRAINT [DF__ExternalE__Prope__40DB41A9] DEFAULT ((0)) NOT NULL,
    [Modified]         DATETIME NULL,
    [ModifiedBy]       INT      NULL,
    CONSTRAINT [PK_ExternalEntityValue] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_ExternalEntityValue_ExternalEntity] FOREIGN KEY ([ExternalEntityID]) REFERENCES [dbo].[ExternalEntity] ([ID]),
    CONSTRAINT [FK_ExternalEntityValue_PropertyValue] FOREIGN KEY ([PropertyValueID]) REFERENCES [dbo].[PropertyValue] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_ExternalEntityValue] UNIQUE NONCLUSTERED ([ExternalEntityID] ASC, [PropertyValueID] ASC)
);

