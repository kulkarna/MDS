CREATE TABLE [dbo].[UserRole] (
    [UserRoleID]   INT      IDENTITY (1, 1) NOT NULL,
    [RoleID]       INT      NULL,
    [UserID]       INT      NULL,
    [DateCreated]  DATETIME CONSTRAINT [DF__UserRole__DateCr__7908F585] DEFAULT (getdate()) NULL,
    [DateModified] DATETIME CONSTRAINT [DF__UserRole__DateMo__190BB0C3] DEFAULT (getdate()) NULL,
    [CreatedBy]    INT      NULL,
    [ModifiedBy]   INT      NULL,
    CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED ([UserRoleID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__UserID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK__UserRole] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Role] ([RoleID]),
    CONSTRAINT [FK__UserRole__RoleID__2FBA0BF1] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Role] ([RoleID]),
    CONSTRAINT [FK__UserRole__UserID__2EC5E7B8] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [ndx_UserRoleUserID]
    ON [dbo].[UserRole]([UserID] ASC)
    INCLUDE([RoleID]) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Security', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'UserRole';

