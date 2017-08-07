CREATE TABLE [dbo].[LetterSchedule] (
    [LetterScheduleID]      INT IDENTITY (1, 1) NOT NULL,
    [MarketID]              INT NULL,
    [DocumentTypeID]        INT NOT NULL,
    [DaysBeforeContractEnd] INT NULL
);

