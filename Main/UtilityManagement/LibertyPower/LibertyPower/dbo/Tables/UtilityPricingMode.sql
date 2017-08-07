CREATE TABLE [dbo].[UtilityPricingMode] (
    [UtilityPricingModeID] INT          NOT NULL,
    [Name]                 VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_UtilityPricingMode] PRIMARY KEY CLUSTERED ([UtilityPricingModeID] ASC) WITH (FILLFACTOR = 90)
);

