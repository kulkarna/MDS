﻿CREATE TABLE [dbo].[OE_ACCOUNT092010] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [ACCOUNT_NUMBER]       VARCHAR (50)    NULL,
    [ACCOUNT_ID]           VARCHAR (50)    NULL,
    [MARKET]               VARCHAR (25)    NULL,
    [UTILITY]              VARCHAR (50)    NULL,
    [METER_TYPE]           VARCHAR (50)    NULL,
    [RATE_CLASS]           VARCHAR (50)    NULL,
    [VOLTAGE]              VARCHAR (50)    NULL,
    [ZONE]                 VARCHAR (50)    NULL,
    [VAL_COMMENT]          NCHAR (256)     NULL,
    [TCAP]                 DECIMAL (18, 9) NULL,
    [ICAP]                 DECIMAL (18, 9) NULL,
    [LOAD_SHAPE_ID]        VARCHAR (50)    NULL,
    [LOSSES]               DECIMAL (18, 9) NULL,
    [ANNUAL_USAGE]         BIGINT          NULL,
    [USAGE_DATE]           DATETIME        NOT NULL,
    [NAME_KEY]             VARCHAR (50)    NOT NULL,
    [STRATUM_VARIABLE]     VARCHAR (50)    NULL,
    [RATE_CODE]            VARCHAR (50)    NULL,
    [BILL_GROUP]           INT             NULL,
    [LOAD_PROFILE]         VARCHAR (50)    NULL,
    [SUPPLY_GROUP]         VARCHAR (255)   NULL,
    [IsIcapEsimated]       SMALLINT        NULL,
    [BillingAccountNumber] VARCHAR (50)    NULL,
    [NeedUsage]            SMALLINT        NOT NULL
);

