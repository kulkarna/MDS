CREATE TABLE [dbo].[LOG_FILE_DROPPED] (
    [ROW_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [FILE_MAP_ID]  INT            NULL,
    [FILE_NAME]    VARCHAR (100)  NULL,
    [DATE_STAMP]   DATETIME       NULL,
    [SEQUENCE_NUM] INT            NULL,
    [ENTITY_ID]    VARCHAR (15)   NOT NULL,
    [SUCCESS]      BIT            NOT NULL,
    [ERROR_MSG]    VARCHAR (1000) NULL,
    [DATE_CREATED] DATETIME       CONSTRAINT [DF_LOG_FILE_DROPPED_DATE_CREATED] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY]   VARCHAR (50)   NULL,
    CONSTRAINT [PK_LOG_FILE_DROPPED] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_LOG_FILE_DROPPED_USAGE_FILE_MAP] FOREIGN KEY ([FILE_MAP_ID]) REFERENCES [dbo].[USAGE_FILE_MAP] ([ROW_ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Log of original files found dropped by user in the drop folder.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'LOG_FILE_DROPPED';

