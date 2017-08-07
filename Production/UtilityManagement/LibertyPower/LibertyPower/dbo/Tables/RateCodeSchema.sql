CREATE TABLE [dbo].[RateCodeSchema] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [UtilityCode]      VARCHAR (128) NOT NULL,
    [FieldNameID]      INT           NOT NULL,
    [IsColumnRequired] BIT           NOT NULL,
    [IsValueRequired]  BIT           NOT NULL,
    [CreatedBy]        INT           CONSTRAINT [DF_RateCodeSchema_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateCreated]      DATETIME      CONSTRAINT [DF_RateCodeSchema_DateCreated] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]       INT           CONSTRAINT [DF_RateCodeSchema_ModifiedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]     DATETIME      CONSTRAINT [DF_RateCodeSchema_DateModified] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_RateCodeSchema] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RateCodeSchema_RateCodeSchemaColumn] FOREIGN KEY ([FieldNameID]) REFERENCES [dbo].[RateCodeSchemaColumn] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RateCodeSchema';

