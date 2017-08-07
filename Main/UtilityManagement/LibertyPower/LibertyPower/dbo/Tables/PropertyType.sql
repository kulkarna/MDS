CREATE TABLE [dbo].[PropertyType] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [PropertyID]  INT          NOT NULL,
    [Name]        VARCHAR (50) NOT NULL,
    [Inactive]    BIT          CONSTRAINT [DF_PropertyType_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated] DATETIME     CONSTRAINT [DF_PropertyType_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [Modified]    DATETIME     NULL,
    [ModifiedBy]  INT          NULL,
    CONSTRAINT [PK_PropertyType] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PropertyType_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([ID])
);

