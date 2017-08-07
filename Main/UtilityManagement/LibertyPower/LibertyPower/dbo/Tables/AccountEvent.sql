CREATE TABLE [dbo].[AccountEvent] (
    [EventInstanceId]    INT NOT NULL,
    [AccountEventTypeId] INT NOT NULL,
    [AccountId]          INT NOT NULL,
    CONSTRAINT [PK_AccountEvent_1] PRIMARY KEY CLUSTERED ([EventInstanceId] ASC),
    CONSTRAINT [FK_AccountEvent_Account] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_AccountEvent_AccountEventType] FOREIGN KEY ([AccountEventTypeId]) REFERENCES [dbo].[AccountEventType] ([AccountEventTypeId]),
    CONSTRAINT [FK_AccountEvent_EventInstance] FOREIGN KEY ([EventInstanceId]) REFERENCES [dbo].[EventInstance] ([EventInstanceId])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEvent';

