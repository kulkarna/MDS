CREATE TABLE [dbo].[DailyPricingWorkflowConfiguration] (
    [ID]    INT           IDENTITY (1, 1) NOT NULL,
    [Key]   INT           NOT NULL,
    [Value] VARCHAR (200) NULL,
    CONSTRAINT [PK_DailyPricingWorkflowConfiguration] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingWorkflowConfiguration';

