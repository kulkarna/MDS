CREATE TABLE [dbo].[WorkFlowStepLogic] (
    [WorkflowStepLogicID] INT           IDENTITY (1, 1) NOT NULL,
    [WorkFlowStepID]      INT           NOT NULL,
    [Description]         NVARCHAR (50) NULL,
    [Enabled]             BIT           NULL,
    [DateCreated]         DATETIME      NULL,
    CONSTRAINT [PK_WorkFlowStepLogic_1] PRIMARY KEY CLUSTERED ([WorkflowStepLogicID] ASC),
    CONSTRAINT [FK_WorkFlowStepLogic_WorkFlowStep] FOREIGN KEY ([WorkFlowStepID]) REFERENCES [dbo].[WorkFlowStep] ([WorkFlowStepID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Workflow', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'WorkFlowStepLogic';

