CREATE TABLE [dbo].[ZipCode] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [ZipCode]           NVARCHAR (5)   NOT NULL,
    [City]              NVARCHAR (28)  NOT NULL,
    [StateAbbreviation] NVARCHAR (2)   NOT NULL,
    [UtilityId]         NVARCHAR (50)  NULL,
    [UtilityName]       NVARCHAR (100) NULL
);

