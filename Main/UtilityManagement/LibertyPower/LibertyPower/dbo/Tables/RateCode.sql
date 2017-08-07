CREATE TABLE [dbo].[RateCode] (
    [ID]               INT          IDENTITY (1, 1) NOT NULL,
    [Market]           VARCHAR (16) NOT NULL,
    [Utility]          VARCHAR (32) NOT NULL,
    [Code]             VARCHAR (32) NULL,
    [PricingOption]    VARCHAR (32) NULL,
    [SupplierRateCode] VARCHAR (50) NULL,
    [ProgramNumber]    VARCHAR (16) NULL,
    [PricingGroup]     VARCHAR (16) NULL,
    [ServiceClass]     VARCHAR (50) NULL,
    [ZoneCode]         VARCHAR (16) NULL,
    [MeterType]        VARCHAR (16) NULL,
    [DateCreated]      DATETIME     CONSTRAINT [DF_RateCode_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        INT          NOT NULL,
    [DateModified]     DATETIME     CONSTRAINT [DF_RateCode_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]       INT          NOT NULL,
    CONSTRAINT [PK_RateCode] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ndx_UtilityServiceClassZoneCodeMeterType]
    ON [dbo].[RateCode]([Utility] ASC)
    INCLUDE([ServiceClass], [ZoneCode], [MeterType]) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RateCode';

