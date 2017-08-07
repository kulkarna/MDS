CREATE TABLE [dbo].[VRESupplierPremiumCurveValues] (
    [VreSupplierPremiumCurveValueID]  INT            IDENTITY (1, 1) NOT NULL,
    [VreSupplierPremiumCurveHeaderID] INT            NOT NULL,
    [Date]                            DATETIME       NOT NULL,
    [Value]                           DECIMAL (5, 2) NOT NULL,
    CONSTRAINT [PK_VreSupplierPremiumCurveValues] PRIMARY KEY CLUSTERED ([VreSupplierPremiumCurveValueID] ASC)
);

