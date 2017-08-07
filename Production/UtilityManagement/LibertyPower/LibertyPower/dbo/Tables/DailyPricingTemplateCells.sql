CREATE TABLE [dbo].[DailyPricingTemplateCells] (
    [ID]           INT     IDENTITY (1, 1) NOT NULL,
    [CellPosition] INT     NULL,
    [Term]         INT     NULL,
    [IsTermRange]  TINYINT NULL,
    CONSTRAINT [PK_DailyPricingTemplateCells] PRIMARY KEY CLUSTERED ([ID] ASC)
);

