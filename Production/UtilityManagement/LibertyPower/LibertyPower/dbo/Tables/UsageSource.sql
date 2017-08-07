CREATE TABLE [dbo].[UsageSource] (
    [Value]       INT          NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [Created]     DATETIME     CONSTRAINT [DF_UsageSource_Created] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (50) NULL,
    CONSTRAINT [PK_UsageSource] PRIMARY KEY CLUSTERED ([Value] ASC) WITH (FILLFACTOR = 90)
);

