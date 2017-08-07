CREATE TABLE [dbo].[PorRecourse] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]             NVARCHAR (255)   NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    [EnumValue]        INT              NOT NULL,
    CONSTRAINT [PK_PorRecourse] PRIMARY KEY CLUSTERED ([Id] ASC)
);





GO
ALTER TABLE [dbo].[PorRecourse] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);



