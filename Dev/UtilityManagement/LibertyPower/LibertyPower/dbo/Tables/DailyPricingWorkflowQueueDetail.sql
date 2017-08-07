CREATE TABLE [dbo].[DailyPricingWorkflowQueueDetail] (
    [ID]               INT      IDENTITY (1, 1) NOT NULL,
    [WorkflowHeaderID] INT      NOT NULL,
    [ProcessId]        INT      NOT NULL,
    [ScheduledRunTime] DATETIME NOT NULL,
    [Status]           TINYINT  CONSTRAINT [DF_DailyPricingWorkflowQueueDetail_Status] DEFAULT ((0)) NOT NULL,
    [ItemsProcessed]   INT      CONSTRAINT [DF_DailyPricingWorkflowQueueDetail_ItemsProcessed] DEFAULT ((0)) NOT NULL,
    [TotalItems]       INT      NOT NULL,
    [DateStarted]      DATETIME NULL,
    [DateCompleted]    DATETIME NULL,
    CONSTRAINT [PK_DailyPricingWorkflowQueueDetail] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_DailyPricingWorkflowQueueDetail_DailyPricingWorkflowQueueHeader] FOREIGN KEY ([WorkflowHeaderID]) REFERENCES [dbo].[DailyPricingWorkflowQueueHeader] ([ID]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingWorkflowQueueDetail';

