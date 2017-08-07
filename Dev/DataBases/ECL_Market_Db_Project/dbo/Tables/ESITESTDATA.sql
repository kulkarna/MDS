CREATE TABLE [dbo].[ESITESTDATA] (
    [ESI ID]            NVARCHAR (255) NULL,
    [Customer Name]     NVARCHAR (255) NULL,
    [Rate Class/Code]   NVARCHAR (255) NULL,
    [Zip Code]          NVARCHAR (255) NULL,
    [Metered KW]        FLOAT (53)     NULL,
    [Actual KWH]        FLOAT (53)     NULL,
    [Billed KW]         FLOAT (53)     NULL,
    [TDSP Charges]      FLOAT (53)     NULL,
    [Start Date]        DATETIME       NULL,
    [End Date]          DATETIME       NULL,
    [Meter Read Cycle]  NVARCHAR (255) NULL,
    [Service Address 1] NVARCHAR (255) NULL,
    [Service Address 2] NVARCHAR (255) NULL,
    [Service Address 3] NVARCHAR (255) NULL,
    [Load Profile]      NVARCHAR (255) NULL,
    [Power Factor]      FLOAT (53)     NULL,
    [ERCOT Region]      NVARCHAR (255) NULL,
    [Metered KVA]       FLOAT (53)     NULL,
    [Billed KVA]        FLOAT (53)     NULL
);

