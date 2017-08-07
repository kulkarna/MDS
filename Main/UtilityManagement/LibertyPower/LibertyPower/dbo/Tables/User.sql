CREATE TABLE [dbo].[User] (
    [UserID]       INT              IDENTITY (1, 1) NOT NULL,
    [UserName]     VARCHAR (100)    NOT NULL,
    [Password]     VARCHAR (50)     NULL,
    [Firstname]    VARCHAR (50)     NULL,
    [Lastname]     VARCHAR (50)     NULL,
    [Email]        VARCHAR (100)    NULL,
    [DateCreated]  DATETIME         CONSTRAINT [DF__Users__DateCreat__7AF13DF7] DEFAULT (getdate()) NULL,
    [DateModified] DATETIME         CONSTRAINT [DF__User__DateModifi__19FFD4FC] DEFAULT (getdate()) NULL,
    [CreatedBy]    INT              NULL,
    [ModifiedBy]   INT              NULL,
    [UserType]     VARCHAR (20)     CONSTRAINT [DF__User__UserType__7F16D496] DEFAULT ('') NULL,
    [LegacyID]     INT              CONSTRAINT [DF__User__LegacyID__000AF8CF] DEFAULT ((0)) NULL,
    [isActive]     CHAR (1)         CONSTRAINT [DF_User_isActive] DEFAULT ('Y') NOT NULL,
    [UserGUID]     UNIQUEIDENTIFIER NULL,
    [UserImage]    NCHAR (250)      NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [User__Username_I]
    ON [dbo].[User]([UserName] ASC)
    INCLUDE([Email]);


GO
CREATE NONCLUSTERED INDEX [User_IsActive]
    ON [dbo].[User]([UserID] ASC, [isActive] DESC)
    INCLUDE([Firstname], [Lastname], [UserName]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Security', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'User';

