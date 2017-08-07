CREATE TABLE [dbo].[ItemType] (
    [ItemTypeID]          INT           IDENTITY (1, 1) NOT NULL,
    [ItemTypeName]        NVARCHAR (50) NOT NULL,
    [ItemTypeDescription] NVARCHAR (50) NOT NULL,
    [ContractTypeID]      INT           NOT NULL,
    [IsDeleted]           BIT           NULL,
    [CreatedBy]           NVARCHAR (50) NULL,
    [DateCreated]         DATETIME      NULL,
    [UpdatedBy]           NVARCHAR (50) NULL,
    [DateUpdated]         DATETIME      NULL,
    CONSTRAINT [PK_ItemType] PRIMARY KEY CLUSTERED ([ItemTypeID] ASC),
    CONSTRAINT [FK_ItemType_ContractType] FOREIGN KEY ([ContractTypeID]) REFERENCES [dbo].[ContractType] ([ContractTypeID])
);

