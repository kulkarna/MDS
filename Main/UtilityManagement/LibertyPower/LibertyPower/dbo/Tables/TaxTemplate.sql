CREATE TABLE [dbo].[TaxTemplate] (
    [TaxTemplateID]  INT            IDENTITY (1, 1) NOT NULL,
    [UtilityID]      INT            NOT NULL,
    [Template]       VARCHAR (20)   NULL,
    [TaxTypeID]      INT            NULL,
    [PercentTaxable] DECIMAL (9, 6) NULL,
    CONSTRAINT [FK_TaxTypeID] FOREIGN KEY ([TaxTypeID]) REFERENCES [dbo].[TaxType] ([TaxTypeID])
);

