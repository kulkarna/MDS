﻿CREATE TABLE [dbo].[ImpUtilityCodes] (
    [ID]                      FLOAT (53)     NULL,
    [UtilityCode]             NVARCHAR (255) NULL,
    [FullName]                NVARCHAR (255) NULL,
    [ShortName]               NVARCHAR (255) NULL,
    [MarketID]                FLOAT (53)     NULL,
    [DunsNumber]              NVARCHAR (255) NULL,
    [EntityId]                NVARCHAR (255) NULL,
    [EnrollmentLeadDays]      FLOAT (53)     NULL,
    [BillingType]             NVARCHAR (255) NULL,
    [AccountLength]           FLOAT (53)     NULL,
    [AccountNumberPrefix]     FLOAT (53)     NULL,
    [LeadScreenProcess]       NVARCHAR (255) NULL,
    [DealScreenProcess]       NVARCHAR (255) NULL,
    [PorOption]               NVARCHAR (255) NULL,
    [Field01Label]            NVARCHAR (255) NULL,
    [Field01Type]             NVARCHAR (255) NULL,
    [Field02Label]            NVARCHAR (255) NULL,
    [Field02Type]             NVARCHAR (255) NULL,
    [Field03Label]            NVARCHAR (255) NULL,
    [Field03Type]             NVARCHAR (255) NULL,
    [Field04Label]            NVARCHAR (255) NULL,
    [Field04Type]             NVARCHAR (255) NULL,
    [Field05Label]            NVARCHAR (255) NULL,
    [Field05Type]             NVARCHAR (255) NULL,
    [Field06Label]            NVARCHAR (255) NULL,
    [Field06Type]             NVARCHAR (255) NULL,
    [Field07Label]            NVARCHAR (255) NULL,
    [Field07Type]             NVARCHAR (255) NULL,
    [Field08Label]            NVARCHAR (255) NULL,
    [Field08Type]             NVARCHAR (255) NULL,
    [Field09Label]            NVARCHAR (255) NULL,
    [Field09Type]             NVARCHAR (255) NULL,
    [Field10Label]            NVARCHAR (255) NULL,
    [Field10Type]             NVARCHAR (255) NULL,
    [DateCreated]             FLOAT (53)     NULL,
    [UserName]                NVARCHAR (255) NULL,
    [InactiveInd]             FLOAT (53)     NULL,
    [ActiveDate]              FLOAT (53)     NULL,
    [ChgStamp]                FLOAT (53)     NULL,
    [MeterNumberRequired]     FLOAT (53)     NULL,
    [MeterNumberLength]       FLOAT (53)     NULL,
    [AnnualUsageMin]          FLOAT (53)     NULL,
    [Qualifier]               NVARCHAR (255) NULL,
    [EdiCapable]              FLOAT (53)     NULL,
    [WholeSaleMktID]          NVARCHAR (255) NULL,
    [Phone]                   NVARCHAR (255) NULL,
    [RateCodeRequired]        FLOAT (53)     NULL,
    [HasZones]                FLOAT (53)     NULL,
    [ZoneDefault]             FLOAT (53)     NULL,
    [Field11Label]            NVARCHAR (255) NULL,
    [Field11Type]             NVARCHAR (255) NULL,
    [Field12Label]            NVARCHAR (255) NULL,
    [Field12Type]             NVARCHAR (255) NULL,
    [Field13Label]            NVARCHAR (255) NULL,
    [Field13Type]             NVARCHAR (255) NULL,
    [Field14Label]            NVARCHAR (255) NULL,
    [Field14Type]             NVARCHAR (255) NULL,
    [Field15Label]            NVARCHAR (255) NULL,
    [Field15Type]             NVARCHAR (255) NULL,
    [RateCodeFormat]          FLOAT (53)     NULL,
    [RateCodeFields]          FLOAT (53)     NULL,
    [LegacyName]              NVARCHAR (255) NULL,
    [SSNIsRequired]           FLOAT (53)     NULL,
    [PricingModeID]           FLOAT (53)     NULL,
    [isIDR_EDI_Capable]       NVARCHAR (255) NULL,
    [HU_RequestType]          NVARCHAR (255) NULL,
    [MultipleMeters]          FLOAT (53)     NULL,
    [MeterReadOverlap]        FLOAT (53)     NULL,
    [AutoApproval]            NVARCHAR (255) NULL,
    [DeliveryLocationRefID]   NVARCHAR (255) NULL,
    [DefaultProfileRefID]     NVARCHAR (255) NULL,
    [SettlementLocationRefID] NVARCHAR (255) NULL
);

