﻿CREATE TABLE [Staging].[FirstEnergyWPPHIECL] (
    [ID]                     INT          IDENTITY (1, 1) NOT NULL,
    [Operating_Company_Code] VARCHAR (10) NULL,
    [Customer_Number]        VARCHAR (30) NULL,
    [Date]                   VARCHAR (10) NULL,
    [est_hb_0000]            VARCHAR (8)  NULL,
    [est_hb_0100]            VARCHAR (8)  NULL,
    [est_hb_0200]            VARCHAR (8)  NULL,
    [est_hb_0300]            VARCHAR (8)  NULL,
    [est_hb_0400]            VARCHAR (8)  NULL,
    [est_hb_0500]            VARCHAR (8)  NULL,
    [est_hb_0600]            VARCHAR (8)  NULL,
    [est_hb_0700]            VARCHAR (8)  NULL,
    [est_hb_0800]            VARCHAR (8)  NULL,
    [est_hb_0900]            VARCHAR (8)  NULL,
    [est_hb_1000]            VARCHAR (8)  NULL,
    [est_hb_1100]            VARCHAR (8)  NULL,
    [est_hb_1200]            VARCHAR (8)  NULL,
    [est_hb_1300]            VARCHAR (8)  NULL,
    [est_hb_1400]            VARCHAR (8)  NULL,
    [est_hb_1500]            VARCHAR (8)  NULL,
    [est_hb_1600]            VARCHAR (8)  NULL,
    [est_hb_1700]            VARCHAR (8)  NULL,
    [est_hb_1800]            VARCHAR (8)  NULL,
    [est_hb_1900]            VARCHAR (8)  NULL,
    [est_hb_2000]            VARCHAR (8)  NULL,
    [est_hb_2100]            VARCHAR (8)  NULL,
    [est_hb_2200]            VARCHAR (8)  NULL,
    [est_hb_2300]            VARCHAR (8)  NULL,
    [ContextDate]            DATETIME     NOT NULL,
    [IsValid]                BIT          DEFAULT ((1)) NOT NULL,
    [DateCreated]            DATETIME     DEFAULT (getdate()) NOT NULL,
    [FileImportID]           INT          NULL,
    CONSTRAINT [WPPHIECL_id_fk] FOREIGN KEY ([FileImportID]) REFERENCES [dbo].[FileImport] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141202-054313]
    ON [Staging].[FirstEnergyWPPHIECL]([FileImportID] ASC, [IsValid] ASC);

