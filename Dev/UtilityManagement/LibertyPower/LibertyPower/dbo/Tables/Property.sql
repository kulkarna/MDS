CREATE TABLE [dbo].[Property] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50) NOT NULL,
    [Inactive]    BIT          CONSTRAINT [DF_Property_Inactive] DEFAULT ((0)) NOT NULL,
    [DateCreated] DATETIME     CONSTRAINT [DF_Property_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   INT          NOT NULL,
    [Modified]    DATETIME     NULL,
    [ModifiedBy]  INT          NULL,
    CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED ([ID] ASC)
);

