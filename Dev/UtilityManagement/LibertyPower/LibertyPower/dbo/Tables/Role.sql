CREATE TABLE [dbo].[Role] (
    [RoleID]       INT           IDENTITY (1, 1) NOT NULL,
    [RoleName]     VARCHAR (50)  NULL,
    [DateCreated]  DATETIME      CONSTRAINT [DF__Role__DateCreate__7720AD13] DEFAULT (getdate()) NULL,
    [DateModified] DATETIME      CONSTRAINT [DF__Role__DateModifi__18178C8A] DEFAULT (getdate()) NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedBy]   INT           NULL,
    [Description]  VARCHAR (100) NULL,
    CONSTRAINT [PK__Role__7F80E8EA] PRIMARY KEY CLUSTERED ([RoleID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Security', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Role';

