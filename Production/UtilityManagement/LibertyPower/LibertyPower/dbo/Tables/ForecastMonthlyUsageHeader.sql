CREATE TABLE [dbo].[ForecastMonthlyUsageHeader] (
    [MonthlyUsageId] INT          IDENTITY (226502, 1) NOT NULL,
    [OfferId]        VARCHAR (50) NOT NULL,
    [AccountNumber]  VARCHAR (50) NOT NULL,
    [Created]        DATETIME     NOT NULL,
    [CreatedBy]      VARCHAR (50) NULL,
    CONSTRAINT [PK_ForecastMonthlyUsageHeader2] PRIMARY KEY CLUSTERED ([MonthlyUsageId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Forecast', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ForecastMonthlyUsageHeader';

