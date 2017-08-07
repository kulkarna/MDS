CREATE TABLE [dbo].[DailyPricingDistribution] (
    [DailyPricingDistributionID] INT           IDENTITY (1, 1) NOT NULL,
    [ChannelID]                  INT           NOT NULL,
    [Email]                      VARCHAR (100) NOT NULL,
    [DateCreated]                DATETIME      NOT NULL,
    [CreatedBy]                  INT           NOT NULL,
    CONSTRAINT [PK_DailyPricingDistribution] PRIMARY KEY CLUSTERED ([DailyPricingDistributionID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_ChannelID]
    ON [dbo].[DailyPricingDistribution]([ChannelID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingDistribution';

