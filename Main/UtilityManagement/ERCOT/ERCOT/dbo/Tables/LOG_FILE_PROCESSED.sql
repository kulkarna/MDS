﻿CREATE TABLE [dbo].[LOG_FILE_PROCESSED] (
    [ROW_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [DROPPED_ID]   INT            NOT NULL,
    [FILE_TYPE_ID] INT            NULL,
    [FILE_NAME]    VARCHAR (100)  NULL,
    [DATE_STAMP]   DATETIME       NULL,
    [SUCCESS]      BIT            CONSTRAINT [DF_LOG_FILE_PROCESSED_SUCCEEDED] DEFAULT ((0)) NOT NULL,
    [ERROR_MSG]    VARCHAR (1000) NULL,
    [DATE_CREATED] DATETIME       CONSTRAINT [DF_LOG_FILE_PROCESSED_DATE_CREATED] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY]   VARCHAR (50)   NULL,
    CONSTRAINT [PK_LOG_FILE_PROCESSED] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_LOG_FILE_PROCESSED_LOG_FILE_DROPPED] FOREIGN KEY ([DROPPED_ID]) REFERENCES [dbo].[LOG_FILE_DROPPED] ([ROW_ID]),
    CONSTRAINT [FK_LOG_FILE_PROCESSED_USAGE_FILE_TYPE] FOREIGN KEY ([FILE_TYPE_ID]) REFERENCES [dbo].[USAGE_FILE_TYPE] ([ROW_ID])
);

