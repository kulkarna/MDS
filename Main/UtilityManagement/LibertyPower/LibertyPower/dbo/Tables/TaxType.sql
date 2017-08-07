CREATE TABLE [dbo].[TaxType] (
    [TaxTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [TypeOfTax] VARCHAR (20) NULL,
    CONSTRAINT [PK_TaxType] PRIMARY KEY CLUSTERED ([TaxTypeID] ASC) WITH (FILLFACTOR = 90)
);

