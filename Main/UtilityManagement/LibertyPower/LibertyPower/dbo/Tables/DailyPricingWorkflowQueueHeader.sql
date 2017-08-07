CREATE TABLE [dbo].[DailyPricingWorkflowQueueHeader] (
    [ID]                           INT      IDENTITY (1, 1) NOT NULL,
    [DailyPricingCalendarIdentity] INT      NOT NULL,
    [EffectiveDate]                DATETIME NOT NULL,
    [ExpirationDate]               DATETIME NOT NULL,
    [WorkDay]                      DATETIME NOT NULL,
    [DateCreated]                  DATETIME CONSTRAINT [DF_DailyPricingWorkflowQueueHeader_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                    INT      NOT NULL,
    [Status]                       TINYINT  CONSTRAINT [DF_DailyPricingWorkflowQueueHeader_Status] DEFAULT ((0)) NOT NULL,
    [DateStarted]                  DATETIME NULL,
    [DateCompleted]                DATETIME NULL,
    CONSTRAINT [PK_DailyPricingWorkflowQueueHeader] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingWorkflowQueueHeader';

