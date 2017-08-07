CREATE TABLE [dbo].[CreditPoR] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [ServiceClassID] INT           NOT NULL,
    [IsPoRAvailable] BIT           CONSTRAINT [DF_CreditPoR_IsPoRAvailable] DEFAULT ((0)) NOT NULL,
    [EffectiveDate]  DATETIME      NULL,
    [DateCreated]    DATETIME      CONSTRAINT [DF_CreditPoR_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      VARCHAR (100) NOT NULL,
    [DateModified]   DATETIME      NULL,
    [ModifiedBy]     VARCHAR (100) NULL,
    CONSTRAINT [PK_CreditPoR] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to lp_common..service_rate_class table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CreditPoR', @level2type = N'COLUMN', @level2name = N'ServiceClassID';

