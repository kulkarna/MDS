CREATE TABLE [dbo].[UtilityClassMapping] (
    [ID]             INT              IDENTITY (1, 1) NOT NULL,
    [UtilityID]      INT              NULL,
    [RateClassID]    INT              NULL,
    [ServiceClassID] INT              NULL,
    [LoadProfileID]  INT              NULL,
    [LoadShapeID]    INT              NULL,
    [TariffCodeID]   INT              NULL,
    [VoltageID]      INT              NULL,
    [MeterTypeID]    INT              NULL,
    [AccountTypeID]  INT              NULL,
    [LossFactor]     DECIMAL (20, 16) NULL,
    [IsActive]       TINYINT          CONSTRAINT [DF_UtilityClassMappingIsActive] DEFAULT ((1)) NULL,
    [ZoneID]         INT              NULL,
    [DateCreated]    DATETIME         CONSTRAINT [DF_UtilityClassMapping_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_UtilityClassMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

