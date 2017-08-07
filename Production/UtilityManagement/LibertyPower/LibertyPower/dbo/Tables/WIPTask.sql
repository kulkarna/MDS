CREATE TABLE [dbo].[WIPTask] (
    [WIPTaskId]       INT            IDENTITY (1, 1) NOT NULL,
    [WIPTaskHeaderId] INT            NOT NULL,
    [WorkflowTaskId]  INT            NOT NULL,
    [TaskStatusId]    INT            NOT NULL,
    [IsAvailable]     INT            NOT NULL,
    [CreatedBy]       NVARCHAR (50)  NULL,
    [DateCreated]     DATETIME       NULL,
    [UpdatedBy]       NVARCHAR (50)  NULL,
    [DateUpdated]     DATETIME       NULL,
    [AssignedTo]      INT            NULL,
    [TaskComment]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_WIPTask] PRIMARY KEY CLUSTERED ([WIPTaskId] ASC),
    CONSTRAINT [FK_WIPTask_TaskStatus] FOREIGN KEY ([TaskStatusId]) REFERENCES [dbo].[TaskStatus] ([TaskStatusID]),
    CONSTRAINT [FK_WIPTask_WIPTaskHeader] FOREIGN KEY ([WIPTaskHeaderId]) REFERENCES [dbo].[WIPTaskHeader] ([WIPTaskHeaderId]),
    CONSTRAINT [FK_WIPTask_WorkflowTask] FOREIGN KEY ([WorkflowTaskId]) REFERENCES [dbo].[WorkflowTask] ([WorkflowTaskID])
);


GO
CREATE NONCLUSTERED INDEX [WIPTask__WIPTaskHeaderId_I]
    ON [dbo].[WIPTask]([WIPTaskHeaderId] ASC, [WIPTaskId] ASC)
    INCLUDE([TaskStatusId], [IsAvailable], [WorkflowTaskId]);


GO
CREATE NONCLUSTERED INDEX [idx_WIPTaskStatus]
    ON [dbo].[WIPTask]([WorkflowTaskId] ASC, [TaskStatusId] ASC, [WIPTaskId] ASC)
    INCLUDE([WIPTaskHeaderId]);


GO
CREATE NONCLUSTERED INDEX [WIPTask__TaskStatusId_I_WIPTaskHeaderId]
    ON [dbo].[WIPTask]([TaskStatusId] ASC)
    INCLUDE([WIPTaskHeaderId]);

