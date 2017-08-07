CREATE TABLE [dbo].[LoadProfile] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [LoadProfileCode] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_LoadProfile] PRIMARY KEY CLUSTERED ([ID] ASC)
);

