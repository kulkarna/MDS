﻿CREATE TABLE [dbo].[OE_PRICES] (
    [OFFER_ID]               NVARCHAR (50)   NOT NULL,
    [PEAK_PRICE]             NUMERIC (16, 2) NULL,
    [OFF_PEAK_PRICE]         NUMERIC (16, 2) NULL,
    [ATC_PRICE]              NUMERIC (16, 2) NULL,
    [PEAK_MWH]               NUMERIC (16, 2) NULL,
    [OFF_PEAK_MWH]           NUMERIC (16, 2) NULL,
    [ICAP_MW]                NUMERIC (16, 2) NULL,
    [TCAP_MW]                NUMERIC (16, 2) NULL,
    [RISK_1]                 NUMERIC (16, 2) NULL,
    [RISK_2]                 NUMERIC (16, 2) NULL,
    [RISK_3]                 NUMERIC (16, 2) NULL,
    [ICAP]                   NUMERIC (16, 2) NULL,
    [TRANSMISSION]           NUMERIC (16, 2) NULL,
    [ANCILARY_SERVICES]      NUMERIC (16, 2) NULL,
    [OPERATIN_RESERVE]       NUMERIC (16, 2) NULL,
    [RENEWABLE_REQUIREMENTS] NUMERIC (16, 2) NULL,
    [LOOSES]                 NUMERIC (16, 2) NULL,
    [GREEN_FEES]             NUMERIC (16, 2) NULL,
    [OTHER]                  NUMERIC (16, 2) NULL,
    [TOTAL_COST]             NUMERIC (16, 2) NULL,
    [CONSULTANTS_FEE]        NUMERIC (16, 2) NULL,
    [FINANCING_FEE]          NUMERIC (16, 2) NULL,
    [MARKUP]                 NUMERIC (16, 2) NULL,
    [FIXED_PRICE]            NUMERIC (16, 2) NULL,
    [BLOCK_PRICE]            NUMERIC (16, 2) NULL,
    [ADDER_PRICE]            NUMERIC (16, 2) NULL,
    [CONTRIBUTION_MARGIN]    NUMERIC (16, 2) NULL,
    [GROSS_MARGIN]           NUMERIC (16, 2) NULL
);

