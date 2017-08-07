CREATE TABLE [dbo].[ContractEventType] (
    [ContractEventTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (50)  NOT NULL,
    [Description]         VARCHAR (250) NULL,
    [IsActive]            BIT           CONSTRAINT [DF_ContractEventTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [DateCreated]         DATETIME      CONSTRAINT [DF_ContractEventType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ContractEventType] PRIMARY KEY CLUSTERED ([ContractEventTypeId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ContractEventType';

