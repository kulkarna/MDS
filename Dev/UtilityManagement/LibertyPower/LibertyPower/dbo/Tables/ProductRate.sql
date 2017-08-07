CREATE TABLE [dbo].[ProductRate] (
    [ProductRateID]          INT           IDENTITY (1, 1) NOT NULL,
    [ProductConfigurationID] INT           NOT NULL,
    [EffectiveDate]          DATETIME      NOT NULL,
    [EffectiveEndDate]       DATETIME      NOT NULL,
    [StartDate]              DATETIME      NOT NULL,
    [Rate]                   FLOAT (53)    NOT NULL,
    [Username]               VARCHAR (200) NULL,
    [DateCreated]            DATETIME      CONSTRAINT [DF_ProductRate_DateCreated] DEFAULT (getdate()) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductRate';

