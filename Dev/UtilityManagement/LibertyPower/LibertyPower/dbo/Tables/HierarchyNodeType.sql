CREATE TABLE [dbo].[HierarchyNodeType] (
    [HierarchyNodeTypeId] INT           NOT NULL,
    [Name]                NVARCHAR (20) NOT NULL,
    CONSTRAINT [PK_HierarchyNodeType] PRIMARY KEY CLUSTERED ([HierarchyNodeTypeId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ReportHierarchy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HierarchyNodeType';

