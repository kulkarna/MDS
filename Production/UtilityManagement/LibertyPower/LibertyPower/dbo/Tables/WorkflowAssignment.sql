CREATE TABLE [dbo].[WorkflowAssignment] (
    [WorkflowAssignmentId]   INT           IDENTITY (1, 1) NOT NULL,
    [WorkflowId]             INT           NOT NULL,
    [MarketId]               INT           NULL,
    [UtilityId]              INT           NULL,
    [ContractTypeId]         INT           NOT NULL,
    [ContractDealTypeId]     INT           NOT NULL,
    [ContractTemplateTypeId] INT           NOT NULL,
    [CreatedBy]              NVARCHAR (50) NULL,
    [DateCreated]            DATETIME      NULL,
    [UpdatedBy]              NVARCHAR (50) NULL,
    [DateUpdated]            DATETIME      NULL,
    CONSTRAINT [PK_WorkflowAssignment] PRIMARY KEY CLUSTERED ([WorkflowAssignmentId] ASC),
    CONSTRAINT [FK_WorkflowAssignment_ContractType] FOREIGN KEY ([ContractTypeId]) REFERENCES [dbo].[ContractType] ([ContractTypeID]),
    CONSTRAINT [FK_WorkflowAssignment_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([WorkflowID])
);

