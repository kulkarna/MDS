CREATE TABLE [dbo].[AppName] (
    [ApplicationKey] INT           IDENTITY (1, 1) NOT NULL,
    [AppKey]         VARCHAR (20)  NOT NULL,
    [AppDescription] VARCHAR (100) NULL,
    [DateCreated]    DATETIME      CONSTRAINT [DF__AppName__DateCre__6D9742D9] DEFAULT (getdate()) NULL,
    [DateModified]   DATETIME      CONSTRAINT [DF__AppName__DateMod__125EB334] DEFAULT (getdate()) NULL,
    [CreatedBy]      INT           NULL,
    [ModifiedBy]     INT           NULL,
    CONSTRAINT [PKAppName] PRIMARY KEY CLUSTERED ([AppKey] ASC) WITH (FILLFACTOR = 90)
);

