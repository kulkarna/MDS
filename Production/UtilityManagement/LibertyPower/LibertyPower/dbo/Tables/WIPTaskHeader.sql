CREATE TABLE [dbo].[WIPTaskHeader] (
    [WIPTaskHeaderId] INT           IDENTITY (1, 1) NOT NULL,
    [ContractTypeId]  INT           NOT NULL,
    [ContractId]      INT           NOT NULL,
    [WorkflowId]      INT           NOT NULL,
    [CreatedBy]       NVARCHAR (50) NULL,
    [DateCreated]     DATETIME      NULL,
    [UpdatedBy]       NVARCHAR (50) NULL,
    [DateUpdated]     DATETIME      NULL,
    CONSTRAINT [PK_WIPTaskHeader] PRIMARY KEY CLUSTERED ([WIPTaskHeaderId] ASC),
    CONSTRAINT [FK_WIPTaskHeader_Contract] FOREIGN KEY ([ContractId]) REFERENCES [dbo].[Contract] ([ContractID]),
    CONSTRAINT [FK_WIPTaskHeader_ContractType] FOREIGN KEY ([ContractTypeId]) REFERENCES [dbo].[ContractType] ([ContractTypeID]),
    CONSTRAINT [FK_WIPTaskHeader_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([WorkflowID])
);


GO
CREATE NONCLUSTERED INDEX [WIPTaskHeader__ContractId]
    ON [dbo].[WIPTaskHeader]([ContractId] ASC);

