CREATE TABLE [dbo].[DailyPricingNotification] (
    [ID]                         INT           IDENTITY (1, 1) NOT NULL,
    [Name]                       VARCHAR (200) NULL,
    [Email]                      VARCHAR (200) NULL,
    [Phone]                      VARCHAR (50)  NULL,
    [NotifyProcessComplete]      TINYINT       CONSTRAINT [DF_DailyPricingNotification_NotifyProcessComplete] DEFAULT ((0)) NOT NULL,
    [NotifyAllProcessesComplete] TINYINT       CONSTRAINT [DF_DailyPricingNotification_NotifyAllProcessesComplete] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DailyPricingNotification] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingNotification';

