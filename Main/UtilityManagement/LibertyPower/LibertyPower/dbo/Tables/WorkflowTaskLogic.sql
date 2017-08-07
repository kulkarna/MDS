CREATE TABLE [dbo].[WorkflowTaskLogic] (
    [WorkflowTaskLogicID] INT           IDENTITY (1, 1) NOT NULL,
    [WorkflowTaskID]      INT           NOT NULL,
    [LogicParam]          NVARCHAR (50) NOT NULL,
    [LogicCondition]      INT           NOT NULL,
    [IsAutomated]         BIT           NOT NULL,
    [IsDeleted]           BIT           NULL,
    [CreatedBy]           NVARCHAR (50) NULL,
    [DateCreated]         DATETIME      NULL,
    [UpdatedBy]           NVARCHAR (50) NULL,
    [DateUpdated]         DATETIME      NULL,
    CONSTRAINT [PK_WorkflowTaskLogic] PRIMARY KEY CLUSTERED ([WorkflowTaskLogicID] ASC),
    CONSTRAINT [FK_WorkflowTaskLogic_WorkflowTask] FOREIGN KEY ([WorkflowTaskID]) REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
);

