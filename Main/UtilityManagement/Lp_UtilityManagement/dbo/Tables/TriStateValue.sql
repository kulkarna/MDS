CREATE TABLE [dbo].[TriStateValue] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Value]            NVARCHAR (20)    NOT NULL,
    [NumericValue]     INT              NOT NULL,
    [Description]      NVARCHAR (255)   NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    CONSTRAINT [PK_TriStateValue] PRIMARY KEY CLUSTERED ([Id] ASC)
);

