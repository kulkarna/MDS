﻿CREATE TABLE [dbo].[OE_PRICING_REQUEST_OFFER_HISTORY] (
    [ID]               INT      IDENTITY (1, 1) NOT NULL,
    [PRICE_REQUEST_ID] INT      NOT NULL,
    [DATE_CREATED]     DATETIME CONSTRAINT [DF_OE_OFFER_HISTORY_DATE_CREATED] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_OE_PRICING_REQUEST_OFFER_HISTORY] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

