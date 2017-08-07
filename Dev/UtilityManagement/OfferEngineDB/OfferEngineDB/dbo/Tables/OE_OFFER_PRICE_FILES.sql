﻿CREATE TABLE [dbo].[OE_OFFER_PRICE_FILES] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [REQUEST_ID]   VARCHAR (50)  NOT NULL,
    [OFFER_ID]     VARCHAR (50)  NOT NULL,
    [FILE_NAME]    VARCHAR (100) NOT NULL,
    [FILE_TYPE]    VARCHAR (50)  NOT NULL,
    [DATE_CREATED] DATETIME      CONSTRAINT [DF_OE_OFFER_PRICE_FILES_DATE_CREATED] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_OE_OFFER_PRICE_FILES] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

