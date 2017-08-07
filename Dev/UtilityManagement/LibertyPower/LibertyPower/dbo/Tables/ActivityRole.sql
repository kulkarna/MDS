CREATE TABLE [dbo].[ActivityRole] (
    [ActivityRoleKey] INT      IDENTITY (1, 1) NOT NULL,
    [RoleID]          INT      NOT NULL,
    [ActivityID]      INT      NOT NULL,
    [DateCreated]     DATETIME CONSTRAINT [DF__ActivityR__DateC__0CDAE408] DEFAULT (getdate()) NOT NULL,
    [DateModified]    DATETIME CONSTRAINT [DF__ActivityR__DateM__17236851] DEFAULT (getdate()) NULL,
    [CreatedBy]       INT      NULL,
    [ModifiedBy]      INT      NULL,
    CONSTRAINT [PK_ActivityRole] PRIMARY KEY CLUSTERED ([ActivityRoleKey] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__ActivityR__RoleI__2DD1C37F] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Role] ([RoleID]),
    CONSTRAINT [FK__ActivityRole_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Role] ([RoleID]),
    CONSTRAINT [FKActivityRole_ActivityID] FOREIGN KEY ([ActivityID]) REFERENCES [dbo].[Activity] ([ActivityKey])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Security', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ActivityRole';

