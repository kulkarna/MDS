CREATE TABLE [dbo].[HierarchyNodeLevel] (
    [HierarchyNodeLevelId]  INT           IDENTITY (1, 1) NOT NULL,
    [HierarchyTemplateId]   INT           NOT NULL,
    [ParentId]              INT           NOT NULL,
    [HierarchyNodeTypeId]   INT           NOT NULL,
    [Name]                  NVARCHAR (50) NOT NULL,
    [HierarchyNodeLookupId] INT           NULL,
    CONSTRAINT [PK_NoteTemplate] PRIMARY KEY CLUSTERED ([HierarchyNodeLevelId] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HierarchyNodeLevel_HierarchyNodeLookup] FOREIGN KEY ([HierarchyNodeLookupId]) REFERENCES [dbo].[HierarchyNodeLookup] ([HierarchyNodeLookupId]),
    CONSTRAINT [FK_HierarchyNodeLevel_HierarchyNodeType] FOREIGN KEY ([HierarchyNodeTypeId]) REFERENCES [dbo].[HierarchyNodeType] ([HierarchyNodeTypeId]),
    CONSTRAINT [FK_HierarchyNodeLevel_Template] FOREIGN KEY ([HierarchyTemplateId]) REFERENCES [dbo].[HierarchyTemplate] ([HierarchyTemplateId])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ReportHierarchy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HierarchyNodeLevel';

