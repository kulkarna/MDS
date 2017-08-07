CREATE TABLE [dbo].[ManualRateUpdates] (
    [ManualRateUpdateID] INT            IDENTITY (1, 1) NOT NULL,
    [AccountNumber]      VARCHAR (100)  NOT NULL,
    [ExistingRate]       DECIMAL (8, 6) NOT NULL,
    [ManualRate]         DECIMAL (8, 6) NOT NULL,
    [CreatedBy]          INT            NOT NULL,
    [DateCreated]        DATETIME       CONSTRAINT [DF_ManualRateUpdates_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ManualRateUpdates] PRIMARY KEY CLUSTERED ([ManualRateUpdateID] ASC)
);

