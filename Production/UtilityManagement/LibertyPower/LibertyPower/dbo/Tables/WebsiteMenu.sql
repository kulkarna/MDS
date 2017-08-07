CREATE TABLE [dbo].[WebsiteMenu] (
    [WebsiteMenuId]  INT           IDENTITY (1, 1) NOT NULL,
    [WebsiteId]      INT           NOT NULL,
    [ExternalSiteId] INT           NULL,
    [ParentMenuId]   INT           NULL,
    [Order]          SMALLINT      CONSTRAINT [DF_WebsiteMenu_Order] DEFAULT ((999)) NOT NULL,
    [Title]          VARCHAR (50)  NULL,
    [URL]            VARCHAR (256) NULL,
    [URL2]           VARCHAR (256) NULL,
    [Active]         BIT           CONSTRAINT [DF_WebsiteMenu_Active] DEFAULT ((1)) NOT NULL,
    [Modified]       DATETIME      CONSTRAINT [DF_WebsiteMenu_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]     INT           NOT NULL,
    [DateCreated]    DATETIME      CONSTRAINT [DF_WebsiteMenu_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      INT           NOT NULL,
    CONSTRAINT [PK_WebsiteMenu] PRIMARY KEY CLUSTERED ([WebsiteMenuId] ASC),
    CONSTRAINT [FK_WebsiteMenu_ExternalWebsite] FOREIGN KEY ([ExternalSiteId]) REFERENCES [dbo].[Website] ([WebsiteId]),
    CONSTRAINT [FK_WebsiteMenu_Website] FOREIGN KEY ([WebsiteId]) REFERENCES [dbo].[Website] ([WebsiteId]),
    CONSTRAINT [FK_WebsiteMenu_WebsiteMenu] FOREIGN KEY ([WebsiteMenuId]) REFERENCES [dbo].[WebsiteMenu] ([WebsiteMenuId])
);

