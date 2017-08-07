﻿CREATE TABLE [dbo].[STATIONSERVICEHIST] (
    [STATIONCODE]  VARCHAR (64) NULL,
    [STARTTIME]    DATETIME     NOT NULL,
    [STOPTIME]     DATETIME     NULL,
    [UFEZONECODE]  VARCHAR (64) NULL,
    [CMZONECODE]   VARCHAR (64) NULL,
    [ADDTIME]      DATETIME     NOT NULL,
    [SUBUFECODE]   VARCHAR (64) NULL,
    [ENTITY_ID]    CHAR (15)    NOT NULL,
    [CREATED]      DATETIME     CONSTRAINT [DF_STATIONSERVICEHIST_CREATED] DEFAULT (getdate()) NULL,
    [ROW_ID]       INT          IDENTITY (1, 1) NOT NULL,
    [PROCESSED_ID] INT          NULL,
    [UIDSETLPOINT] NUMERIC (19) NULL,
    CONSTRAINT [PK_STATIONSERVICEHIST] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_STATIONSERVICEHIST_LOG_FILE_PROCESSED] FOREIGN KEY ([PROCESSED_ID]) REFERENCES [dbo].[LOG_FILE_PROCESSED] ([ROW_ID]),
    CONSTRAINT [IX_STATIONSERVICEHIST] UNIQUE NONCLUSTERED ([STATIONCODE] ASC, [STARTTIME] ASC, [ADDTIME] ASC, [ENTITY_ID] ASC)
);
