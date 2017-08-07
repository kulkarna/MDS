CREATE TABLE [dbo].[ZoneMapping] (
    [ID]          INT        IDENTITY (1, 1) NOT NULL,
    [ZoneID]      INT        NOT NULL,
    [UtilityID]   INT        NOT NULL,
    [Text]        NCHAR (50) NULL,
    [DateCreated] DATETIME   NOT NULL
);

