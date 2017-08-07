CREATE TABLE [dbo].[VREPromptEnergyPriceCurveValues] (
    [VrePromptEnergyPriceCurveValueID]  INT            IDENTITY (1, 1) NOT NULL,
    [VrePromptEnergyPriceCurveHeaderID] INT            NOT NULL,
    [Date]                              DATETIME       NOT NULL,
    [Value]                             DECIMAL (5, 2) NOT NULL,
    CONSTRAINT [PK_VrePromptEnergyPriceCurveValues] PRIMARY KEY CLUSTERED ([VrePromptEnergyPriceCurveValueID] ASC)
);

