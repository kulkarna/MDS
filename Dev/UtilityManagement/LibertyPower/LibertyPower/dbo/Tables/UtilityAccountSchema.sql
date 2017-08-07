CREATE TABLE [dbo].[UtilityAccountSchema] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Context]      VARCHAR (50)  NULL,
    [UtilityCode]  VARCHAR (128) NOT NULL,
    [FieldNameID]  INT           NOT NULL,
    [IsRequired]   BIT           NOT NULL,
    [CreatedBy]    INT           CONSTRAINT [DF_UtilityAccountSchema_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateCreated]  DATETIME      CONSTRAINT [DF_UtilityAccountSchema_DateCreated] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   INT           CONSTRAINT [DF_UtilityAccountSchema_ModifiedBy] DEFAULT ((1)) NOT NULL,
    [DateModified] DATETIME      CONSTRAINT [DF_UtilityAccountSchema_DateModified] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_UtilityAccountSchema] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_UtilityAccountSchema_UtilityAccountSchemaColumn] FOREIGN KEY ([FieldNameID]) REFERENCES [dbo].[UtilityAccountSchemaColumn] ([ID])
);

