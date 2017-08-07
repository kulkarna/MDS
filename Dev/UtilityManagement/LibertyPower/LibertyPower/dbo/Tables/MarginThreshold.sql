CREATE TABLE [dbo].[MarginThreshold] (
    [MarginThresholdID] INT              IDENTITY (1, 1) NOT NULL,
    [UserID]            INT              NOT NULL,
    [MarginLow]         DECIMAL (18, 10) NOT NULL,
    [MarginHigh]        DECIMAL (18, 10) NOT NULL,
    [MarginLimit]       DECIMAL (18, 10) NOT NULL,
    [EffectiveDate]     DATETIME         NOT NULL,
    [ExpirationDate]    DATETIME         NULL
);

