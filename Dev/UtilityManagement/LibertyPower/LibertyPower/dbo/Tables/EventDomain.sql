CREATE TABLE [dbo].[EventDomain] (
    [EventDomainId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (50)  NOT NULL,
    [Description]   VARCHAR (250) NULL,
    [IsActive]      BIT           CONSTRAINT [DF_EventTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [DateCreated]   DATETIME      CONSTRAINT [DF_EventType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EventTypes] PRIMARY KEY CLUSTERED ([EventDomainId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EventDomain';

