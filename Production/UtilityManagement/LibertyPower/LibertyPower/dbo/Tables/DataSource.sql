CREATE TABLE [dbo].[DataSource] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Source]    VARCHAR (50) NULL,
    [Created]   DATETIME     CONSTRAINT [DF_DataSource_Created] DEFAULT (getdate()) NOT NULL,
    [CreatedBy] VARCHAR (50) NULL,
    CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED ([ID] ASC)
);

