﻿CREATE TABLE [Staging].[OEEPICTPENEsidata] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [ESIID]           NVARCHAR (255) NULL,
    [CustomerName]    NVARCHAR (255) NULL,
    [RateClassCode]   NVARCHAR (255) NULL,
    [ZipCode]         NVARCHAR (255) NULL,
    [MeteredKW]       FLOAT (53)     NULL,
    [ActualKWH]       FLOAT (53)     NULL,
    [BilledKW]        FLOAT (53)     NULL,
    [TDSPCharges]     FLOAT (53)     NULL,
    [StartDate]       DATETIME       NULL,
    [EndDate]         DATETIME       NULL,
    [MeterReadCycle]  NVARCHAR (255) NULL,
    [ServiceAddress1] NVARCHAR (255) NULL,
    [ServiceAddress2] NVARCHAR (255) NULL,
    [ServiceAddress3] NVARCHAR (255) NULL,
    [LoadProfile]     NVARCHAR (255) NULL,
    [PowerFactor]     FLOAT (53)     NULL,
    [ERCOTRegion]     NVARCHAR (255) NULL,
    [MeteredKVA]      FLOAT (53)     NULL,
    [BilledKVA]       FLOAT (53)     NULL,
    [ContextDate]     DATETIME       NOT NULL,
    [DateCreated]     DATETIME       DEFAULT (getdate()) NOT NULL,
    [AccountId]       INT            NULL,
    [FileImportID]    INT            NULL,
    CONSTRAINT [OEEPICTPENEsidata_Accountid_fk] FOREIGN KEY ([AccountId]) REFERENCES [Staging].[OEEPICTPENAccount] ([ID]),
    CONSTRAINT [OEEPICTPENEsidata_id_fk] FOREIGN KEY ([FileImportID]) REFERENCES [dbo].[FileImport] ([ID])
);
