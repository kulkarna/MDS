CREATE TABLE [dbo].[HierarchyNode] (
    [HierarchyNodeId]      INT            IDENTITY (1, 1) NOT NULL,
    [HierarchyNodeLevelId] INT            NULL,
    [ParentId]             INT            NULL,
    [Value]                NVARCHAR (100) NOT NULL,
    [Description]          NVARCHAR (100) NULL,
    CONSTRAINT [PK_HierarchyNode] PRIMARY KEY CLUSTERED ([HierarchyNodeId] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HierarchyNode_HierarchyNodeLevel] FOREIGN KEY ([HierarchyNodeLevelId]) REFERENCES [dbo].[HierarchyNodeLevel] ([HierarchyNodeLevelId])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ReportHierarchy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HierarchyNode';

