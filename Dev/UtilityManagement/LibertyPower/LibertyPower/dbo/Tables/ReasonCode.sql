CREATE TABLE [dbo].[ReasonCode] (
    [Value]       SMALLINT      IDENTITY (0, 1) NOT NULL,
    [Description] VARCHAR (100) NOT NULL,
    [Created]     DATETIME      CONSTRAINT [DF_ReasonCode_Created] DEFAULT (getdate()) NULL,
    [CreatedBy]   VARCHAR (50)  NULL,
    CONSTRAINT [PK_ReasonCode] PRIMARY KEY CLUSTERED ([Value] ASC)
);

