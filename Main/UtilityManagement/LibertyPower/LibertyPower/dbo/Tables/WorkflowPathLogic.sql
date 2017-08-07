CREATE TABLE [dbo].[WorkflowPathLogic] (
    [WorkflowPathLogicID]    INT           IDENTITY (1, 1) NOT NULL,
    [WorkflowTaskID]         INT           NOT NULL,
    [WorkflowTaskIDRequired] INT           NOT NULL,
    [ConditionTaskStatusID]  INT           NOT NULL,
    [IsDeleted]              BIT           NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [DateCreated]            DATETIME      NULL,
    [UpdatedBy]              NVARCHAR (50) NULL,
    [DateUpdated]            DATETIME      NULL,
    CONSTRAINT [PK_WorkflowPathLogic] PRIMARY KEY CLUSTERED ([WorkflowPathLogicID] ASC),
    CONSTRAINT [FK_WorkflowPathLogic_TaskStatus] FOREIGN KEY ([ConditionTaskStatusID]) REFERENCES [dbo].[TaskStatus] ([TaskStatusID]),
    CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask] FOREIGN KEY ([WorkflowTaskID]) REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID]),
    CONSTRAINT [FK_WorkflowPathLogic_WorkflowTask_Required] FOREIGN KEY ([WorkflowTaskIDRequired]) REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
);

