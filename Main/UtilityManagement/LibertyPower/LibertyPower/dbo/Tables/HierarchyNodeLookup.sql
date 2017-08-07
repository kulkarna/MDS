CREATE TABLE [dbo].[HierarchyNodeLookup] (
    [HierarchyNodeLookupId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]                  NVARCHAR (50)  NOT NULL,
    [Description]           NVARCHAR (50)  NULL,
    [LookupQuery]           VARCHAR (1000) NOT NULL,
    CONSTRAINT [PK_HierarchyNodeLookup] PRIMARY KEY CLUSTERED ([HierarchyNodeLookupId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ReportHierarchy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HierarchyNodeLookup';

