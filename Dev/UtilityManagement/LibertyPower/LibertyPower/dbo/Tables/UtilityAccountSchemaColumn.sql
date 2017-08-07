CREATE TABLE [dbo].[UtilityAccountSchemaColumn] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [FieldName]    VARCHAR (128) NOT NULL,
    [CreatedBy]    INT           CONSTRAINT [DF_UtilityAccountSchemaColumn_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateCreated]  DATETIME      CONSTRAINT [DF_UtilityAccountSchemaColumn_DateCreated] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   INT           CONSTRAINT [DF_UtilityAccountSchemaColumn_ModifiedBy] DEFAULT ((1)) NOT NULL,
    [DateModified] DATETIME      CONSTRAINT [DF_UtilityAccountSchemaColumn_DateModified] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_UtilityAccountSchemaColumn] PRIMARY KEY CLUSTERED ([ID] ASC)
);

