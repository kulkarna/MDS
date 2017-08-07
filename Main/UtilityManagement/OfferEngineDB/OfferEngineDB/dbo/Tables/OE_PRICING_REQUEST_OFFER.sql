﻿CREATE TABLE [dbo].[OE_PRICING_REQUEST_OFFER] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [REQUEST_ID] NVARCHAR (50) NULL,
    [OFFER_ID]   NVARCHAR (50) NULL,
    CONSTRAINT [PK_OE_PRICING_REQUEST_OFFER] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);
