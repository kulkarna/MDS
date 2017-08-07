﻿CREATE TABLE [Staging].[FirstEnergyNJ] (
    [ID]                       INT          IDENTITY (1, 1) NOT NULL,
    [State]                    VARCHAR (50) NULL,
    [OperatingCompany]         VARCHAR (50) NULL,
    [CustomerNumber]           VARCHAR (50) NULL,
    [LoadProfile]              VARCHAR (50) NULL,
    [PLSCapacity]              VARCHAR (50) NULL,
    [PLSTrans]                 VARCHAR (50) NULL,
    [PeakDemand]               VARCHAR (50) NULL,
    [SupplierName]             VARCHAR (50) NULL,
    [EGSAccountNumber]         VARCHAR (50) NULL,
    [FirstEnergyContractStart] VARCHAR (50) NULL,
    [FirstEnergyContractEnd]   VARCHAR (50) NULL,
    [ContractEndReason]        VARCHAR (50) NULL,
    [TaxExemptPercent]         VARCHAR (50) NULL,
    [BillMethod]               VARCHAR (50) NULL,
    [RateCategory]             VARCHAR (50) NULL,
    [Name1]                    VARCHAR (50) NULL,
    [Name2]                    VARCHAR (50) NULL,
    [BillingAddress1]          VARCHAR (50) NULL,
    [BillingAddress2]          VARCHAR (50) NULL,
    [BillingCity]              VARCHAR (50) NULL,
    [BillingState]             VARCHAR (50) NULL,
    [BillingZip]               VARCHAR (50) NULL,
    [ServiceAddress1]          VARCHAR (50) NULL,
    [ServiceAddress2]          VARCHAR (50) NULL,
    [ServiceCity]              VARCHAR (50) NULL,
    [ServiceState]             VARCHAR (50) NULL,
    [ServiceZip]               VARCHAR (50) NULL,
    [BillingCycle]             VARCHAR (50) NULL,
    [BudgetAmt]                VARCHAR (50) NULL,
    [MultiMeterIndicator]      VARCHAR (50) NULL,
    [MeterNumber]              VARCHAR (50) NULL,
    [Column31]                 VARCHAR (50) NULL,
    [MSGInd]                   VARCHAR (50) NULL,
    [LegacyAccountNumber]      VARCHAR (50) NULL,
    [SupplierID]               VARCHAR (50) NULL,
    [Column35]                 VARCHAR (50) NULL,
    [PLCCapacityFuture]        VARCHAR (50) NULL,
    [ContextDate]              DATETIME     NOT NULL,
    [DateCreated]              DATETIME     DEFAULT (getdate()) NOT NULL,
    [FileImportID]             INT          NULL,
    CONSTRAINT [FI_NJ_id_fk] FOREIGN KEY ([FileImportID]) REFERENCES [dbo].[FileImport] ([ID])
);

