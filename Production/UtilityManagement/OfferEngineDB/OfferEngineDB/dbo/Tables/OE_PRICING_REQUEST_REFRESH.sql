﻿CREATE TABLE [dbo].[OE_PRICING_REQUEST_REFRESH] (
    [REQUEST_ID]     NVARCHAR (50) NOT NULL,
    [DUE_DATE]       DATETIME      NULL,
    [REFRESH_STATUS] VARCHAR (100) CONSTRAINT [DF_OE_PRICE_REQUEST_REFRESH_REFRESH_STATUS] DEFAULT ('New') NOT NULL,
    [DATE_INSERT]    DATETIME      CONSTRAINT [DF_OE_PRICING_REQUEST_REFRESH_DATE_INSERT] DEFAULT (getdate()) NOT NULL
);
