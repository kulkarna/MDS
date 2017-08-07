CREATE TABLE [dbo].[RateCodeSchemaColumn] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [FieldName]    VARCHAR (128) NOT NULL,
    [CreatedBy]    INT           CONSTRAINT [DF_RateCodeSchemaColumn_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateCreated]  DATETIME      CONSTRAINT [DF_RateCodeSchemaColumn_DateCreated] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   INT           CONSTRAINT [DF_RateCodeSchemaColumn_ModifiedBy] DEFAULT ((1)) NOT NULL,
    [DateModified] DATETIME      CONSTRAINT [DF_RateCodeSchemaColumn_DateModified] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_RateCodeSchemaColumn] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RateCodeSchemaColumn';

