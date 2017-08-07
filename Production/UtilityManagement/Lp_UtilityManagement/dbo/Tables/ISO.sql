CREATE TABLE [dbo].[ISO] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]             VARCHAR (50)     NOT NULL,
    [Description]      VARCHAR (255)    NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    CONSTRAINT [PK_ISO] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

