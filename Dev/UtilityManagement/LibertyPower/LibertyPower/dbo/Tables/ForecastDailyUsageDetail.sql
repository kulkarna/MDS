CREATE TABLE [dbo].[ForecastDailyUsageDetail] (
    [DailyUsageId] INT             NOT NULL,
    [Date]         DATETIME        NOT NULL,
    [Kwh]          DECIMAL (20, 6) NOT NULL,
    CONSTRAINT [FK_ForecastDailyUsageDetail_ForecastDailyUsageHeader2] FOREIGN KEY ([DailyUsageId]) REFERENCES [dbo].[ForecastDailyUsageHeader] ([DailyUsageId]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Forecast', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ForecastDailyUsageDetail';

