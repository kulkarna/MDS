CREATE TABLE [dbo].[VRERUCSettlementCurve] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [MeterReadMonth]  DATETIME         NULL,
    [SettlementMonth] DATETIME         NULL,
    [RUCCharge]       DECIMAL (5, 2)   NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VRERUCSettlementCurve_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              NOT NULL,
    CONSTRAINT [PK_VRERUCSettlementCurve] PRIMARY KEY CLUSTERED ([ID] ASC)
);

