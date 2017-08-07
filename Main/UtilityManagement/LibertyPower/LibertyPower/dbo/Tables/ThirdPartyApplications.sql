CREATE TABLE [dbo].[ThirdPartyApplications] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (150) NOT NULL,
    [DateCreated] DATETIME      CONSTRAINT [DF_ThirdPartyApplications_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   INT           NOT NULL,
    [Modified]    DATETIME      NULL,
    [ModifiedBy]  INT           NULL,
    CONSTRAINT [PK_ThirdPartyApplications] PRIMARY KEY CLUSTERED ([ID] ASC)
);

