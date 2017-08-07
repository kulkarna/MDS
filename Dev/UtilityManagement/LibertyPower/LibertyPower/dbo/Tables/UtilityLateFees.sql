CREATE TABLE [dbo].[UtilityLateFees] (
    [ID]            INT IDENTITY (1, 1) NOT NULL,
    [MarketId]      INT NOT NULL,
    [UtilityId]     INT NOT NULL,
    [ApplyLateFees] BIT NULL
);

