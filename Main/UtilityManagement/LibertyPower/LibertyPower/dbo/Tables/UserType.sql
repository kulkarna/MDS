CREATE TABLE [dbo].[UserType] (
    [UserTypeID]  INT           IDENTITY (1, 1) NOT NULL,
    [TypeOfUser]  VARCHAR (20)  NULL,
    [LegacyID]    INT           CONSTRAINT [DF__UserType__UserID__542C7691] DEFAULT ((0)) NULL,
    [DateCreated] DATETIME      CONSTRAINT [DF__UserType__DateCr__55209ACA] DEFAULT (getdate()) NULL,
    [UserName]    VARCHAR (100) NULL,
    [UserID]      INT           CONSTRAINT [DF__UserType__UserID__6C040022] DEFAULT ((0)) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Security', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'UserType';

