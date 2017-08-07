CREATE TABLE [dbo].[ExternalEntityType] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (150) NOT NULL,
    [Inactive]    BIT           CONSTRAINT [DF_ExternalEntityType_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated] DATETIME      CONSTRAINT [DF_ExternalEntityType_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   INT           NOT NULL,
    [Modified]    DATETIME      NULL,
    [ModifiedBy]  INT           NULL,
    CONSTRAINT [PK_ExternalEntityType] PRIMARY KEY CLUSTERED ([ID] ASC)
);

