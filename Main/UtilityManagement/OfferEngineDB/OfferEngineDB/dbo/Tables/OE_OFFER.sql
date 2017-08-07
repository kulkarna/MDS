CREATE TABLE [dbo].[OE_OFFER] (
    [ID]                                            INT             IDENTITY (1, 1) NOT NULL,
    [OFFER_ID]                                      NVARCHAR (50)   NOT NULL,
    [PRODUCT]                                       NVARCHAR (50)   NULL,
    [POWER_INDEX]                                   NVARCHAR (10)   NULL,
    [BLOCK_SIZE]                                    NVARCHAR (50)   NULL,
    [PEAK_VALUE]                                    DECIMAL (16, 2) NULL,
    [PEAK_UNIT]                                     NVARCHAR (2)    NULL,
    [OFF_PEAK_VALUE]                                DECIMAL (16, 2) NULL,
    [OFF_PEAK_UNIT]                                 NVARCHAR (2)    NULL,
    [VALUE_24_7]                                    DECIMAL (16, 2) NULL,
    [UNIT_24_7]                                     NVARCHAR (2)    NULL,
    [HENRY_HUB_DAILY]                               NUMERIC (1)     NULL,
    [HENRY_HUB_MONTHLY]                             NUMERIC (1)     NULL,
    [LOOSES_INCLUDED]                               NVARCHAR (50)   NULL,
    [ANCILLARY_SERVICES_INCLUDED]                   NVARCHAR (50)   NULL,
    [ANCILLARY_SERVICES_OPERATING_RESERVE_INCLUDED] NVARCHAR (50)   NULL,
    [CAPACITY]                                      NVARCHAR (50)   NULL,
    [NETWORK_TRANSMISSION_INCLUDED]                 NVARCHAR (50)   NULL,
    [RENEWABLES_INCLUDED]                           NVARCHAR (50)   NULL,
    [BAND_WITH_INCLUDED]                            NVARCHAR (50)   NULL,
    [GAS_INDEX_INCUDED]                             NVARCHAR (50)   NULL,
    [CONSULTANTS_FEE_INCLUDED]                      NVARCHAR (50)   NULL,
    [OTHERS_INCLUDED]                               NVARCHAR (50)   NULL,
    [RENEWABLES_VALUE]                              DECIMAL (16, 2) NULL,
    [BAND_WITH_VALUE]                               DECIMAL (16, 2) NULL,
    [CONSULTANTS_FEE_VALUE]                         DECIMAL (16, 2) NULL,
    [OTHERS_VALUE]                                  NVARCHAR (50)   NULL,
    [LOSSES]                                        DECIMAL (18)    NULL,
    [STATUS]                                        NVARCHAR (50)   NULL,
    [DATE_CREATED]                                  DATETIME        CONSTRAINT [DF_OE_OFFER_DATE_CREATED] DEFAULT (getdate()) NULL,
    [IS_REFRESH]                                    TINYINT         CONSTRAINT [DF_OE_OFFER_IS_REFRESH] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_OE_OFFER] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OE_OFFER_99_1995154153__K2_29]
    ON [dbo].[OE_OFFER]([OFFER_ID] ASC)
    INCLUDE([STATUS]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OE_OFFER_99_1995154153__K29_K2]
    ON [dbo].[OE_OFFER]([STATUS] ASC, [OFFER_ID] ASC) WITH (FILLFACTOR = 90);

