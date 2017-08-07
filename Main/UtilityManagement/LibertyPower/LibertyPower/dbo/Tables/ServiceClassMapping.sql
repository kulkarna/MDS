CREATE TABLE [dbo].[ServiceClassMapping] (
    [ID]             INT        IDENTITY (1, 1) NOT NULL,
    [ServiceClassID] INT        NULL,
    [UtilityID]      INT        NOT NULL,
    [Text]           NCHAR (50) NOT NULL,
    [DateCreated]    DATETIME   NOT NULL
);

