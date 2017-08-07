CREATE TABLE [dbo].[AccountEventType] (
    [AccountEventTypeId]  INT           IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (50)  NOT NULL,
    [Description]         VARCHAR (250) NULL,
    [IsUsedForFinancials] BIT           CONSTRAINT [DF_AccountEventType_IsUsedForFinancials] DEFAULT ((0)) NOT NULL,
    [IsActive]            BIT           CONSTRAINT [DF_AccountEventTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [DateCreated]         DATETIME      CONSTRAINT [DF_AccountEventType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AccountEventType] PRIMARY KEY CLUSTERED ([AccountEventTypeId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEventType';

