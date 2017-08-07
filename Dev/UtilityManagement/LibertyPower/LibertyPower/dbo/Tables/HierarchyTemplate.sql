CREATE TABLE [dbo].[HierarchyTemplate] (
    [HierarchyTemplateId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]                NVARCHAR (50)  NOT NULL,
    [Description]         NVARCHAR (150) NULL,
    CONSTRAINT [PK_HierarchyTemplate] PRIMARY KEY CLUSTERED ([HierarchyTemplateId] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ReportHierarchy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HierarchyTemplate';

