CREATE TABLE [dbo].[ContractEvent] (
    [EventInstanceId]     INT NOT NULL,
    [ContractEventTypeId] INT NOT NULL,
    [ContractId]          INT NOT NULL,
    CONSTRAINT [PK_ContractEvent_1] PRIMARY KEY CLUSTERED ([EventInstanceId] ASC),
    CONSTRAINT [FK_ContractEvent_Contract] FOREIGN KEY ([ContractId]) REFERENCES [dbo].[Contract] ([ContractID]),
    CONSTRAINT [FK_ContractEvent_ContractEventType] FOREIGN KEY ([ContractEventTypeId]) REFERENCES [dbo].[ContractEventType] ([ContractEventTypeId]),
    CONSTRAINT [FK_ContractEvent_EventInstance] FOREIGN KEY ([EventInstanceId]) REFERENCES [dbo].[EventInstance] ([EventInstanceId])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ContractEvent';

