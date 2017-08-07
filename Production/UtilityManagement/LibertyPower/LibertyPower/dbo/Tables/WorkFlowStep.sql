CREATE TABLE [dbo].[WorkFlowStep] (
    [WorkFlowStepID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_WorkFlowStep] PRIMARY KEY CLUSTERED ([WorkFlowStepID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Workflow', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'WorkFlowStep';

