CREATE TABLE [dbo].[Market] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Market]           VARCHAR (50)     NOT NULL,
    [Description]      VARCHAR (255)    NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    [MarketIdInt]      INT              NULL,
    [IsoId]            UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_Market] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);



