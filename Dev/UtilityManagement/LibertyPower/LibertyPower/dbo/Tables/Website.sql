CREATE TABLE [dbo].[Website] (
    [WebsiteId]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (50)  CONSTRAINT [DF_Website_Name] DEFAULT ('') NOT NULL,
    [WebsiteTypeId] INT           NOT NULL,
    [URL]           VARCHAR (256) NOT NULL,
    [Modified]      DATETIME      CONSTRAINT [DF_Website_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]    INT           NOT NULL,
    [DateCreated]   DATETIME      CONSTRAINT [DF_Website_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     INT           NOT NULL,
    CONSTRAINT [PK_Website] PRIMARY KEY CLUSTERED ([WebsiteId] ASC),
    CONSTRAINT [FK_Website_WebsiteType] FOREIGN KEY ([WebsiteTypeId]) REFERENCES [dbo].[WebsiteType] ([WebsiteTypeId])
);

