﻿CREATE TABLE [dbo].[SETLPOINTTYPE] (
    [UIDSETLPOINTTYPE] NUMERIC (19) NOT NULL,
    [SETLPOINTTYPE]    VARCHAR (8)  NOT NULL,
    [DESCRIPTION]      VARCHAR (64) NOT NULL,
    [LSTIME]           DATETIME     NULL,
    [CREATED]          DATETIME     CONSTRAINT [DF_SETLPOINTTYPE_CREATED] DEFAULT (getdate()) NULL,
    [ROW_ID]           INT          IDENTITY (1, 1) NOT NULL,
    [PROCESSED_ID]     INT          NULL,
    CONSTRAINT [PK_SETLPOINTTYPE] PRIMARY KEY CLUSTERED ([ROW_ID] ASC)
);
