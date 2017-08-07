CREATE TABLE [dbo].[Activity] (
    [ActivityKey]  INT          IDENTITY (1, 1) NOT NULL,
    [ActivityDesc] VARCHAR (50) NULL,
    [AppKey]       VARCHAR (20) NULL,
    [DateCreated]  DATETIME     CONSTRAINT [DF__Activity__DateCr__6F7F8B4B] DEFAULT (getdate()) NULL,
    [DateModified] DATETIME     CONSTRAINT [DF__Activity__DateMo__162F4418] DEFAULT (getdate()) NULL,
    [CreatedBy]    INT          NULL,
    [ModifiedBy]   INT          NULL,
    CONSTRAINT [PKActivityKey] PRIMARY KEY CLUSTERED ([ActivityKey] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FKAppKey] FOREIGN KEY ([AppKey]) REFERENCES [dbo].[AppName] ([AppKey])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Security', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Activity';

