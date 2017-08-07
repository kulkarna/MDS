CREATE TABLE [dbo].[VRESupplierPremiumCurveHeader] (
    [VreSupplierPremiumCurveHeaderID] INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID]                 UNIQUEIDENTIFIER NOT NULL,
    [ISO]                             INT              NULL,
    [Zone]                            VARCHAR (50)     NULL,
    [Market]                          VARCHAR (50)     NULL,
    [UpdatedDate]                     DATETIME         NULL,
    [VrePriceType]                    INT              NOT NULL,
    [CreatedBy]                       INT              NOT NULL,
    [DateCreated]                     DATETIME         CONSTRAINT [DF_VreSupplierPremiumCurveHeader_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_VreSupplierPremiumCurveHeader] PRIMARY KEY CLUSTERED ([VreSupplierPremiumCurveHeaderID] ASC)
);

