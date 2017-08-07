CREATE TABLE [dbo].[EntityIndividual] (
    [EntityID]             INT           NOT NULL,
    [Firstname]            VARCHAR (100) NULL,
    [Lastname]             VARCHAR (100) NULL,
    [MiddleName]           VARCHAR (100) NULL,
    [MiddleInitial]        CHAR (1)      NULL,
    [Title]                VARCHAR (100) NULL,
    [SocialSecurityNumber] VARCHAR (12)  CONSTRAINT [DF__EntityInd__Socia__6B0FDBE9] DEFAULT ('') NULL,
    CONSTRAINT [PK_EntityIndividual] PRIMARY KEY CLUSTERED ([EntityID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_EntityIndividual_Entity] FOREIGN KEY ([EntityID]) REFERENCES [dbo].[Entity] ([EntityID])
);

