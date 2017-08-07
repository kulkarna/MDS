CREATE TABLE [dbo].[DailyPricingCalendar] (
    [ID]        INT      IDENTITY (1, 1) NOT NULL,
    [Date]      DATETIME NOT NULL,
    [IsWorkDay] TINYINT  CONSTRAINT [DF_DailyPricingCalendar_IsWorkDay] DEFAULT ((1)) NOT NULL,
    [IsInQueue] TINYINT  CONSTRAINT [DF_DailyPricingCalendar_IsInQueue] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DailyPricingCalendar] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingCalendar';

