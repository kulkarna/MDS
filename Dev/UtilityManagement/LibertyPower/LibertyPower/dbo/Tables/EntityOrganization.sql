CREATE TABLE [dbo].[EntityOrganization] (
    [EntityID]     INT           NOT NULL,
    [CustomerName] VARCHAR (100) NULL,
    [TaxID]        VARCHAR (50)  NULL,
    [DunsNumber]   VARCHAR (50)  CONSTRAINT [DF__EntityOrg__DunsN__2BB470E3] DEFAULT ('') NULL,
    CONSTRAINT [PK_EntityOrganization] PRIMARY KEY CLUSTERED ([EntityID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_EntityOrganization_Entity] FOREIGN KEY ([EntityID]) REFERENCES [dbo].[Entity] ([EntityID])
);

