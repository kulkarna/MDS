CREATE TABLE [dbo].[zAuditUtility] (
    [zAuditUtilityID]         INT           IDENTITY (1, 1) NOT NULL,
    [UtilityCode]             VARCHAR (50)  NOT NULL,
    [FullName]                VARCHAR (100) NOT NULL,
    [ShortName]               VARCHAR (50)  NOT NULL,
    [MarketID]                INT           NOT NULL,
    [DunsNumber]              VARCHAR (30)  NULL,
    [EntityId]                VARCHAR (15)  NULL,
    [EnrollmentLeadDays]      INT           NULL,
    [BillingType]             VARCHAR (15)  NULL,
    [AccountLength]           INT           NULL,
    [AccountNumberPrefix]     VARCHAR (10)  NULL,
    [LeadScreenProcess]       VARCHAR (15)  NULL,
    [DealScreenProcess]       VARCHAR (15)  NULL,
    [PorOption]               VARCHAR (3)   NULL,
    [DateCreated]             DATETIME      NULL,
    [UserName]                NCHAR (200)   NULL,
    [InactiveInd]             CHAR (1)      NULL,
    [ActiveDate]              DATETIME      NULL,
    [ChgStamp]                SMALLINT      NULL,
    [MeterNumberRequired]     SMALLINT      NULL,
    [MeterNumberLength]       SMALLINT      NULL,
    [AnnualUsageMin]          INT           NULL,
    [Qualifier]               VARCHAR (50)  NULL,
    [EdiCapable]              SMALLINT      NULL,
    [WholeSaleMktID]          VARCHAR (50)  NULL,
    [Phone]                   VARCHAR (30)  NULL,
    [RateCodeRequired]        TINYINT       NULL,
    [HasZones]                TINYINT       NULL,
    [ZoneDefault]             INT           NULL,
    [RateCodeFormat]          VARCHAR (20)  NOT NULL,
    [RateCodeFields]          VARCHAR (50)  NOT NULL,
    [LegacyName]              VARCHAR (100) NOT NULL,
    [SSNIsRequired]           BIT           NULL,
    [PricingModeID]           INT           NULL,
    [isIDR_EDI_Capable]       BIT           NULL,
    [HU_RequestType]          NCHAR (10)    NULL,
    [MultipleMeters]          BIT           NULL,
    [AuditChangeType]         CHAR (3)      NOT NULL,
    [AuditChangeDate]         DATETIME      CONSTRAINT [DFzAuditUtilityAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]           VARCHAR (30)  CONSTRAINT [DFzAuditUtilityAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]     VARCHAR (30)  CONSTRAINT [DFzAuditUtilityAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]          VARCHAR (MAX) NOT NULL,
    [ColumnsChanged]          VARCHAR (MAX) NOT NULL,
    [AutoApproval]            BIT           NULL,
    [DeliveryLocationRefID]   INT           NULL,
    [SettlementLocationRefID] INT           NULL,
    [DefaultProfileRefID]     INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [idx1]
    ON [dbo].[zAuditUtility]([zAuditUtilityID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditUtilityAuditChangeDate]
    ON [dbo].[zAuditUtility]([AuditChangeDate] ASC);

