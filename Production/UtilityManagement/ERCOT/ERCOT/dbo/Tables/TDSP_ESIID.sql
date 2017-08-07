CREATE TABLE [dbo].[TDSP_ESIID] (
    [FILEID]              INT            NULL,
    [ESIID]               VARCHAR (100)  NULL,
    [ADDRESS]             VARCHAR (200)  NULL,
    [ADDRESS_OVERFLOW]    VARCHAR (100)  NULL,
    [CITY]                VARCHAR (50)   NULL,
    [STATE]               VARCHAR (10)   NULL,
    [ZIPCODE]             VARCHAR (30)   NULL,
    [DUNS]                VARCHAR (30)   NULL,
    [METER_READ_CYCLE]    VARCHAR (30)   NULL,
    [STATUS]              VARCHAR (30)   NULL,
    [PREMISE_TYPE]        VARCHAR (30)   NULL,
    [POWER_REGION]        VARCHAR (30)   NULL,
    [STATIONCODE]         VARCHAR (64)   NULL,
    [STATIONNAME]         VARCHAR (64)   NULL,
    [METERED]             VARCHAR (10)   NULL,
    [OPEN_SERVICE_ORDERS] VARCHAR (2000) NULL,
    [POLR_CUSTOMER_CLASS] VARCHAR (30)   NULL,
    [AMS_METER_FLAG]      VARCHAR (1)    NULL
);

