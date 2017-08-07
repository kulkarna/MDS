CREATE TABLE [dbo].[WebsiteType] (
    [WebsiteTypeId] INT          IDENTITY (1, 1) NOT NULL,
    [Type]          VARCHAR (50) NOT NULL,
    [Modified]      DATETIME     CONSTRAINT [DF_WebsiteType_Modified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]    INT          NOT NULL,
    [DateCreated]   DATETIME     CONSTRAINT [DF_WebsiteType_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     INT          NOT NULL,
    CONSTRAINT [PK_WebsiteType] PRIMARY KEY CLUSTERED ([WebsiteTypeId] ASC)
);

