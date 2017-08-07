CREATE TABLE [dbo].[Users] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserName]         NVARCHAR (50)    NOT NULL,
    [Password]         NVARCHAR (50)    NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
);

