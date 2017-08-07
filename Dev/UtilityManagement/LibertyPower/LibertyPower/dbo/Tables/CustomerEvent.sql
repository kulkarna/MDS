CREATE TABLE [dbo].[CustomerEvent] (
    [EventInstanceId]     INT NOT NULL,
    [CustomerEventTypeId] INT NOT NULL,
    [CustomerId]          INT NOT NULL,
    CONSTRAINT [PK_CustomerEvent_1] PRIMARY KEY CLUSTERED ([EventInstanceId] ASC),
    CONSTRAINT [FK_CustomerEvent_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerID]),
    CONSTRAINT [FK_CustomerEvent_CustomerEventType] FOREIGN KEY ([CustomerEventTypeId]) REFERENCES [dbo].[CustomerEventType] ([CustomerEventTypeId]),
    CONSTRAINT [FK_CustomerEvent_EventInstance] FOREIGN KEY ([EventInstanceId]) REFERENCES [dbo].[EventInstance] ([EventInstanceId])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CustomerEvent';

