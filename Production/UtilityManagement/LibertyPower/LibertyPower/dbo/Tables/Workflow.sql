CREATE TABLE [dbo].[Workflow] (
    [WorkflowID]          INT           IDENTITY (1, 1) NOT NULL,
    [WorkflowName]        NVARCHAR (25) NOT NULL,
    [WorkflowDescription] NVARCHAR (50) NOT NULL,
    [IsActive]            BIT           NOT NULL,
    [Version]             NCHAR (5)     NOT NULL,
    [IsRevisionOfRecord]  BIT           NOT NULL,
    [IsDeleted]           BIT           NULL,
    [CreatedBy]           NVARCHAR (50) NULL,
    [DateCreated]         DATETIME      NULL,
    [UpdatedBy]           NVARCHAR (50) NULL,
    [DateUpdated]         DATETIME      NULL,
    CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED ([WorkflowID] ASC)
);

