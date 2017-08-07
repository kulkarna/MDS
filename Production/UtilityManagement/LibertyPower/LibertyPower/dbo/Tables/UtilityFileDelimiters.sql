CREATE TABLE [dbo].[UtilityFileDelimiters] (
    [ID]             INT          IDENTITY (1, 1) NOT NULL,
    [UtilityCode]    VARCHAR (50) NULL,
    [RowDelimiter]   CHAR (1)     NULL,
    [FieldDelimiter] CHAR (1)     NULL,
    [Created]        DATETIME     CONSTRAINT [DF_UtilityFileDelimiters_Created] DEFAULT (getdate()) NULL,
    [CreatedBy]      VARCHAR (50) NULL,
    CONSTRAINT [PK_UtilityFileDelimiters] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

