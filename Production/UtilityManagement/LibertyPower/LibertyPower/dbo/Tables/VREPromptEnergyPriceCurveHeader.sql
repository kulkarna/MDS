CREATE TABLE [dbo].[VREPromptEnergyPriceCurveHeader] (
    [VrePromptEnergyPriceCurveHeaderID] INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID]                   UNIQUEIDENTIFIER NOT NULL,
    [EffectiveDate]                     DATETIME         NOT NULL,
    [ISO]                               INT              NULL,
    [Zone]                              VARCHAR (50)     NULL,
    [VrePriceType]                      INT              NOT NULL,
    [SpotBOMPrice]                      DECIMAL (5, 2)   NULL,
    [CreatedBy]                         INT              NOT NULL,
    [DateCreated]                       DATETIME         CONSTRAINT [DF_VrePromptEnergyPriceCurves_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_VrePromptEnergyPriceCurves] PRIMARY KEY CLUSTERED ([VrePromptEnergyPriceCurveHeaderID] ASC)
);

