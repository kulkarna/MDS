﻿CREATE TABLE [dbo].[OE_OFFER_STATUS_MESSAGE] (
    [OFFER_ID]     VARCHAR (50) NOT NULL,
    [STATUS]       VARCHAR (50) NOT NULL,
    [MESSAGE]      TEXT         CONSTRAINT [DF_OE_OFFER_STATUS_MESSAGE_MESSAGE] DEFAULT ('') NOT NULL,
    [DATE_CREATED] DATETIME     CONSTRAINT [DF_OE_OFFER_STATUS_MESSAGE_DATE_CREATED] DEFAULT (getdate()) NOT NULL
);

