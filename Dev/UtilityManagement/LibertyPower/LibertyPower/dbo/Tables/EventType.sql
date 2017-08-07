CREATE TABLE [dbo].[EventType] (
    [Id]                   INT            IDENTITY (1, 1) NOT NULL,
    [EventTypeName]        NVARCHAR (50)  NOT NULL,
    [EventTypeDescription] NVARCHAR (255) NOT NULL,
    [Inactive]             BIT            NOT NULL,
    [CreateBy]             NVARCHAR (255) NULL,
    [CreateDate]           DATETIME       NULL,
    [LastModifiedBy]       NVARCHAR (255) NULL,
    [LastModifiedDate]     DATETIME       NULL,
    CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

