﻿CREATE TABLE [dbo].[MARKET_FILE_TYPE] (
    [ROW_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [FILE_MAP_ID]  INT           NOT NULL,
    [SEQUENCE_NUM] INT           NOT NULL,
    [PATTERN_NAME] VARCHAR (20)  NOT NULL,
    [FILE_PATTERN] VARCHAR (100) NOT NULL,
    [HAS_STAMP]    BIT           CONSTRAINT [DF_MARKET_FILE_TYPE_HAS_STAMP] DEFAULT ((0)) NOT NULL,
    [STAMP_REGEX]  VARCHAR (100) NULL,
    [STAMP_FORMAT] VARCHAR (100) NULL,
    [ENABLED]      BIT           CONSTRAINT [DF_MARKET_FILE_TYPE_ENABLED] DEFAULT ((0)) NOT NULL,
    [CREATED]      DATETIME      CONSTRAINT [DF_MARKET_FILE_TYPE_CREATED] DEFAULT (getdate()) NULL,
    [CREATED_BY]   VARCHAR (50)  NULL,
    CONSTRAINT [PK_MARKET_FILE_TYPE] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_MARKET_FILE_TYPE_MARKET_FILE_MAP] FOREIGN KEY ([FILE_MAP_ID]) REFERENCES [dbo].[MARKET_FILE_MAP] ([ROW_ID])
);
