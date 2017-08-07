﻿CREATE TABLE [dbo].[OE_OFFER_REFRESH_LOG] (
    [ID]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [OFFER_ID]         NVARCHAR (50) NOT NULL,
    [OFFER_ID_REFRESH] NVARCHAR (50) NOT NULL,
    [DATE_CREATED]     DATETIME      CONSTRAINT [DF_OE_OFFER_REFRESH_LOG_DATE_CREATED] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_OE_OFFER_REFRESH_LOG] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);
