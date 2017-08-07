CREATE TABLE [dbo].[DailyPricingProcessConfiguration] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [ProcessId]        INT           NOT NULL,
    [ScheduledRunTime] VARCHAR (100) NULL,
    CONSTRAINT [PK_DailyPricingProcessConfiguration] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingProcessConfiguration';

