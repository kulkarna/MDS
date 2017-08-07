CREATE TABLE [dbo].[EventError] (
    [EventErrorId]    INT           IDENTITY (1, 1) NOT NULL,
    [EventInstanceId] INT           NOT NULL,
    [ErrorTypeId]     INT           NULL,
    [ErrorMessage]    VARCHAR (MAX) NOT NULL,
    [ErrorDate]       DATETIME      CONSTRAINT [DF_EventError_ErrorDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EventError] PRIMARY KEY CLUSTERED ([EventErrorId] ASC),
    CONSTRAINT [FK_EventError_EventInstance] FOREIGN KEY ([EventInstanceId]) REFERENCES [dbo].[EventInstance] ([EventInstanceId])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EventError';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'For future use when we identify actionable types of errors', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EventError', @level2type = N'COLUMN', @level2name = N'ErrorTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stack trace for the error that occurred', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EventError', @level2type = N'COLUMN', @level2name = N'ErrorMessage';

