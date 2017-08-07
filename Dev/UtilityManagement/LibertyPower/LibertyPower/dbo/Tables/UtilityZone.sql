CREATE TABLE [dbo].[UtilityZone] (
    [ID]        INT IDENTITY (1, 1) NOT NULL,
    [UtilityID] INT NOT NULL,
    [ZoneID]    INT NOT NULL,
    CONSTRAINT [PK_UtilityZone] PRIMARY KEY CLUSTERED ([ID] ASC)
);

