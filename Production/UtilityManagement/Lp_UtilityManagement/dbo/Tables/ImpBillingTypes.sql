CREATE TABLE [dbo].[ImpBillingTypes] (
    [UtilityCode]                                   NVARCHAR (255) NULL,
    [Driver]                                        NVARCHAR (255) NULL,
    [RateClassCode]                                 NVARCHAR (255) NULL,
    [LoadProfileCode]                               NVARCHAR (255) NULL,
    [TariffCode]                                    NVARCHAR (255) NULL,
    [DefaultBillingType]                            NVARCHAR (255) NULL,
    [LPApprovedBillingTypeBillReady]                NVARCHAR (255) NULL,
    [LPApprovedBillingTypeDual]                     NVARCHAR (255) NULL,
    [LPApprovedBillingTypeRateReady]                NVARCHAR (255) NULL,
    [LPApprovedBillingTypeSupplierConsolidated]     NVARCHAR (255) NULL,
    [UtilityOfferedBillingTypeBillReady]            NVARCHAR (255) NULL,
    [UtilityOfferedBillingTypeDual]                 NVARCHAR (255) NULL,
    [UtilityOfferedBillingTypeRateReady]            NVARCHAR (255) NULL,
    [UtilityOfferedBillingTypeSupplierConsolidated] NVARCHAR (255) NULL,
    [F15]                                           NVARCHAR (255) NULL,
    [F16]                                           NVARCHAR (255) NULL,
    [F17]                                           NVARCHAR (255) NULL
);

