CREATE TABLE [dbo].[WorkflowEventTrigger] (
    [WorkflowEventTriggerId] INT           IDENTITY (1, 1) NOT NULL,
    [WorkflowId]             INT           NULL,
    [RequiredTaskId]         INT           NULL,
    [RequiredTaskStatusId]   INT           NULL,
    [AccountEventTypeId]     INT           NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [DateCreated]            DATETIME      NULL,
    [UpdatedBy]              NVARCHAR (50) NULL,
    [DateUpdated]            DATETIME      NULL,
    CONSTRAINT [FK_WorkflowEventTrigger_TaskStatus] FOREIGN KEY ([RequiredTaskStatusId]) REFERENCES [dbo].[TaskStatus] ([TaskStatusID]),
    CONSTRAINT [FK_WorkflowEventTrigger_TaskType] FOREIGN KEY ([RequiredTaskId]) REFERENCES [dbo].[TaskType] ([TaskTypeID]),
    CONSTRAINT [FK_WorkflowEventTrigger_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([WorkflowID])
);

