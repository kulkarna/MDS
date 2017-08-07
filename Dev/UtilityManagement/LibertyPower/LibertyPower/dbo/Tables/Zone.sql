CREATE TABLE [dbo].[Zone] (
    [ID]       INT          IDENTITY (1, 1) NOT NULL,
    [ZoneCode] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Zone_2] PRIMARY KEY CLUSTERED ([ID] ASC)
);

