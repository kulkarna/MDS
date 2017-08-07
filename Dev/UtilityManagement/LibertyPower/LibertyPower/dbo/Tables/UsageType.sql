CREATE TABLE [dbo].[UsageType] (
    [Value]       INT          NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [Created]     DATETIME     CONSTRAINT [DF_UsageType_Created] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (50) NULL,
    CONSTRAINT [PK_UsageType] PRIMARY KEY CLUSTERED ([Value] ASC) WITH (FILLFACTOR = 90)
);

