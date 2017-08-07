CREATE TABLE [dbo].[ForecastDailyUsageHeader] (
    [DailyUsageId]  INT          IDENTITY (226615, 1) NOT NULL,
    [OfferId]       VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [Created]       DATETIME     CONSTRAINT [DF_ForecastDailyUsageHeader_Created2] DEFAULT (getdate()) NULL,
    [CreatedBy]     VARCHAR (50) NULL,
    CONSTRAINT [PK_ForecastDailyUsageHeader2] PRIMARY KEY CLUSTERED ([DailyUsageId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Forecast', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ForecastDailyUsageHeader';

