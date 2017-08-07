CREATE TABLE [dbo].[WorkflowTask] (
    [WorkflowTaskID] INT           IDENTITY (1, 1) NOT NULL,
    [WorkflowID]     INT           NOT NULL,
    [TaskTypeID]     INT           NOT NULL,
    [TaskSequence]   INT           NOT NULL,
    [IsDeleted]      BIT           NULL,
    [CreatedBy]      NVARCHAR (50) NULL,
    [DateCreated]    DATETIME      NULL,
    [UpdatedBy]      NVARCHAR (50) NULL,
    [DateUpdated]    DATETIME      NULL,
    CONSTRAINT [PK_WorkflowTask] PRIMARY KEY CLUSTERED ([WorkflowTaskID] ASC),
    CONSTRAINT [FK_WorkflowTask_TaskType] FOREIGN KEY ([TaskTypeID]) REFERENCES [dbo].[TaskType] ([TaskTypeID]),
    CONSTRAINT [FK_WorkflowTask_Workflow] FOREIGN KEY ([WorkflowID]) REFERENCES [dbo].[Workflow] ([WorkflowID])
);

