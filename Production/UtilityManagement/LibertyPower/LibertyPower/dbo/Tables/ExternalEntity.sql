CREATE TABLE [dbo].[ExternalEntity] (
    [ID]           INT      IDENTITY (1, 1) NOT NULL,
    [DateCreated]  DATETIME CONSTRAINT [DF_ExternalEntity_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    INT      NOT NULL,
    [Inactive]     BIT      CONSTRAINT [DF_ExternalEntity_Inactive] DEFAULT ((0)) NOT NULL,
    [ShowAs]       INT      NULL,
    [EntityKey]    INT      CONSTRAINT [DF__ExternalE__Entit__3751D76F] DEFAULT ((0)) NOT NULL,
    [EntityTypeID] INT      CONSTRAINT [DF__ExternalE__Entit__3845FBA8] DEFAULT ((0)) NOT NULL,
    [Modified]     DATETIME NULL,
    [ModifiedBy]   INT      NULL,
    CONSTRAINT [PK_ExternalEntity] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_ExternalEntity_ExternalEntityType] FOREIGN KEY ([EntityTypeID]) REFERENCES [dbo].[ExternalEntityType] ([ID]),
    CONSTRAINT [FK_ExternalEntity_ThirdPartyApplications] FOREIGN KEY ([EntityKey]) REFERENCES [dbo].[ThirdPartyApplications] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ExternalEntity_Utility] FOREIGN KEY ([EntityKey]) REFERENCES [dbo].[vw_Utility] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ExternalEntity_WholesaleMarket] FOREIGN KEY ([EntityKey]) REFERENCES [dbo].[WholesaleMarket] ([ID]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_ExternalEntity] UNIQUE NONCLUSTERED ([EntityKey] ASC, [EntityTypeID] ASC)
);


GO
ALTER TABLE [dbo].[ExternalEntity] NOCHECK CONSTRAINT [FK_ExternalEntity_ThirdPartyApplications];


GO
ALTER TABLE [dbo].[ExternalEntity] NOCHECK CONSTRAINT [FK_ExternalEntity_Utility];


GO
ALTER TABLE [dbo].[ExternalEntity] NOCHECK CONSTRAINT [FK_ExternalEntity_WholesaleMarket];

