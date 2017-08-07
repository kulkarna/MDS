CREATE TABLE [dbo].[zAuditPurchaseOfReceivables] (
    [Id]                        INT            NOT NULL,
    [UtilityId]                 INT            NOT NULL,
    [DriverTypeId]              INT            NOT NULL,
    [DriverValuePropertyId]     INT            NOT NULL,
    [DriverValueValueId]        INT            NOT NULL,
    [PorOffered]                BIT            NOT NULL,
    [PorParticipated]           BIT            NOT NULL,
    [DoesPorRecourseExist]      BIT            NOT NULL,
    [PorRisk]                   BIT            NOT NULL,
    [PorDiscountRate]           DECIMAL (18)   NULL,
    [PorFlatFee]                DECIMAL (18)   NULL,
    [PorDiscountEffectiveDate]  DATETIME       NULL,
    [PorDiscountExpirationDate] DATETIME       NOT NULL,
    [Inactive]                  BIT            NOT NULL,
    [CreateBy]                  NVARCHAR (255) NULL,
    [CreateDate]                DATETIME       NULL,
    [LastModifiedBy]            NVARCHAR (255) NULL,
    [LastModifiedDate]          DATETIME       NULL
);

